import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:coffee_shop_app/core/theme/app_theme.dart';
import 'package:coffee_shop_app/controllers/coffee_controller.dart';
import 'package:coffee_shop_app/controllers/cart_controller.dart';
import 'package:coffee_shop_app/screens/splash/splash_screen.dart';
import 'package:coffee_shop_app/screens/home/home_screen.dart';

/// Root app widget with GetMaterialApp, ScreenUtil, and route configuration
class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Coffee Shop',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          
          // Register GetX controllers globally
          initialBinding: BindingsBuilder(() {
            Get.put(CoffeeController());
            Get.put(CartController());
          }),

          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => const SplashScreen(),
            ),
            GetPage(
              name: '/home',
              page: () => const HomeScreen(),
            ),
          ],
        );
      },
    );
  }
}
