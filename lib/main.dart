import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tsl_mobile_app/core/theme/app_theme.dart';
import 'package:tsl_mobile_app/core/constants/app_strings.dart';
import 'package:tsl_mobile_app/core/routes/app_routes.dart';
import 'package:tsl_mobile_app/core/database/isar_service.dart';
import 'package:tsl_mobile_app/core/services/history_retention_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.instance.init();
  final retentionService = await HistoryRetentionService.create();
  await retentionService.purgeExpiredIfEnabled();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme(context),
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
