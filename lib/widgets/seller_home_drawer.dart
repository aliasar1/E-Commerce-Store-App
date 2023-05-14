import 'package:e_commerce_shopping_app/views/seller_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/exports/managers_exports.dart';
import 'custom_text.dart';
import 'mode_switch.dart';

class SellerHomeDrawer extends StatelessWidget {
  const SellerHomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsManager.scaffoldBgColor,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              backgroundColor: ColorsManager.lightSecondaryColor,
              backgroundImage: NetworkImage(
                  'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
              radius: 70,
            ),
            const SizedBox(height: 10),
            const Txt(
              text: 'Ali Asar',
              fontWeight: FontWeightManager.bold,
              fontSize: FontSize.titleFontSize,
            ),
            const SizedBox(height: 10),
            const Divider(),
            buildDrawerTile("Profile", Icons.person, () {}),
            buildDrawerTile("My Products", Icons.list_alt, () {
              Get.offAll(SellerHomeScreen());
            }),
            buildDrawerTile("Orders", Icons.local_shipping, () {}),
            buildDrawerTile("Logout", Icons.logout, () {}),
            SizedBox(height: Get.height * 0.25),
            const ModeSwitch(),
          ],
        ),
      ),
    );
  }

  ListTile buildDrawerTile(String text, IconData icon, Function onPressed) {
    return ListTile(
      title: Txt(
        text: text,
        fontSize: FontSize.subTitleFontSize,
      ),
      leading: Icon(
        icon,
        color: ColorsManager.secondaryColor,
      ),
      onTap: () => onPressed(),
    );
  }
}
