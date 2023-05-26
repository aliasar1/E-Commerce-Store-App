import 'dart:async';

import 'package:e_commerce_shopping_app/controllers/auth_controller.dart';
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
