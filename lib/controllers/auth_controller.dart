import 'package:e_commerce_shopping_app/local/local_storage.dart';
import 'package:e_commerce_shopping_app/views/login_screen.dart';
import 'package:e_commerce_shopping_app/views/seller_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart' as model;
import '../managers/firebase_manager.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../utils/exports/managers_exports.dart';
import '../utils/utils.dart';
import '../views/buyer_home_screen.dart';
import '../widgets/custom_text.dart';

class AuthenticateController extends GetxController with CacheManager {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  late String userTypeController = 'Buyer';

  RxBool isLoggedIn = false.obs;
  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
  }

  Future<void> checkLoginStatus() async {
    firebaseAuth.idTokenChanges().listen((User? user) {
      if (user == null) {
        removeToken();
        Get.off(const LoginScreen());
      } else {
        if (getUserType() == "Seller") {
          Get.offAll(const SellerHomeScreen());
        } else {
          Get.offAll(const BuyerHomeScreen());
        }
      }
    });
  }

  void toggleLoading({bool showMessage = false, String message = ''}) {
    isLoading.value = !isLoading.value;
    if (showMessage) {
      Utils.showSnackBar(
        message,
        isSuccess: false,
      );
    }
  }

  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      if (signupFormKey.currentState!.validate()) {
        signupFormKey.currentState!.save();
        toggleLoading();
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.User user = model.User(
          name: name,
          uid: cred.user!.uid,
          phone: phone,
          email: email,
          profilePhoto: "",
          address: address,
        );

        await firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        removeToken();
        toggleLoading();

        Get.snackbar(
          'Success!',
          'Account created successfully.',
        );
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Txt(
                text: StringsManager.firstTimeLoginTitle,
                color: ColorsManager.primaryColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.textFontSize,
                fontWeight: FontWeightManager.bold,
              ),
              content: const Txt(
                text: StringsManager.firstTimeLogin,
                color: ColorsManager.primaryColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.subTitleFontSize,
                fontWeight: FontWeightManager.regular,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    logout();
                    Get.offAll(const LoginScreen());
                  },
                  child: const Txt(
                    text: StringsManager.loginTxt,
                    color: ColorsManager.secondaryColor,
                    fontFamily: FontsManager.fontFamilyPoppins,
                    fontSize: FontSize.textFontSize,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
        clearfields();
      }
    } catch (e) {
      toggleLoading();
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  Future<void> login(String email, String password, String userType) async {
    try {
      if (loginFormKey.currentState!.validate()) {
        loginFormKey.currentState!.save();
        toggleLoading();
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        setUserType(userType);
        if (userType == 'Buyer') {
          Get.offAll(const BuyerHomeScreen());
        } else {
          Get.offAll(const SellerHomeScreen());
        }
        toggleLoading();
        clearfields();
      }
    } catch (err) {
      toggleLoading();
      Get.snackbar(
        'Error Loggin in',
        err.toString(),
      );
    }
  }

  void logout() async {
    removeToken();
    await firebaseAuth.signOut();
  }

  void clearfields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    addressController.clear();
    userTypeController = 'Buyer';
  }
}
