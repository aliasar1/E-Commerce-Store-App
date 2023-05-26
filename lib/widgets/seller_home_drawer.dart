import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/views_exports.dart';
import 'custom_text.dart';
import 'mode_switch.dart';

class SellerHomeDrawer extends StatefulWidget {
  const SellerHomeDrawer({
    super.key,
    required this.controller,
  });

  final AuthenticateController controller;

  @override
  State<SellerHomeDrawer> createState() => _SellerHomeDrawerState();
}

class _SellerHomeDrawerState extends State<SellerHomeDrawer> {
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(firebaseAuth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorsManager.secondaryColor,
            ),
          );
        } else {
          return Drawer(
            backgroundColor: ColorsManager.scaffoldBgColor,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    backgroundColor: ColorsManager.lightSecondaryColor,
                    backgroundImage: controller.user['profilePhoto'] == ""
                        ? const NetworkImage(
                            'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png')
                        : NetworkImage(
                            controller.user['profilePhoto'],
                          ),
                    radius: 70,
                  ),
                  const SizedBox(height: 10),
                  Txt(
                    text: controller.user['name'],
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.titleFontSize,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  buildDrawerTile("Profile", Icons.person, () {
                    Get.offAll(ProfileScreen(
                      user: User.fromMap(controller.user),
                      controller: widget.controller,
                      isUserBuyer: widget.controller.getUserType() == "Buyer"
                          ? true
                          : false,
                    ));
                  }),
                  buildDrawerTile("My Products", Icons.list_alt, () {
                    Get.offAll(const SellerHomeScreen());
                  }),
                  buildDrawerTile("Orders", Icons.local_shipping, () {
                    Get.offAll(OrdersScreen());
                  }),
                  buildDrawerTile("Logout", Icons.logout, () {
                    buildLogoutDialog();
                  }),
                  SizedBox(height: Get.height * 0.25),
                  const ModeSwitch(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<dynamic> buildLogoutDialog() {
    return Get.dialog(
      AlertDialog(
        backgroundColor: ColorsManager.scaffoldBgColor,
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ColorsManager.secondaryColor),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorsManager.secondaryColor)),
            onPressed: () async {
              widget.controller.logout();
              Get.offAll(const LoginScreen());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: ColorsManager.scaffoldBgColor),
            ),
          ),
        ],
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
