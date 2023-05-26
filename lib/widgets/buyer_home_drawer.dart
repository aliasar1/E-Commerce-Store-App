import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../managers/firebase_manager.dart';
import '../models/user_model.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/views_exports.dart';
import '../utils/exports/widgets_exports.dart';

class BuyerHomeDrawer extends StatefulWidget {
  const BuyerHomeDrawer({super.key, required this.controller});

  final AuthenticateController controller;

  @override
  State<BuyerHomeDrawer> createState() => _BuyerHomeDrawerState();
}

class _BuyerHomeDrawerState extends State<BuyerHomeDrawer> {
  final profileController = Get.put(ProfileController());
  final prodController = Get.put(ProductController());
  final cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(firebaseAuth.currentUser!.uid);
    cartController.initializeCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            backgroundColor: isDarkMode
                ? DarkColorsManager.scaffoldBgColor
                : ColorsManager.scaffoldBgColor,
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
                  buildDrawerTile(
                    "Buy Products",
                    Icons.list_alt,
                    () {
                      Get.offAll(const BuyerHomeScreen());
                    },
                  ),
                  buildDrawerTile(
                    "Cart",
                    Icons.shopping_cart_checkout,
                    () {
                      Get.offAll(CartScreen(
                        authController: widget.controller,
                      ));
                    },
                  ),
                  buildDrawerTile(
                    "Favourites",
                    Icons.favorite,
                    () {
                      Get.offAll(FavouriteScreen());
                    },
                  ),
                  buildDrawerTile(
                    "Orders History",
                    Icons.history,
                    () {
                      Get.offAll(OrdersHistoryScreen());
                    },
                  ),
                  buildDrawerTile("Logout", Icons.logout, () {
                    buildLogoutDialog(context);
                  }),
                  SizedBox(height: Get.height * 0.135),
                  const ModeSwitch(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<dynamic> buildLogoutDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Get.dialog(
      AlertDialog(
        backgroundColor: isDarkMode
            ? DarkColorsManager.backgroundColor
            : ColorsManager.scaffoldBgColor,
        title: const Text(
          'Confirm Logout',
          style: TextStyle(
            color: ColorsManager.whiteColor,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: ColorsManager.whiteColor,
          ),
        ),
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
                  MaterialStateProperty.all(ColorsManager.secondaryColor),
            ),
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
