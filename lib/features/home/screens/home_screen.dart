import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tsl_mobile_app/features/camera/screens/camera_screen.dart';
import 'package:tsl_mobile_app/features/history/screens/history_screen.dart';
import 'package:tsl_mobile_app/features/settings/screens/settings_screen.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.85,
        child: HistoryScreen(onClose: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Settings Icon
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          FadeSlidePageRoute(page: const SettingsScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Color(0xFF2DC9A0),
                        size: 30,
                      ),
                    ),
                    // Menu Button
                    Builder(
                      builder: (context) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(Icons.menu, color: Colors.white),
                          label: const Text(
                            'السجل',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2DC9A0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Logo Icon
              SvgPicture.asset(
                'assets/icons/mint_hand.svg',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              // Title Text
              const Text(
                'ترجمة لغة\nالإشارة التونسية\nفوريا',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              // Hand Emojis Grid
              const SizedBox(
                width: 160,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Text('🤙', style: TextStyle(fontSize: 48)),
                    Text('🖐', style: TextStyle(fontSize: 48)),
                    Text('👎', style: TextStyle(fontSize: 48)),
                    Text('✊', style: TextStyle(fontSize: 48)),
                  ],
                ),
              ),
              const Spacer(),
              // Start Button
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(SlidePageRoute(page: const CameraScreen()));
                    },
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 12,
                    ),
                    label: const Text(
                      'ابدأ التسجيل',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DC9A0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
