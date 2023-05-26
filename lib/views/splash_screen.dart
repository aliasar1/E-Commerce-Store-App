import 'dart:async';

import '../controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authController = Get.put(AuthenticateController());

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => authController.checkLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.secondaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
                color: isDarkMode
                    ? DarkColorsManager.primaryColor
                    : ColorsManager.whiteColor,
                size: SizeManager.sizeXL * 8,
              ),
              Txt(
                text: StringsManager.appName,
                color: isDarkMode
                    ? DarkColorsManager.primaryColor.withOpacity(0.8)
                    : ColorsManager.whiteColor.withOpacity(0.8),
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.headerFontSize * 1.5,
                fontWeight: FontWeightManager.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
