import 'dart:async';

import 'package:e_commerce_shopping_app/views/login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => Get.offAll(LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.secondaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_cart,
                color: ColorsManager.whiteColor,
                size: SizeManager.sizeXL * 8,
              ),
              Txt(
                text: StringsManager.appName,
                color: ColorsManager.whiteColor.withOpacity(0.8),
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
