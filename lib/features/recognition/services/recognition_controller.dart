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

  // HAND LOSS TRACKING
  int _frameCountMissingHand = 0; // Compte les frames sans main détectée
  static const int _maxMissingHandFrames = 5; // Reset buffer si main perdue > 5 frames

  // LSTM SLIDING WINDOW BUFFER
  final List<List<double>> _frameBuffer = []; // Stocke les 126 landmarks de chaque frame
  static const int _requiredFrames = 10; // Taille de la fenêtre glissante LSTM
  int _bufferFilledCount = 0; // Compte combien de fois le buffer a été plein et inférence lancée

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
    
    // LSTM buffer initialization
    _frameBuffer.clear();
    _bufferFilledCount = 0;
    _frameCountMissingHand = 0; // Reset hand loss counter
    
    print('═══════════════════════════════════════════════════════════');
    print('🎬 [START] Pipeline commencée - en écoute des frames caméra');
    print('🔒 [LOCK] Verrou initialisé (prêt à recevoir frames)');
    print('📊 [BUFFER] LSTM buffer initialisé (0/$_requiredFrames frames)');
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
    print('📊 [BUFFER] Buffer rempli $_bufferFilledCount fois');
    print('📊 [BUFFER] Frames restantes au stop: ${_frameBuffer.length}/$_requiredFrames');
    print('═══════════════════════════════════════════════════════════');
    _frameBuffer.clear();
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

      // ═══════════════════════════════════════════════════════════════════════════
      // STEP 2: LSTM SLIDING WINDOW BUFFER (Fenêtre Glissante)
      // ═══════════════════════════════════════════════════════════════════════════
      if (hasValidLandmarks && frameFeatures.isNotEmpty) {
        // ✅ FORCER LA COMPLÉTION À 126 FEATURES (Critical Fix)
        // Si une seule main est détectée, on a 63 points (21 landmarks * 3 coords)
        // Le modèle LSTM attend 126 (2 mains * 21 landmarks * 3 coords)
        if (frameFeatures.length < 126) {
          final missing = 126 - frameFeatures.length;
          frameFeatures.addAll(List.filled(missing, 0.0));
          print('补 [FIX] Vecteur complété à 126 avec $missing zéros (une main manquante)');
        }
        
        if (frameFeatures.length > 126) {
          print('⚠️ [WARNING] frameFeatures dépasse 126: ${frameFeatures.length}');
          frameFeatures.removeRange(126, frameFeatures.length);
        }
        
        // ✅ POINT B: Validate padding success
        if (frameFeatures.length != 126) {
          print('❌ [PADDING_FAIL] Could not pad to 126, got ${frameFeatures.length}');
          return null;
        }

        // ✅ Check for suspiciously low landmarks (data quality)
        final nonZeroCount = frameFeatures.where((f) => f != 0.0).length;
        if (nonZeroCount < 10) {
          print('⚠️ [SUSPICIOUS_DATA] Only $nonZeroCount non-zero landmarks (expected ~60+)');
        }

        // ✅ POINT A: Memory - verify buffer limits
        if (_frameBuffer.length > 15) {
          print('⚠️ [MEMORY_WARNING] Buffer oversized: ${_frameBuffer.length} (clearing)');
          _frameBuffer.clear();
          return null;
        }
        
        // ✅ On a une main ! On l'ajoute au buffer
        _frameBuffer.add(frameFeatures);
        _frameCountMissingHand = 0; // Reset le compteur de main perdue
        
        // FENÊTRE GLISSANTE: Garder MAX 10 frames en enlevant la plus ancienne si dépasse
        if (_frameBuffer.length > _requiredFrames) {
          _frameBuffer.removeAt(0);
          print('📦 [BUFFER] Sliding: Removed oldest, now ${_frameBuffer.length}/$_requiredFrames');
        } else {
          print('📦 [BUFFER] Accumulation: ${_frameBuffer.length}/$_requiredFrames');
        }
        
        // DÉCLENCHEMENT DE L'INFÉRENCE quand buffer plein ET pas déjà occupé
        if (_frameBuffer.length == _requiredFrames && !_isBusy) {
          await _runInference();
        }
        
        return null; // Pas de résultat ici, _runInference retourne async
        
      } else {
        // ❌ Pas de main détectée
        print('⚠️ [BUFFER] Frame ignorée (Pas de landmarks)');
        
        // Optionnel : Si on perd la main trop longtemps, on reset
        if (_frameBuffer.isNotEmpty) {
          _frameCountMissingHand++;
          print('⏱️ [BUFFER] Main perdue: $_frameCountMissingHand/$_maxMissingHandFrames frames');
          
          if (_frameCountMissingHand > _maxMissingHandFrames) {
            // Si on perd la main pendant trop longtemps
            _frameBuffer.clear();
            print('🧹 [BUFFER] Reset (Main perdue $_frameCountMissingHand frames)');
            _frameCountMissingHand = 0; // Reset le compteur
          }
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) print('Inference pipeline error: $e');
      return null;
    }
  }

  /// ═══════════════════════════════════════════════════════════════════════════
  /// STEP 3: LSTM INFERENCE (Méthode séparée pour isolation)
  /// ═══════════════════════════════════════════════════════════════════════════
  Future<void> _runInference() async {
    _isBusy = true;
    
    try {
      // Sécurité: Vérifier que le buffer est toujours plein
      if (_frameBuffer.length != _requiredFrames) {
        print('❌ [LSTM] Invalid buffer size: ${_frameBuffer.length}/$_requiredFrames');
        return;
      }

      _inferenceCount++;
      
      // Créer une copie profonde pour éviter les conflits de mémoire
      // (le buffer continue à être modifié pendant l'inférence)
      final inputSequence = List<List<double>>.from(_frameBuffer);
      
      print('🧠 [LSTM] Inférence #$_inferenceCount | Shape: [${inputSequence.length}, ${inputSequence[0].length}]');
      final stopwatch = Stopwatch()..start();
      
      final rawResult = await tfliteService.runInference(inputSequence);
      
      stopwatch.stop();
      print('✓ [LSTM] Inférence #$_inferenceCount terminée in ${stopwatch.elapsedMilliseconds}ms');

      // ═══════════════════════════════════════════════════════════════════════════
      // STEP 4: POST-PROCESSING
      // ═══════════════════════════════════════════════════════════════════════════
      final postProcessedResult = inferenceService.applyPostProcessing(rawResult);
      
      // Publier le résultat via le stream pour la UI
      if (postProcessedResult != null && postProcessedResult.primaryConfidence > 0.3) {
        print('🎯 [RESULT] ${postProcessedResult.primaryGesture} | Confiance: ${(postProcessedResult.primaryConfidence * 100).toStringAsFixed(1)}%');
        _resultController.add(postProcessedResult);
      }
      
    } catch (e) {
      print('❌ [ERROR] Erreur pendant l\'inférence LSTM: $e');
    } finally {
      _isBusy = false; // TRÈS IMPORTANT: Libérer le verrou quoi qu'il arrive
    }
  }

  /// DEBUG HELPER: Print buffer state
  void debugPrintBufferState() {
    print('════════════════════════════════════════════════════════════');
    print('📊 [BUFFER_DEBUG] Current state:');
    print('  Frames in buffer: ${_frameBuffer.length}/$_requiredFrames');
    print('  Buffer filled count: $_bufferFilledCount');
    print('  Total inferences: $_inferenceCount');
    
    if (_frameBuffer.isEmpty) {
      print('  Buffer is EMPTY');
    } else {
      for (int i = 0; i < _frameBuffer.length; i++) {
        final nonZero = _frameBuffer[i].where((f) => f != 0.0).length;
        final total = _frameBuffer[i].length;
        print('  Frame $i: $total features, $nonZero non-zero');
      }
    }
    print('════════════════════════════════════════════════════════════');
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
