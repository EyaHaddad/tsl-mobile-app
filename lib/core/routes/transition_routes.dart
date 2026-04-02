import 'package:flutter/material.dart';

/// Custom Page Route with slide transition animation
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

/// Custom Page Route with fade transition animation
class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}

/// Custom Page Route with scale transition animation
class ScalePageRoute extends PageRouteBuilder {
  final Widget page;

  ScalePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOutCubic;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );
          },
        );
}

/// Custom Page Route with combined fade and slide transition
class FadeSlidePageRoute extends PageRouteBuilder {
  final Widget page;

  FadeSlidePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.3, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var slideTween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

            return FadeTransition(
              opacity: animation.drive(fadeTween),
              child: SlideTransition(
                position: animation.drive(slideTween),
                child: child,
              ),
            );
          },
        );
}

/// Navigation helper class
class NavigationHelper {
  /// Navigate with slide transition (recommended for main flow)
  static Future<dynamic> navigateWithSlide(
    BuildContext context,
    Widget widget,
  ) {
    return Navigator.of(context).push(SlidePageRoute(page: widget));
  }

  /// Navigate with fade transition
  static Future<dynamic> navigateWithFade(
    BuildContext context,
    Widget widget,
  ) {
    return Navigator.of(context).push(FadePageRoute(page: widget));
  }

  /// Navigate with scale transition
  static Future<dynamic> navigateWithScale(
    BuildContext context,
    Widget widget,
  ) {
    return Navigator.of(context).push(ScalePageRoute(page: widget));
  }

  /// Navigate with fade and slide combination
  static Future<dynamic> navigateWithFadeSlide(
    BuildContext context,
    Widget widget,
  ) {
    return Navigator.of(context).push(FadeSlidePageRoute(page: widget));
  }

  /// Navigate named route with transition
  static Future<dynamic> navigateNamedWithSlide(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.of(context).pushNamed(routeName);
  }
}
