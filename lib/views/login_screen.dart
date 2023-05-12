import 'package:e_commerce_shopping_app/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../utils/exports/managers_exports.dart';
import '../utils/size_config.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/cutom_button.dart';
import '../widgets/packages/group_radio_buttons/src/radio_button_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    AuthenticateController controller = Get.put(AuthenticateController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsManager.scaffoldBgColor,
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
                      child: const Txt(
                        text: StringsManager.welcomTxt,
                        textAlign: TextAlign.left,
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeightManager.bold,
                        fontSize: FontSize.titleFontSize,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Txt(
                        text: StringsManager.loginAccTxt,
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: ColorsManager.primaryColor,
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
                        labelText: 'controller Type',
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: const TextStyle(
                          color: ColorsManager.primaryColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsManager.primaryColor,
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
                        onFieldSubmit: (_) => controller.login(
                            controller.emailController.text,
                            controller.passwordController.text,
                            controller.userTypeController),
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
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.bottomRight,
                        child: const Txt(
                          text: StringsManager.forgotPassTxt,
                          color: ColorsManager.primaryColor,
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
                        onPressed: () {
                          controller.login(
                              controller.emailController.text,
                              controller.passwordController.text,
                              controller.userTypeController);
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
                        const Txt(
                          text: StringsManager.noAccTxt,
                          fontSize: FontSize.textFontSize,
                          color: ColorsManager.primaryColor,
                        ),
                        InkWell(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          ),
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
}
