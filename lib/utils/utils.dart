import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../managers/colors_manager.dart';
import '../managers/fonts_manager.dart';
import '../managers/values_manager.dart';
import '../widgets/custom_text.dart';
import '../widgets/toast.dart';

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

  static showCustomDialogBox(
    BuildContext context, {
    required String titleText,
    required Icon titleIcon,
    required Widget body,
    required List<Widget> actions,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                titleIcon,
                const SizedBox(height: 20),
                Text(titleText),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              body,
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions,
              )
            ],
          ),
        );
      },
    );
  }

  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
