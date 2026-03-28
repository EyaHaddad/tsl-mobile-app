import 'package:flutter/material.dart';
import 'package:tsl_mobile_app/features/recognition/screens/result_screen.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "recording" label
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 4),
                child: Text(
                  'recording',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // تسجيل button with red dot
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _isRecording = !_isRecording);
                    },
                    icon: const Icon(Icons.circle, color: Colors.white, size: 10),
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
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                  // Camera flip icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_front_outlined,
                      color: Color(0xFFE63950),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Camera preview area
              Center(
                child: Column(
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
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 70,
                          color: Colors.black45,
                        ),
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
              const Spacer(),
              // Detected sign box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2DC9A0), width: 1.5),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
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
                    Navigator.of(context).push(
                      FadeSlidePageRoute(page: const ResultScreen()),
                    );
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
