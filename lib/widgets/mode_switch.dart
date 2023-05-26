import 'package:e_commerce_shopping_app/managers/colors_manager.dart';
import 'package:e_commerce_shopping_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';

class ModeSwitch extends StatefulWidget {
  const ModeSwitch({super.key});

  @override
  State<ModeSwitch> createState() => _ModeSwitchState();
}

class _ModeSwitchState extends State<ModeSwitch> {
  final controller = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: SizeConfig.screenWidth! * 0.04),
        Icon(
          controller.isDarkMode
              ? Icons.nightlight_round
              : Icons.wb_sunny_rounded,
          size: 24.0,
          color: ColorsManager.secondaryColor,
        ),
        SizedBox(width: SizeConfig.screenWidth! * 0.08),
        Switch(
          value: controller.isDarkMode,
          onChanged: (_) {
            setState(() {
              controller.toggleTheme();
            });
          },
          activeColor: controller.isDarkMode
              ? DarkColorsManager.lightSecondaryColor
              : ColorsManager.lightSecondaryColor,
          inactiveTrackColor: controller.isDarkMode
              ? DarkColorsManager.primaryColor.withOpacity(0.5)
              : ColorsManager.primaryColor.withOpacity(0.5),
          inactiveThumbColor: controller.isDarkMode
              ? DarkColorsManager.primaryColor
              : ColorsManager.primaryColor,
        ),
      ],
    );
  }
}
