import '../models/gesture_model.dart';

/// Main recognition service that orchestrates MediaPipe hand detection and LSTM inference
class RecognitionService {
  final List<List<HandLandmark>> _landmarkSequence = [];
  final int _sequenceLength;
  bool _isRecording = false;

  RecognitionService({int sequenceLength = 30})
      : _sequenceLength = sequenceLength;

  /// Start recording hand landmarks
  void startRecording() {
    _landmarkSequence.clear();
    _isRecording = true;
  }

  /// Stop recording
  void stopRecording() {
    _isRecording = false;
  }

  /// Add hand landmarks to the sequence
  void addHandLandmarks(List<HandLandmark> landmarks) {
    if (!_isRecording) return;

    _landmarkSequence.add(landmarks);

    // Keep only the latest landmarks
    if (_landmarkSequence.length > _sequenceLength) {
      _landmarkSequence.removeAt(0);
    }
  }

  /// Check if sequence is ready for inference
  bool get isSequenceReady =>
      _landmarkSequence.length >= _sequenceLength &&
      _landmarkSequence.length > 0;

  /// Get current sequence length
  int get currentSequenceLength => _landmarkSequence.length;

  /// Get accumulated landmarks
  List<List<HandLandmark>> get landmarks => List.unmodifiable(_landmarkSequence);

  /// Reset sequence
  void resetSequence() {
    _landmarkSequence.clear();
  }

  /// Process and prepare landmarks for inference
  List<List<double>> prepareLandmarksForInference() {
    if (_landmarkSequence.isEmpty) return [];

    // Flatten landmarks into a 2D array
    // Each frame has 21 landmarks, each with 4 values (x, y, z, visibility)
    return _landmarkSequence
        .map((frameLandmarks) => _flattenLandmarks(frameLandmarks))
        .toList();
  }

  /// Helper to flatten landmarks
  List<double> _flattenLandmarks(List<HandLandmark> landmarks) {
    final flattened = <double>[];
    for (final landmark in landmarks) {
      flattened.addAll([landmark.x, landmark.y, landmark.z, landmark.visibility]);
    }
    return flattened;
  }

  /// Normalize landmarks (0-1 range)
  List<List<double>> normalizeLandmarks(List<List<double>> landmarks) {
    if (landmarks.isEmpty) return [];

    final normalized = <List<double>>[];

    for (final frameLandmarks in landmarks) {
      final frame = List<double>.from(frameLandmarks);

      // Process in groups of 4 (x, y, z, visibility)
      for (int i = 0; i < frame.length; i += 4) {
        if (i + 2 < frame.length) {
          // Normalize x and y to 0-1 (assuming they're already in that range from MediaPipe)
          frame[i] = frame[i].clamp(0.0, 1.0);
          frame[i + 1] = frame[i + 1].clamp(0.0, 1.0);
          // Z is kept as is (depth)
          // Visibility is already in 0-1 range
        }
      }

      normalized.add(frame);
    }

    return normalized;
  }

  /// Augment landmarks with additional features (angles, distances, etc.)
  List<double> extractFeatures(List<HandLandmark> landmarks) {
    if (landmarks.length < 21) return [];

    final features = <double>[];

    // Add all landmark coordinates
    for (final landmark in landmarks) {
      features.addAll([landmark.x, landmark.y, landmark.z, landmark.visibility]);
    }

    // Add hand-crafted features (finger angles, distances, etc.)
    // Wrist (0), Thumb (1-4), Index (5-8), Middle (9-12), Ring (13-16), Pinky (17-20)

    // Distance between fingers
    final thumbTip = landmarks[4];
    final indexTip = landmarks[8];
    final middleTip = landmarks[12];
    final ringTip = landmarks[16];
    final pinkyTip = landmarks[20];

    features.add(_euclideanDistance(thumbTip, indexTip));
    features.add(_euclideanDistance(indexTip, middleTip));
    features.add(_euclideanDistance(middleTip, ringTip));
    features.add(_euclideanDistance(ringTip, pinkyTip));

    // Finger spread
    final wrist = landmarks[0];
    features.add(_euclideanDistance(wrist, thumbTip));
    features.add(_euclideanDistance(wrist, indexTip));
    features.add(_euclideanDistance(wrist, middleTip));
    features.add(_euclideanDistance(wrist, ringTip));
    features.add(_euclideanDistance(wrist, pinkyTip));

    return features;
  }

  /// Calculate Euclidean distance between two landmarks
  double _euclideanDistance(HandLandmark p1, HandLandmark p2) {
    final dx = p1.x - p2.x;
    final dy = p1.y - p2.y;
    final dz = p1.z - p2.z;
    return (dx * dx + dy * dy + dz * dz).isNaN || (dx * dx + dy * dy + dz * dz) < 0
        ? 0
        : (dx * dx + dy * dy + dz * dz);
  }

  bool get isRecording => _isRecording;
}
