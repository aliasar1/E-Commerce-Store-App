import 'package:e_commerce_shopping_app/managers/colors_manager.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: Center(
          child: Txt(
        text: "Seller HOME PAGE",
      )),
    );
  }
}
