import 'package:flutter/material.dart';
import 'screens/Onboarding_Screens.dart'; // เพิ่ม import
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Galleria App',
      home: const OnboardingScreens(), // เปลี่ยนหน้าแรกเป็น Onboarding
    );
  }
}