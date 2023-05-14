import 'package:e_commerce_shopping_app/managers/colors_manager.dart';
import 'package:e_commerce_shopping_app/utils/size_config.dart';
import 'package:flutter/material.dart';

class ModeSwitch extends StatefulWidget {
  const ModeSwitch({super.key});

  @override
  State<ModeSwitch> createState() => _ModeSwitchState();
}

class _ModeSwitchState extends State<ModeSwitch> {
  bool isDarkModeOn = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: SizeConfig.screenWidth! * 0.04),
        Icon(
          isDarkModeOn ? Icons.nightlight_round : Icons.wb_sunny_rounded,
          size: 24.0,
          color: ColorsManager.secondaryColor,
        ),
        SizedBox(width: SizeConfig.screenWidth! * 0.08),
        Switch(
          value: isDarkModeOn,
          onChanged: (value) {
            setState(() {
              isDarkModeOn = value;
              // Add your logic for changing the app theme here
            });
          },
          activeColor: ColorsManager.lightSecondaryColor,
          inactiveTrackColor: ColorsManager.primaryColor.withOpacity(0.5),
          inactiveThumbColor: ColorsManager.primaryColor,
        ),
      ],
    );
  }
}
