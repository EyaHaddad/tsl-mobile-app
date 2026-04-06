import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final CameraLensDirection _preferredLensDirection;

  List<CameraDescription> _cameras = const [];
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;

  CameraService({CameraLensDirection? preferredLensDirection})
    : _preferredLensDirection =
          preferredLensDirection ?? CameraLensDirection.back;

  // Request camera permission on mobile. Web handles this in-browser
  Future<bool> requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Returns whether camera permission is currently granted
  Future<bool> hasCameraPermission() async {
    if (kIsWeb) return true;
    return Permission.camera.status.isGranted;
  }

  // Initializes camera list and starts a controller for the preferred lens
  Future<void> initialize({
    ResolutionPreset resolution = ResolutionPreset.medium,
  }) async {
    final hasPermission = await hasCameraPermission();
    if (!hasPermission) {
      final granted = await requestCameraPermission();
      if (!granted) {
        throw CameraException(
          'permission_denied',
          'Camera permission was denied by the user.',
        );
      }
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('no_camera', 'No camera device was found.');
    }

    _cameras = cameras;
    final preferredIndex = cameras.indexWhere(
      (camera) => camera.lensDirection == _preferredLensDirection,
    );
    _selectedCameraIndex = preferredIndex >= 0 ? preferredIndex : 0;

    await _startControllerForIndex(
      _selectedCameraIndex,
      resolution: resolution,
    );
  }

  Future<void> _startControllerForIndex(
    int index, {
    ResolutionPreset resolution = ResolutionPreset.medium,
  }) async {
    if (index < 0 || index >= _cameras.length) {
      throw CameraException(
        'invalid_camera_index',
        'Selected camera index is invalid.',
      );
    }

    final oldController = _controller;
    _controller = null;
    _isInitialized = false;
    await oldController?.dispose();

    final controller = CameraController(
      _cameras[index],
      resolution,
      enableAudio: false,
    );

    _controller = controller;
    await controller.initialize();
    _selectedCameraIndex = index;
    _isInitialized = true;
  }

  // Switches between available cameras
  Future<void> switchCamera({
    ResolutionPreset resolution = ResolutionPreset.medium,
  }) async {
    if (_cameras.length < 2) return;

    final nextIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _startControllerForIndex(nextIndex, resolution: resolution);
  }

  // Starts video recording if controller is ready
  Future<void> startVideoRecording() async {
    final cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      throw CameraException('not_initialized', 'Camera is not initialized.');
    }
    if (cameraController.value.isRecordingVideo) {
      return;
    }

    await cameraController.startVideoRecording();
  }

  // Stops video recording and returns the recorded file path
  Future<String?> stopVideoRecording() async {
    final cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    final file = await cameraController.stopVideoRecording();
    return file.path;
  }

  // Starts image stream; can be consumed by a future on-device ML pipeline
  Future<void> startImageStream(
    void Function(CameraImage image) onImageAvailable,
  ) async {
    final cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      throw CameraException('not_initialized', 'Camera is not initialized.');
    }
    if (cameraController.value.isStreamingImages) {
      return;
    }

    await cameraController.startImageStream(onImageAvailable);
  }

  Future<void> stopImageStream() async {
    final cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (!cameraController.value.isStreamingImages) {
      return;
    }

    await cameraController.stopImageStream();
  }

  // Take a picture and return local file path
  Future<String?> takePicture() async {
    final cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    final file = await cameraController.takePicture();
    return file.path;
  }

  CameraController? get controller => _controller;

  bool get isInitialized =>
      _isInitialized && (_controller?.value.isInitialized ?? false);

  bool get isRecording => _controller?.value.isRecordingVideo ?? false;

  bool get isStreamingImages => _controller?.value.isStreamingImages ?? false;

  Future<void> dispose() async {
    _isInitialized = false;
    final cameraController = _controller;
    _controller = null;
    await cameraController?.dispose();
  }
}
