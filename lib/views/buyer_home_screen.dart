import 'package:e_commerce_shopping_app/managers/colors_manager.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class BuyerHomeScreen extends StatelessWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: Center(
          child: Txt(
        text: "Buyer HOME PAGE",
      )),
    );
  }
}
