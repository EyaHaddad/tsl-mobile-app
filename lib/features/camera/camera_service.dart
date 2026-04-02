// Camera Service - Mobile only
// Noop implementation for web testing

class CameraService {
  bool _isInitialized = false;

  CameraService({dynamic preferredLensDirection}) {
    // No-op
  }

  /// Request camera permissions
  Future<bool> requestCameraPermission() async {
    return true;
  }

  /// Check camera permission status
  Future<bool> hasCameraPermission() async {
    return true;
  }

  /// Initialize camera
  Future<void> initialize({dynamic resolution}) async {
    _isInitialized = true;
  }

  /// Switch to front/back camera
  Future<void> switchCamera() async {
    // No-op
  }

  /// Take a picture
  Future<String?> takePicture() async {
    return null;
  }

  /// Get camera controller
  dynamic get controller => null;

  /// Check if camera is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  Future<void> dispose() async {
    _isInitialized = false;
  }
}
