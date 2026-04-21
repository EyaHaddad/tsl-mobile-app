import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../camera/camera_service.dart';
import '../models/managers/sequence_manager.dart';
import '../models/result_model.dart';
import 'inference_service.dart';
import 'mediapipe_service.dart';
import 'tflite_service.dart';
import '../../../core/services/text_to_speech_service.dart';

// Coordinates the whole real-time pipeline:
// Camera -> MediaPipe -> Sequence -> TFLite -> Inference (post-processing)
class RecognitionController {
  final CameraService cameraService;
  final MediaPipeService mediaPipeService;
  final TFLiteService tfliteService;
  final SequenceManager sequenceManager;
  final InferenceService inferenceService;

  bool _isRunning = false;
  bool _isBusy = false;
  bool _isHandlingFrame = false; // VERROU: Empêche l'accumulation de frames
  DateTime? _lastProcessedTime;
  static const int _minFrameDelayMs = 200; // AUGMENTÉ: 200ms = 5 FPS (Exynos M12 limite)
  
  // DEBUG: Frame counters
  int _totalFramesReceived = 0;
  int _framesProcessed = 0;
  int _framesWithValidLandmarks = 0;
  int _inferenceCount = 0;

  // Stream results for UI to listen
  late final StreamController<RecognitionResultData> _resultController;

  RecognitionController({
    required this.cameraService,
    required this.mediaPipeService,
    required this.tfliteService,
    required this.sequenceManager,
    required this.inferenceService,
  }) {
    // Initialize result stream controller
    _resultController = StreamController<RecognitionResultData>.broadcast();
  }

  bool get isRunning => _isRunning;

  /// Stream of recognition results for UI consumption
  Stream<RecognitionResultData> get resultStream => _resultController.stream;

