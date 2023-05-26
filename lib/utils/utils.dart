import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../widgets/custom_text.dart';
import '../widgets/toast.dart';
import 'exports/managers_exports.dart';

class Utils {
  Utils._();
  static showLoading(BuildContext context) {
    Get.defaultDialog(
      title: '',
      backgroundColor: ColorsManager.scaffoldBgColor,
      content: customLoading(context),
      radius: RadiusManager.buttonRadius,
      barrierDismissible: false,
    );
  }

  static Widget customLoading(BuildContext context) {
    return Container(
      color: ColorsManager.scaffoldBgColor,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Txt(
              textAlign: TextAlign.center,
              text: 'Your order is proceeding...',
              fontWeight: FontWeightManager.bold,
              fontSize: FontSize.titleFontSize * 0.8,
              color: ColorsManager.primaryColor,
              fontFamily: FontsManager.fontFamilyPoppins,
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: Lottie.asset(
                'assets/lottie/logo.json',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static dismissLoadingWidget() {
    Get.back();
  }

  static void showSnackBar(
    String message, {
    isSuccess = true,
    String? title,
    Icon? icon,
  }) =>
      Get.showSnackbar(
        GetSnackBar(
          icon: icon ??
              Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color:
                    isSuccess ? ColorsManager.primaryColor : Colors.redAccent,
                size: SizeManager.sizeM,
              ),
          titleText: Text(
            title ?? isSuccess ? "Success" : "Failed",
            style: TextStyle(
              fontSize: FontSize.subTitleFontSize,
              color: isSuccess ? ColorsManager.primaryColor : Colors.redAccent,
              fontWeight: FontWeight.w700,
              fontFamily: "Nunito",
              letterSpacing: 1.0,
            ),
          ),
          messageText: Text(
            message,
            style: TextStyle(
              fontSize: FontSize.textFontSize,
              color: isSuccess ? ColorsManager.primaryColor : Colors.redAccent,
              fontWeight: FontWeight.w700,
              fontFamily: "Nunito",
              letterSpacing: 1.0,
            ),
          ),
          duration: const Duration(seconds: 4),
        ),
      );

  static void showToast(BuildContext context, String message) =>
      Toast.show(message, context, duration: 5, gravity: 2);
}
