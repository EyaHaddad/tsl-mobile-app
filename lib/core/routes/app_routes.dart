import 'package:flutter/material.dart';
import 'package:tsl_mobile_app/features/home/screens/home_screen.dart';
import 'package:tsl_mobile_app/features/history/screens/history_screen.dart';
import 'package:tsl_mobile_app/features/settings/screens/settings_screen.dart';
import 'package:tsl_mobile_app/features/recognition/screens/result_screen.dart';
import 'package:tsl_mobile_app/features/camera/screens/camera_screen.dart';
import 'package:tsl_mobile_app/core/routes/transition_routes.dart';

class AppRoutes {
  static const String home = '/';
  static const String camera = '/camera';
  static const String result = '/result';
  static const String history = '/history';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/camera': (context) => const CameraScreen(),
    '/history': (context) => const HistoryScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/result': (context) => const ResultScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/camera':
        return SlidePageRoute(page: const CameraScreen());
      case '/history':
        return FadeSlidePageRoute(page: const HistoryScreen());
      case '/settings':
        return FadeSlidePageRoute(page: const SettingsScreen());
      case '/result':
        return FadeSlidePageRoute(page: const ResultScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
