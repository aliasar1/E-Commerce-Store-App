import 'package:e_commerce_shopping_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/exports/managers_exports.dart';
import '../utils/size_config.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/cutom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                //key: signupFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/signup.svg',
                        height: SizeManager.svgImageSizeMed,
                        width: SizeManager.svgImageSizeMed,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Txt(
                        text: StringsManager.registerTxt,
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
                        text: StringsManager.registerNowTxt,
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeightManager.medium,
                        fontSize: FontSize.subTitleFontSize * 1.3,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: nameController,
                      labelText: StringsManager.nameTxt,
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kUserNameNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: phoneController,
                      labelText: StringsManager.phoneTxt,
                      autofocus: false,
                      hintText: StringsManager.phoneHintTxt,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kPhoneNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: emailController,
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
                    CustomTextFormField(
                      controller: passwordController,
                      autofocus: false,
                      labelText: StringsManager.passwordTxt,
                      obscureText: isObscure,
                      prefixIconData: Icons.vpn_key_rounded,
                      suffixIconData: isObscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      onSuffixTap: toggleVisibility,
                      textInputAction: TextInputAction.done,
                      onFieldSubmit: (v) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kPasswordNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    CustomButton(
                      color: ColorsManager.secondaryColor,
                      hasInfiniteWidth: true,
                      loadingWidget: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: ColorsManager.scaffoldBgColor,
                              ),
                            )
                          : null,
                      onPressed: () {},
                      text: StringsManager.registerTxt,
                      textColor: ColorsManager.whiteColor,
                      buttonType: ButtonType.loading,
                    ),
                    const SizedBox(
                      height: SizeManager.sizeL,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Txt(
                          text: StringsManager.alreadyHaveAccTxt,
                          fontSize: FontSize.textFontSize,
                          color: ColorsManager.primaryColor,
                        ),
                        InkWell(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                          child: const Txt(
                            text: StringsManager.loginTxt,
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

  void toggleVisibility() {
    isObscure = !isObscure;
  }
}
