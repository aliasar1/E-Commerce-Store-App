import 'package:e_commerce_shopping_app/controllers/auth_controller.dart';
import 'package:e_commerce_shopping_app/controllers/profile_controller.dart';
import 'package:e_commerce_shopping_app/widgets/seller_home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../managers/colors_manager.dart';
import '../models/user_model.dart';
import '../utils/exports/managers_exports.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/cutom_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.user, required this.controller});

  final User user;
  final AuthenticateController controller;

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.scaffoldBgColor,
        drawer: SellerHomeDrawer(controller: controller),
        appBar: AppBar(
          backgroundColor: ColorsManager.scaffoldBgColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorsManager.secondaryColor),
        ),
        body: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
            alignment: Alignment.center,
            child: Column(
              children: [
                Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 64,
                        backgroundImage: profileController.profilePhoto != null
                            ? Image.file(profileController.profilePhoto!).image
                            : user.profilePhoto != ""
                                ? Image.network(user.profilePhoto).image
                                : const NetworkImage(
                                    'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                        backgroundColor: ColorsManager.backgroundColor,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () => profileController.pickImage(),
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: ColorsManager.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Txt(
                        textAlign: TextAlign.center,
                        text: user.name,
                        color: ColorsManager.primaryColor,
                        fontSize: FontSize.textFontSize,
                        fontFamily: FontsManager.fontFamilyPoppins,
                        fontWeight: FontWeightManager.bold,
                      ),
                    ),
                  ],
                ),
                Txt(
                  text: user.email,
                  color: ColorsManager.primaryColor,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
                Txt(
                  text: user.phone,
                  color: ColorsManager.primaryColor,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                ),
                const SizedBox(
                  height: SizeManager.sizeXL * 3,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.all(MarginManager.marginXL * 2),
                  child: Column(
                    children: [updatePassword(profileController)],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  CustomButton updatePassword(ProfileController controller) {
    return CustomButton(
      color: ColorsManager.secondaryColor,
      hasInfiniteWidth: false,
      onPressed: () async {
        Get.defaultDialog(
          title: StringsManager.changePasswordTxt,
          titleStyle: const TextStyle(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: FontSize.titleFontSize),
          titlePadding:
              const EdgeInsets.symmetric(vertical: PaddingManager.paddingM),
          radius: 5,
          content: Form(
            key: profileController.editPassFormKey,
            child: Column(
              children: [
                Obx(
                  () => CustomTextFormField(
                    controller: profileController.oldPasswordController,
                    suffixIconData: controller.isObscure1.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    onSuffixTap: controller.toggleVisibility1,
                    labelText: StringsManager.oldPasswordTxt,
                    obscureText: controller.isObscure1.value,
                    prefixIconData: Icons.lock,
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kPasswordNullError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Obx(
                  () => CustomTextFormField(
                    controller: controller.newPasswordController,
                    labelText: StringsManager.newPasswordTxt,
                    suffixIconData: controller.isObscure2.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    onSuffixTap: controller.toggleVisibility2,
                    obscureText: controller.isObscure2.value,
                    prefixIconData: Icons.key,
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kPasswordNullError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Obx(
                  () => CustomTextFormField(
                    controller: controller.newRePasswordController,
                    labelText: StringsManager.newRePasswordTxt,
                    suffixIconData: controller.isObscure3.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    onSuffixTap: controller.toggleVisibility3,
                    obscureText: controller.isObscure3.value,
                    prefixIconData: Icons.key,
                    textInputAction: TextInputAction.done,
                    autofocus: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kPasswordNullError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Obx(
                  () => CustomButton(
                    color: ColorsManager.secondaryColor,
                    loadingWidget: controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor: ColorsManager.scaffoldBgColor,
                            ),
                          )
                        : null,
                    onPressed: () {
                      controller.changePassword(
                          controller.oldPasswordController.text.trim(),
                          controller.newPasswordController.text.trim(),
                          controller.newRePasswordController.text.trim());
                    },
                    text: "Change",
                    hasInfiniteWidth: true,
                    textColor: ColorsManager.backgroundColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      text: StringsManager.changePasswordTxt,
      textColor: ColorsManager.backgroundColor,
      buttonType: ButtonType.loading,
    );
  }
}
