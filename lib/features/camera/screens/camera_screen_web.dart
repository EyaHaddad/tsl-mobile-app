import 'package:flutter/material.dart';
import 'package:tsl_mobile_app/core/constants/app_strings.dart';
import 'package:tsl_mobile_app/core/constants/app_dimensions.dart';
import 'package:tsl_mobile_app/core/theme/app_colors.dart';
import 'package:tsl_mobile_app/features/recognition/screens/result_screen.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';

class CameraScreenWeb extends StatefulWidget {
  const CameraScreenWeb({super.key});

  @override
  State<CameraScreenWeb> createState() => _CameraScreenWebState();
}

class _CameraScreenWebState extends State<CameraScreenWeb>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isRecording = false;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = 0;
    });
  }

  void _endRecording() {
    setState(() {
      _isRecording = false;
    });
    // Navigate to result screen
    Navigator.of(context).push(
      FadeSlidePageRoute(
        child: const ResultScreen(),
      ),
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
            child: const Icon(Icons.fiber_manual_record,
                color: AppColors.white, size: 20),
          ),
        ),
        title: Text(
          'تسجيل',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.white,
              ),
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
                  'الكاميرا قيد التشغيل',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: AppDimensions.spacingLarge),

                // Camera Icon with pulse animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse ring
                    if (_isRecording)
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1.2)
                            .animate(_pulseController),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    // Camera icon
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingXLarge),

                // Instruction text
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLarge),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
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
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
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
