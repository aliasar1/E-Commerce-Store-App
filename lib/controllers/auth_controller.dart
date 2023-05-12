import 'package:e_commerce_shopping_app/local/local_storage.dart';
import 'package:e_commerce_shopping_app/views/login_screen.dart';
import 'package:e_commerce_shopping_app/views/seller_home_screen.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart' as model;
import '../managers/firebase_manager.dart';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/utils.dart';
import '../views/buyer_home_screen.dart';

class AuthenticateController extends GetxController with CacheManager {
  model.User? _user;

  model.User get getUser => _user!;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String userTypeController = 'Buyer';

  RxBool isLoggedIn = false.obs;
  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  Future<void> refreshUser() async {
    model.User user = await getUserDetails();
    _user = user;
  }

  Future<model.User> getUserDetails() async {
    User currentUser = firebaseAuth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
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
        );

        // adding user in our database
        await firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        toggleLoading();
        Get.offAll(LoginScreen());
        Get.snackbar(
          'Success!',
          'Account created successfully.',
        );
        clearfields();
      }
    } catch (e) {
      toggleLoading();
      Get.snackbar(
        'Error Loggin in',
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
          Get.offAll(BuyerHomeScreen());
        } else {
          Get.offAll(SellerHomeScreen());
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

  void clearfields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    userTypeController = 'Buyer';
  }
}
