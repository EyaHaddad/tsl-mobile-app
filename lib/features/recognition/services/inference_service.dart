import '../models/result_model.dart';

// Configuration used for post-processing prediction in real-time
class InferenceConfig {
  final double confidenceThreshold;
  final int smoothWindowSize;
  final int maxFps;

  const InferenceConfig({
    this.confidenceThreshold = 0.5,
    this.smoothWindowSize = 5,
    this.maxFps = 15,
  });
}

// Runtime metrics that we can show in debug mode
class InferenceMetrics {
  final double fps;
  final double avgLatencyMs;
  final int droppedFrames;

  const InferenceMetrics({
    required this.fps,
    required this.avgLatencyMs,
    required this.droppedFrames,
  });
}

// Helper service for post-processing: smoothing, thresholding, FPS limiting
class InferenceService {
  final InferenceConfig config;

  // Metrics tracking
  final List<int> _processingTimes = [];
  final List<DateTime> _inferenceTimestamps = [];
  int _droppedFrames = 0;

  // Temporal smoothing - keep a window of recent predictions
  final List<RecognitionResultData> _smoothingWindow = [];

  InferenceService({this.config = const InferenceConfig()});

  /// Apply post-processing to raw inference result
  /// - Filter by confidence threshold
  /// - Apply temporal smoothing
  /// - Respect FPS limits
  RecognitionResultData? applyPostProcessing(RecognitionResultData raw) {
    // Check FPS limit
    if (!_shouldProcessFrame()) {
      _droppedFrames++;
      return null;
    }

    // Record inference time
    _recordInferenceTime(DateTime.now(), raw.processingTime);

    // Filter by confidence threshold
    if (raw.primaryConfidence < config.confidenceThreshold) {
      return null; // Below threshold, drop
    }

    // Apply temporal smoothing
    return _applySmoothing(raw);
  }

  /// Check if we should process this frame based on FPS limit
  /// Returns true if enough time has passed since last inference
  bool _shouldProcessFrame() {
    if (config.maxFps <= 0) return true;

    final now = DateTime.now();
    if (_inferenceTimestamps.isEmpty) {
      return true;
    }

    final lastInference = _inferenceTimestamps.last;
    final timeSinceLastMs = now.difference(lastInference).inMilliseconds;
    final minIntervalMs = (1000 / config.maxFps).toInt();

    return timeSinceLastMs >= minIntervalMs;
  }

  /// Record inference time for metrics calculation
  void _recordInferenceTime(DateTime timestamp, int processingTimeMs) {
    _inferenceTimestamps.add(timestamp);
    _processingTimes.add(processingTimeMs);

    // Keep only last 60 samples for metrics
    if (_inferenceTimestamps.length > 60) {
      _inferenceTimestamps.removeAt(0);
      _processingTimes.removeAt(0);
    }
  }

  /// Apply temporal smoothing using a moving average window
  /// Returns the smoothed prediction
  RecognitionResultData _applySmoothing(RecognitionResultData raw) {
    _smoothingWindow.add(raw);

    // Keep window at configured size
    if (_smoothingWindow.length > config.smoothWindowSize) {
      _smoothingWindow.removeAt(0);
    }

    // Only apply smoothing when window is full, or return raw
    if (_smoothingWindow.length < config.smoothWindowSize) {
      return raw; // Not enough history yet, return raw result
    }

    // Get most frequent gesture in window (voting)
    final gestureCounts = <String, int>{};
    for (final result in _smoothingWindow) {
      gestureCounts[result.primaryGesture] =
          (gestureCounts[result.primaryGesture] ?? 0) + 1;
    }

    // Find gesture with highest count
    final smoothedGesture = gestureCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Calculate average confidence for smoothed gesture
    final matchingResults = _smoothingWindow
        .where((r) => r.primaryGesture == smoothedGesture)
        .toList();

    final avgConfidence = matchingResults.isEmpty
        ? raw.primaryConfidence
        : matchingResults
                  .map((r) => r.primaryConfidence)
                  .reduce((a, b) => a + b) /
              matchingResults.length;

    return raw.copyWith(
      primaryGesture: smoothedGesture,
      primaryConfidence: avgConfidence,
      debug:
          '${raw.debug} [Smoothed with confidence=${avgConfidence.toStringAsFixed(3)} over ${_smoothingWindow.length} frames]',
    );
  }

  /// Get current runtime metrics
  InferenceMetrics currentMetrics() {
    if (_inferenceTimestamps.isEmpty) {
      return const InferenceMetrics(
        fps: 0.0,
        avgLatencyMs: 0.0,
        droppedFrames: 0,
      );
    }

    // Calculate FPS from timestamps
    final firstTime = _inferenceTimestamps.first;
    final lastTime = _inferenceTimestamps.last;
    final elapsedSeconds =
        lastTime.difference(firstTime).inMilliseconds / 1000.0;
    final fps = elapsedSeconds > 0
        ? (_inferenceTimestamps.length - 1) / elapsedSeconds
        : 0.0;

    // Calculate average latency
    final avgLatency = _processingTimes.isEmpty
        ? 0.0
        : _processingTimes.reduce((a, b) => a + b) / _processingTimes.length;

    return InferenceMetrics(
      fps: fps.isNaN ? 0.0 : fps,
      avgLatencyMs: avgLatency.toDouble(),
      droppedFrames: _droppedFrames,
    );
  }

  /// Reset metrics (useful between recording sessions)
  void resetMetrics() {
    _processingTimes.clear();
    _inferenceTimestamps.clear();
    _droppedFrames = 0;
    _smoothingWindow.clear();
  }
}
