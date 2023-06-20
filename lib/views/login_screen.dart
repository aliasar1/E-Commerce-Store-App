import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../utils/size_config.dart';
import '../widgets/packages/group_radio_buttons/src/radio_button_field.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = '/loginScreen';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    AuthenticateController controller = Get.put(AuthenticateController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode
            ? DarkColorsManager.scaffoldBgColor
            : ColorsManager.scaffoldBgColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  vertical: MarginManager.marginXL,
                  horizontal: MarginManager.marginXL),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.shopping_cart,
                        color: ColorsManager.secondaryColor,
                        size: SizeManager.sizeXL * 7,
                      ),
                    ),
                    const Txt(
                      text: StringsManager.appName,
                      color: ColorsManager.secondaryColor,
                      fontFamily: FontsManager.fontFamilyPoppins,
                      fontSize: FontSize.headerFontSize,
                      fontWeight: FontWeightManager.bold,
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Txt(
                        text: StringsManager.welcomTxt,
                        textAlign: TextAlign.left,
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: isDarkMode
                            ? DarkColorsManager.whiteColor
                            : ColorsManager.primaryColor,
                        fontWeight: FontWeightManager.bold,
                        fontSize: FontSize.titleFontSize,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Txt(
                        text: StringsManager.loginAccTxt,
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: isDarkMode
                            ? DarkColorsManager.whiteColor
                            : ColorsManager.primaryColor,
                        fontWeight: FontWeightManager.medium,
                        fontSize: FontSize.subTitleFontSize * 1.3,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    CustomTextFormField(
                      controller: controller.emailController,
                      labelText: StringsManager.emailTxt,
                      autofocus: false,
                      hintText: StringsManager.emailHintTxt,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kEmailNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    RadioButtonFormField(
                      labels: const ['Buyer', 'Seller'],
                      icons: const [Icons.shopping_bag, Icons.store],
                      onChange: (String label, int index) =>
                          controller.userTypeController = label,
                      onSelected: (String label) =>
                          controller.userTypeController = label,
                      decoration: InputDecoration(
                        labelText: 'User Type',
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? DarkColorsManager.whiteColor
                              : ColorsManager.primaryColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? DarkColorsManager.whiteColor
                                : ColorsManager.primaryColor,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(RadiusManager.fieldRadius),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeL,
                    ),
                    Obx(
                      () => CustomTextFormField(
                        controller: controller.passwordController,
                        autofocus: false,
                        labelText: StringsManager.passwordTxt,
                        obscureText: controller.isObscure.value,
                        prefixIconData: Icons.vpn_key_rounded,
                        suffixIconData: controller.isObscure.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        onSuffixTap: controller.toggleVisibility,
                        textInputAction: TextInputAction.done,
                        onFieldSubmit: (_) async {
                          bool isValid = await controller.login(
                              controller.emailController.text,
                              controller.passwordController.text,
                              controller.userTypeController);
                          if (isValid) {
                            if (!firebaseAuth.currentUser!.emailVerified) {
                              await controller.removeToken();
                              verifyDialog(isDarkMode, controller);
                            }
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ErrorManager.kPasswordNullError;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeM,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.emailController.text.isNotEmpty) {
                          controller.resetPassword(
                              controller.emailController.text.trim());
                        } else {
                          Get.snackbar('Invalid',
                              'Please provide email first to reset password.');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.bottomRight,
                        child: Txt(
                          text: StringsManager.forgotPassTxt,
                          color: isDarkMode
                              ? DarkColorsManager.whiteColor
                              : ColorsManager.primaryColor,
                          fontSize: FontSize.textFontSize * 0.9,
                          fontWeight: FontWeightManager.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    Obx(
                      () => CustomButton(
                        color: ColorsManager.secondaryColor,
                        hasInfiniteWidth: true,
                        buttonType: ButtonType.loading,
                        loadingWidget: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  backgroundColor:
                                      ColorsManager.scaffoldBgColor,
                                ),
                              )
                            : null,
                        onPressed: () async {
                          bool isValid = await controller.login(
                              controller.emailController.text,
                              controller.passwordController.text,
                              controller.userTypeController);
                          if (isValid) {
                            if (!firebaseAuth.currentUser!.emailVerified) {
                              await controller.removeToken();
                              verifyDialog(isDarkMode, controller);
                            }
                          }
                        },
                        text: StringsManager.loginTxt,
                        textColor: ColorsManager.whiteColor,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeL,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Txt(
                          text: StringsManager.noAccTxt,
                          fontSize: FontSize.textFontSize,
                          color: isDarkMode
                              ? DarkColorsManager.whiteColor
                              : ColorsManager.primaryColor,
                        ),
                        InkWell(
                          onTap: () {
                            controller.clearfields();
                            Get.offAll(const SignupScreen());
                          },
                          child: const Txt(
                            text: StringsManager.registerTxt,
                            fontSize: FontSize.textFontSize,
                            color: ColorsManager.lightSecondaryColor,
                            fontWeight: FontWeightManager.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> verifyDialog(
      bool isDarkMode, AuthenticateController controller) {
    return Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Txt(
            text: "Verify your email",
            color: isDarkMode
                ? DarkColorsManager.whiteColor
                : ColorsManager.primaryColor,
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.textFontSize,
            fontWeight: FontWeightManager.bold,
          ),
          content: Txt(
            text: "An email is sent to you, please verify your account.",
            color: isDarkMode
                ? DarkColorsManager.whiteColor
                : ColorsManager.primaryColor,
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.subTitleFontSize,
            fontWeight: FontWeightManager.regular,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await firebaseAuth.currentUser!.sendEmailVerification();
                  controller.logout();
                  Get.offAll(const LoginScreen());
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to send email verification: $e',
                  );
                }
              },
              child: const Txt(
                text: "Resend Email",
                color: ColorsManager.secondaryColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.subTitleFontSize,
                fontWeight: FontWeightManager.regular,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: isDarkMode
                      ? MaterialStateProperty.all(ColorsManager.backgroundColor)
                      : MaterialStateProperty.all(
                          DarkColorsManager.secondaryColor)),
              onPressed: () {
                controller.logout();
                Get.offAll(const LoginScreen());
              },
              child: Txt(
                text: "Login",
                color: isDarkMode
                    ? ColorsManager.secondaryColor
                    : ColorsManager.backgroundColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.subTitleFontSize,
                fontWeight: FontWeightManager.regular,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
