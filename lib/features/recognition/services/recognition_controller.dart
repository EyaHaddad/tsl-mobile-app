import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../camera/camera_service.dart';
import '../managers/sequence_manager.dart';
import '../models/result_model.dart';
import 'inference_service.dart';
import 'mediapipe_service.dart';
import 'tflite_service.dart';

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
    try {
      await cameraService.startImageStream((CameraImage image) async {
        // Non-blocking frame processing
        if (!_isBusy) {
          unawaited(_processFrame(image));
        }
      });
    } catch (e) {
      _isRunning = false;
      rethrow;
    }
  }

  // Process a single camera frame through the entire pipeline
  Future<void> _processFrame(CameraImage image) async {
    if (!_isRunning || _isBusy) return;

    _isBusy = true;
    try {
      // Convert CameraImage to byte array
      final frameBytes = _cameraImageToBytes(image);
      if (frameBytes.isEmpty) return;

      // Call existing frame processor
      final result = await processFrameBytes(frameBytes);

      // Emit result to stream for UI listening
      if (result != null) {
        _resultController.add(result);
        if (kDebugMode) {
          print(
            'Recognition: ${result.primaryGesture} '
            '(${(result.primaryConfidence * 100).toStringAsFixed(1)}%)',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Frame processing error: $e');
    } finally {
      _isBusy = false;
    }
  }

  // Stops listening to camera frames
  Future<void> stop() async {
    _isRunning = false;
    if (cameraService.isStreamingImages) {
      await cameraService.stopImageStream();
    }
    sequenceManager.reset();
    inferenceService.resetMetrics();
  }

  // Processes one frame bytes and returns prediction when a full window is ready
  // This is the core inference pipeline
  Future<RecognitionResultData?> processFrameBytes(
    Uint8List encodedFrame,
  ) async {
    if (!_isRunning || _isBusy) {
      return null;
    }

    try {
      // Step 1: Extract hand landmarks from frame (MediaPipe)
      final frameFeatures = await mediaPipeService.detectFrameFeatures(
        encodedFrame,
      );

      // Step 2: Add features to sequence buffer
      // Returns true when window is ready and stride condition is met
      final shouldInfer = sequenceManager.addFrameFeatures(frameFeatures);
      if (!shouldInfer) {
        return null; // Window not ready yet
      }

      // Step 3: Build normalized sequence (10 x 126)
      final sequenceInput = sequenceManager.buildModelInput2D();
      if (sequenceInput == null) {
        return null;
      }

      // Step 4: Run LSTM inference (TFLite)
      final rawResult = await tfliteService.runInference(sequenceInput);

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
  // HELPER: Convert CameraImage to Uint8List
  // ============================================================================

  /// Convert CameraImage to bytes for further processing
  /// Handles JPEG format directly, or passes raw plane data for YUV formats
  static Uint8List _cameraImageToBytes(CameraImage image) {
    try {
      // For JPEG format, directly use the bytes
      if (image.format.group == ImageFormatGroup.jpeg) {
        return image.planes[0].bytes;
      }

      // For NV21/YUV420 formats (most Android devices)
      // Return the raw Y-plane data (luminance channel) for hand detection
      // MediaPipe can work with grayscale Y-plane for landmark detection
      if (image.format.group == ImageFormatGroup.yuv420) {
        // Y-plane contains luminance; sufficient for hand landmark detection
        return image.planes[0].bytes;
      }

      // Fallback: return raw bytes from first plane
      if (image.planes.isNotEmpty) {
        return image.planes[0].bytes;
      }

      return Uint8List(0);
    } catch (e) {
      if (kDebugMode) print('Error converting CameraImage to bytes: $e');
      return Uint8List(0);
    }
  }
}
