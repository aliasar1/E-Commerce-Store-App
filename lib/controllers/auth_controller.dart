import 'package:e_commerce_shopping_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../local/local_storage.dart';
import '../models/user_model.dart' as model;
import '../utils/exports/managers_exports.dart';
import '../utils/exports/views_exports.dart';
import '../utils/utils.dart';

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

  void resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Password reset email is send successfully.',
      );
    } catch (err) {
      Get.snackbar(
        'Error',
        err.toString(),
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
        await firebaseAuth.currentUser!.sendEmailVerification();

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
          'Account created successfully!',
          'Please verify account to proceed.',
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

        UserCredential userCredential = await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;

        if (user != null) {
          if (user.emailVerified) {
            setUserType(userType);
            if (userType == 'Buyer') {
              Get.offAll(const BuyerHomeScreen());
            } else {
              Get.offAll(const SellerHomeScreen());
            }
            toggleLoading();
            clearfields();
          } else {
            toggleLoading();
            Get.snackbar(
              'Error Logging in',
              'Please verify your email to login.',
            );
          }
        } else {
          toggleLoading();
          Get.snackbar(
            'Error Logging in',
            'Invalid email or password.',
          );
        }
      }
    } catch (err) {
      toggleLoading();
      Get.snackbar(
        'Error Logging in',
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
