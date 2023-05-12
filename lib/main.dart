import 'package:flutter/material.dart';

import 'managers/strings_manager.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: StringsManager.appName,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