  // Prepares services and metadata
  Future<void> initialize({
    required String modelPath,
    String metadataAssetPath = TFLiteService.defaultMetadataAssetPath,
  }) async {
    try {
      await mediaPipeService.initialize();
      await tfliteService.initialize(
        modelPath,
        metadataAssetPath: metadataAssetPath,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Starts listening to camera frames and processing recognition pipeline
  Future<void> start() async {
    if (_isRunning) return;

    _isRunning = true;
    _isHandlingFrame = false; // Réinitialise le verrou
    _lastProcessedTime = null; // Reset throttle timer
    _totalFramesReceived = 0;
    _framesProcessed = 0;
    _framesWithValidLandmarks = 0;
    _inferenceCount = 0;
    print('═══════════════════════════════════════════════════════════');
    print('🎬 [START] Pipeline commencée - en écoute des frames caméra');
    print('🔒 [LOCK] Verrou initialisé (prêt à recevoir frames)');
    print('═══════════════════════════════════════════════════════════');
    try {
      await cameraService.startImageStream((CameraImage image) async {
        // VERROU: DROP la frame si on est déjà occupé à traiter une autre
        if (_isHandlingFrame) {
          print('⏭️ [LOCK] Frame #${_totalFramesReceived + 1} DROP (traitement précédent en cours)');
          return;
        }

        // Throttle: ne traite qu'une frame tous les 200ms (5 FPS)
        final now = DateTime.now();
        final lastTime = _lastProcessedTime;
        final shouldProcessFrame = lastTime == null || 
            now.difference(lastTime).inMilliseconds >= _minFrameDelayMs;
        
        if (!shouldProcessFrame) {
          return; // Skip this frame, throttle not elapsed
        }

        // ACQUIRE LOCK - Marque que l'on traite une frame
        _isHandlingFrame = true;
        _lastProcessedTime = now;
        
        try {
          // Non-blocking frame processing
          unawaited(_processFrame(image));
        } catch (e) {
          print('❌ [STREAM] Erreur lors du push du frame: $e');
          _isHandlingFrame = false; // Libère le verrou en cas d'erreur
        }
      });
    } catch (e) {
      _isRunning = false;
      rethrow;
    }
  }

  // Process a single camera frame through the entire pipeline
  Future<void> _processFrame(CameraImage image) async {
    if (!_isRunning) {
      _isHandlingFrame = false;
      return;
    }

    _totalFramesReceived++;
    try {
      // Convert CameraImage to byte array
      final frameBytes = await _resolveImageBytes(image);
      if (frameBytes == null || frameBytes.isEmpty) {
        print('❌ [CAMERA] Frame $_totalFramesReceived IGNORÉE - pas de bytes!');
        return;
      }

      // DIAGNOSTIC: Vérifier si frames arrivent et leur format
      print('📥 [CAMERA] Frame #$_totalFramesReceived | Format: ${image.format.group} | Dims: ${image.width}x${image.height} | Size: ${frameBytes.length} bytes');

      // Call existing frame processor with image metadata
      _framesProcessed++;
      final result = await processFrameBytes(
        frameBytes,
        width: image.width,
        height: image.height,
        rotation: 90, // Android camera typically needs 90° rotation for Portrait
      );

      // Emit result to stream for UI listening
      if (result != null) {
        _resultController.add(result);
        print('🎯 [RESULT] ${result.primaryGesture} | Confiance: ${(result.primaryConfidence * 100).toStringAsFixed(1)}%');
        
        // TTS: Fire and forget (asynchrone, ne bloque pas la reconnaissance)
        // Utilise unawaited pour indiquer intentionnellement qu'on n'attend pas
        unawaited(TextToSpeechService.instance.speak(result.primaryGestureAr));
        
        if (kDebugMode) {
          print(
            'Recognition: ${result.primaryGesture} '
            '(${(result.primaryConfidence * 100).toStringAsFixed(1)}%)',
          );
        }
      }
    } catch (e) {
      print('❌ [ERROR] Erreur lors du traitement du frame: $e');
      if (kDebugMode) print('Stack trace: ${StackTrace.current}');
    } finally {
      // RELEASE LOCK - Libère le verrou pour que la frame suivante puisse être traitée
      print('🔓 [LOCK] Frame #$_totalFramesReceived traitée - verrou libéré');
      _isHandlingFrame = false;
    }
  }

  // Stops listening to camera frames
  Future<void> stop() async {
    _isRunning = false;
    _isHandlingFrame = false; // Réinitialise le verrou
    if (cameraService.isStreamingImages) {
      await cameraService.stopImageStream();
    }
    sequenceManager.reset();
    inferenceService.resetMetrics();
    print('═══════════════════════════════════════════════════════════');
    print('⏹️ [STOP] Pipeline arrêtée');
    print('📊 [STATS] Frames reçues: $_totalFramesReceived');
    print('📊 [STATS] Frames traitées: $_framesProcessed');
    print('📊 [STATS] Frames avec landmarks: $_framesWithValidLandmarks');
    print('📊 [STATS] Inférences TFLite: $_inferenceCount');
    print('═══════════════════════════════════════════════════════════');
  }

  // Processes one frame bytes and returns prediction when a full window is ready
  // This is the core inference pipeline
  Future<RecognitionResultData?> processFrameBytes(
    Uint8List encodedFrame, {
    int width = 320,
    int height = 240,
    int rotation = 0,
  }) async {
    if (!_isRunning) {
      return null;
    }
    
    // NOTE: Ne pas vérifier _isBusy ici! 
    // On est DÉJÀ dans _processFrame qui a mis _isBusy=true.
    // Cette vérification empêcherait detectFrameFeatures d'être appelée!

    try {
      // Step 1: Extract hand landmarks from frame (MediaPipe)
      print('🔄 [PIPE] Appel detectFrameFeatures avec ${encodedFrame.length} bytes (${width}x${height}, rotation: ${rotation}°)...');
      final frameFeatures = await mediaPipeService.detectFrameFeatures(
        encodedFrame,
        width: width,
        height: height,
        rotation: rotation,
      );

      // DIAGNOSTIC: Vérifier ce que MediaPipe retourne
      final nonZeroFeatures = frameFeatures.where((f) => f != 0.0).length;
      final hasValidLandmarks = nonZeroFeatures > 0;
      
      if (hasValidLandmarks) {
        _framesWithValidLandmarks++;
        print('✅ [MEDIAPIPE] Landmarks détectés! $nonZeroFeatures features non-zéro');
      } else {
        print('⚠️ [MEDIAPIPE] Aucun landmark détecté - frame tous les zéros');
      }

      // Step 2: Add features to sequence buffer
      // Returns true when window is ready and stride condition is met
      final shouldInfer = sequenceManager.addFrameFeatures(frameFeatures);
      
      // DEBUG: Show buffer status
      print('📦 [BUFFER] Accumulation: ${sequenceManager.windowLength}/10 frames | Landmarks: $hasValidLandmarks | Prêt: $shouldInfer');
      
      if (!shouldInfer) {
        return null; // Window not ready yet
      }

      // Step 3: Build normalized sequence (10 x 126)
      final sequenceInput = sequenceManager.buildModelInput2D();
      if (sequenceInput == null) {
        return null;
      }

      // Step 4: Run LSTM inference (TFLite)
      _inferenceCount++;
      print('🧠 [TFLITE] Lancement inférence #$_inferenceCount avec 10 frames accumulés');
      final rawResult = await tfliteService.runInference(sequenceInput);
      print('✓ [TFLITE] Inférence #$_inferenceCount terminée');

      // Step 5: Apply post-processing (thresholding, smoothing, FPS limiting)
      final postProcessedResult = inferenceService.applyPostProcessing(
        rawResult,
      );

      return postProcessedResult;
    } catch (e) {
      if (kDebugMode) print('Inference pipeline error: $e');
      return null;
    }
  }

  // Get current inference metrics (FPS, latency, dropped frames)
  InferenceMetrics getMetrics() {
    return inferenceService.currentMetrics();
  }

  Future<void> dispose() async {
    await stop();
    await mediaPipeService.dispose();
    tfliteService.dispose();
    await _resultController.close();
  }

  // ============================================================================
  // HELPER: Extract luminance plane from CameraImage (YUV to Grayscale)
  // ============================================================================

  /// Extracts only the luminance (Y) plane from a CameraImage.
  /// This creates a lightweight grayscale image that Exynos 850 can process instantly.
  Future<Uint8List?> _resolveImageBytes(dynamic image) async {
    if (image == null) {
      print('❌ [DEBUG] Image est NULL!');
      return null;
    }
    
    if (image is Uint8List) {
      print('📦 [DEBUG] Uint8List directe: ${image.length} bytes');
      return image;
    }

    // Extraction spécifique pour Android (Samsung M12)
    if (image is CameraImage) {
      try {
        // Vérifier que planes existe et n'est pas vide
        if (image.planes.isEmpty) {
          print('❌ [DEBUG] CameraImage.planes est VIDE!');
          return null;
        }
        
        final plane0 = image.planes[0];
        final bytes = plane0.bytes;
        
        if (bytes.isEmpty) {
          print('❌ [DEBUG] CameraImage.planes[0].bytes est VIDE!');
          return null;
        }
        
        // Le Plan 0 est la luminance. MediaPipe détecte très bien les mains en NB.
        print('📸 [DEBUG] Plan Y extrait: ${bytes.length} bytes (${image.width}x${image.height})');
        return bytes;
      } catch (e) {
        print("❌ [DEBUG] Exception accès caméra: $e");
        return null;
      }
    }
    
    print('❌ [DEBUG] Type image non supporté: ${image.runtimeType}');
    return null;
  }
}
