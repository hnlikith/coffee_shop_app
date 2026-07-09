import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coffee_shop_app/data/services/supabase_service.dart';
import 'package:coffee_shop_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0C0F14),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Supabase in the background (do NOT await it, so it doesn't block runApp if emulator network hangs)
  SupabaseService.initialize().catchError((e) {
    debugPrint('Supabase not configured, using fallback data: $e');
  });

  runApp(const CoffeeShopApp());
}
