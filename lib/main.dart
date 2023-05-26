import 'package:e_commerce_shopping_app/routes/app_pages.dart';
import 'package:e_commerce_shopping_app/routes/app_routes.dart';
import 'package:e_commerce_shopping_app/utils/exports/controllers_exports.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'managers/strings_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp().then((value) {
    Get.put(ThemeController());
  });
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StringsManager.appName,
      debugShowCheckedModeBanner: false,
      smartManagement: SmartManagement.full,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.themeMode,
    );
  }
}
