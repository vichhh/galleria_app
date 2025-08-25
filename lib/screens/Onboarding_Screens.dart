import 'package:flutter/material.dart';
import 'package:galleria_app/screens/home_screen.dart';

class OnboardingScreens extends StatelessWidget {
  const OnboardingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังดำล้วน
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
              // ถ้าเลื่อนขึ้น (primaryVelocity ติดลบ)
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
          child: Column(
            children: [
              const Spacer(),
              // GIF ตรงกลาง (มีอันเดียว)
              SizedBox(
                height: 320,
                child: Center(
                  child: Image.network(
                    'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExcjNjcGJjeHNmMTZxYnNlcTM3cTZuMHdjZHlndWM3eTdrdm96a3huZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l3q2rPsZ7nZLawF7G/giphy.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),
              // ไอคอนลูกศรขึ้นและข้อความแนะนำ
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.white,
                      size: 48,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Swipe up to enter the app',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}