import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'routing/app_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/firebase_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _bootstrap();
}

class EngApp extends StatelessWidget {
  const EngApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter();
    return MaterialApp.router(
      title: 'EngApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

Future<void> _bootstrap() async {
  await Hive.initFlutter();
  await Hive.openBox('daily_cache');
  await Hive.openBox('lessons_cache');
  // Initialize Google Mobile Ads SDK (safe to call even without ad unit ids yet)
  await MobileAds.instance.initialize();
  // Try initializing Firebase (no-op if not configured)
  await FirebaseService.instance.init();
  runApp(const EngApp());
}
