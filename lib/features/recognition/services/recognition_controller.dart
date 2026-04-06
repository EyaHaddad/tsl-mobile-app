import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../../camera/camera_service.dart';
import '../managers/sequence_manager.dart';
import '../models/result_model.dart';
import 'mediapipe_service.dart';
import 'tflite_service.dart';

// Coordinates the whole real-time pipeline:
// Camera -> MediaPipe -> Sequence -> TFLite
class RecognitionController {
  final CameraService cameraService;
  final MediaPipeService mediaPipeService;
  final TFLiteService tfliteService;
  final SequenceManager sequenceManager;

  bool _isRunning = false;
  bool _isBusy = false;

  RecognitionController({
    required this.cameraService,
    required this.mediaPipeService,
    required this.tfliteService,
    required this.sequenceManager,
  });

  bool get isRunning => _isRunning;

  // Prepares services and metadata
  Future<void> initialize({
    required String modelPath,
    String metadataAssetPath = TFLiteService.defaultMetadataAssetPath,
  }) async {
    await mediaPipeService.initialize();
    await tfliteService.initialize(
      modelPath,
      metadataAssetPath: metadataAssetPath,
    );
  }

  // Starts listening to camera frames
  Future<void> start() async {
    _isRunning = true;
    // await cameraService.startImageStream((image) async {
    
  }

  Future<void> stop() async {
    _isRunning = false;
    if (cameraService.isStreamingImages) {
      await cameraService.stopImageStream();
    }
    sequenceManager.reset();
  }

  // Processes one frame bytes and returns prediction when a full window is ready
  Future<RecognitionResultData?> processFrameBytes(
    Uint8List encodedFrame,
  ) async {
    if (!_isRunning || _isBusy) {
      return null;
    }

    _isBusy = true;
    try {
      final frameFeatures = await mediaPipeService.detectFrameFeatures(
        encodedFrame,
      );
      final shouldInfer = sequenceManager.addFrameFeatures(frameFeatures);
      if (!shouldInfer) {
        return null;
      }

      final sequenceInput = sequenceManager.buildModelInput2D();
      if (sequenceInput == null) {
        return null;
      }

      return tfliteService.runInference(sequenceInput);
    } finally {
      _isBusy = false;
    }
  }

  Future<void> dispose() async {
    await stop();
    await mediaPipeService.dispose();
    tfliteService.dispose();
  }
}
