import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:tsl_mobile_app/core/constants/app_dimensions.dart';
import 'package:tsl_mobile_app/core/theme/app_colors.dart';
import 'package:tsl_mobile_app/features/recognition/screens/result_screen.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';

// Camera Screen - Web implementation
class CameraScreenWeb extends StatefulWidget {
  const CameraScreenWeb({super.key});

  @override
  State<CameraScreenWeb> createState() => _CameraScreenWebState();
}

class _CameraScreenWebState extends State<CameraScreenWeb>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    if (kIsWeb) {
      _initializeControllerFuture = _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return;
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.low,
        enableAudio: false,
      );

      _controller = controller;
      await controller.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      // Keep UI fallback; errors can happen on denied permissions / no device
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!kIsWeb) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الكاميرا غير مدعومة في هذا الوضع')),
      );
      return;
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر تشغيل الكاميرا')));
      return;
    }

    try {
      await controller.startVideoRecording();
      if (!mounted) return;
      setState(() {
        _isRecording = true;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر بدء التسجيل')));
    }
  }

  Future<void> _endRecording() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      if (!mounted) return;
      Navigator.of(
        context,
      ).push(FadeSlidePageRoute(page: const ResultScreen()));
      return;
    }

    try {
      if (_isRecording) {
        await controller.stopVideoRecording();
      }
    } catch (_) {
      // If stop fails, still navigate (recognition demo can proceed)
    }

    if (!mounted) return;
    setState(() {
      _isRecording = false;
    });

    Navigator.of(context).push(FadeSlidePageRoute(page: const ResultScreen()));
  }

  Widget _buildCircularPreview() {
    final controller = _controller;

    return LayoutBuilder(
      builder: (context, constraints) {
        final ringSize = (constraints.maxWidth * 0.6).clamp(200.0, 260.0);
        final previewSize = ringSize * 0.75;

        Widget previewChild;
        if (!kIsWeb) {
          previewChild = const Icon(
            Icons.camera_alt,
            size: 80,
            color: AppColors.primary,
          );
        } else if (controller == null || !controller.value.isInitialized) {
          previewChild = const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          );
        } else {
          previewChild = FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: previewSize,
              height: previewSize / controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            if (_isRecording)
              ScaleTransition(
                scale: Tween<double>(
                  begin: 0.8,
                  end: 1.2,
                ).animate(_pulseController),
                child: Container(
                  width: ringSize,
                  height: ringSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
              ),
            Container(
              width: previewSize,
              height: previewSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              clipBehavior: Clip.antiAlias,
              child: ClipOval(child: Center(child: previewChild)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.fiber_manual_record,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'تسجيل',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Settings or options
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppDimensions.spacingXLarge),

                // Camera Status Text
                Text(
                  (kIsWeb && (_controller?.value.isInitialized ?? false))
                      ? 'الكاميرا قيد التشغيل'
                      : 'جاري تشغيل الكاميرا...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLarge),

                // Camera preview with pulse animation
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    return _buildCircularPreview();
                  },
                ),
                const SizedBox(height: AppDimensions.spacingXLarge),

                // Instruction text
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge,
                    ),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.warning,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'إشارة مشيرة',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'كيف حالك اليوم؟',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXLarge),

                // Recording duration display
                if (_isRecording)
                  Text(
                    'جاري التسجيل...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: AppDimensions.spacingXLarge),

                // End Recording Button
                if (_isRecording)
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeightLarge,
                    child: ElevatedButton(
                      onPressed: _endRecording,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.stop_circle_outlined),
                          const SizedBox(width: 8),
                          Text(
                            'إنهاء التسجيل',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeightLarge,
                    child: ElevatedButton(
                      onPressed: _startRecording,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fiber_manual_record),
                          const SizedBox(width: 8),
                          Text(
                            'ابدأ التسجيل',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
