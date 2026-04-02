import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsl_mobile_app/features/recognition/screens/result_screen.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';
import 'package:tsl_mobile_app/features/camera/screens/camera_screen_web.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> _cameras = const [];
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _selectedCameraIndex = 0;

  bool _isRecording = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _initializeControllerFuture = _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _cameras = cameras;

      final backIndex = cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      _selectedCameraIndex = backIndex >= 0 ? backIndex : 0;

      await _startControllerForIndex(_selectedCameraIndex);
    } catch (_) {
      // Permission denied / camera unavailable.
    }
  }

  Future<void> _startControllerForIndex(int index) async {
    final description = _cameras[index];

    final old = _controller;
    _controller = null;
    await old?.dispose();

    final controller = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _controller = controller;
    await controller.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;
    if (_isRecording) return;

    final nextIndex = (_selectedCameraIndex + 1) % _cameras.length;
    setState(() {
      _selectedCameraIndex = nextIndex;
    });

    try {
      await _startControllerForIndex(nextIndex);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _startRecording() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      await controller.startVideoRecording();
      if (!mounted) return;
      setState(() => _isRecording = true);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _endRecording() async {
    final controller = _controller;

    try {
      if (controller != null &&
          controller.value.isInitialized &&
          _isRecording) {
        await controller.stopVideoRecording();
      }
    } catch (_) {
      // ignore
    }

    if (!mounted) return;
    setState(() => _isRecording = false);

    Navigator.of(context).push(FadeSlidePageRoute(page: const ResultScreen()));
  }

  Widget _buildPreview() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Icon(Icons.camera_alt_outlined, size: 70, color: Colors.black45),
      );
    }

    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return CameraPreview(controller);
    }

    // Cover the available space while maintaining aspect ratio.
    // Using swapped width/height matches typical camera preview orientation.
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: previewSize.height,
        height: previewSize.width,
        child: CameraPreview(controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const CameraScreenWeb();
    }

    final isCameraReady = _controller?.value.isInitialized ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // تسجيل button with red dot
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_isRecording) {
                        _endRecording();
                      } else {
                        _startRecording();
                      }
                    },
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 10,
                    ),
                    label: const Text(
                      'تسجيل',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE63950),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                  // Camera flip icon
                  IconButton(
                    onPressed: _toggleCamera,
                    icon: SvgPicture.asset(
                      'assets/icons/camera_flip.svg',
                      width: 32,
                      height: 32,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFE63950),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Camera preview area
              if (isCameraReady)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE63950),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: FutureBuilder<void>(
                            future: _initializeControllerFuture,
                            builder: (context, snapshot) {
                              return _buildPreview();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'الكاميرا قيد التشغيل',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 160,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE63950),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                return _buildPreview();
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'الكاميرا قيد التشغيل',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Detected sign box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF2DC9A0),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Label row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ': إشارة مكتشفة',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(width: 6),
                        Text('💡', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Detected text
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'مرحباً، كيف حالك اليوم؟',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // End recording button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    _endRecording();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE63950),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'إنهاء التسجيل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
