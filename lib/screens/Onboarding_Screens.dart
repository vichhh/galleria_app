import 'package:flutter/material.dart';
import 'package:galleria_app/screens/home_screen.dart';
import 'package:galleria_app/screens/singin_singup.dart'; // เพิ่ม import หน้าสมัคร/เข้าสู่ระบบ
import 'dart:async';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> with TickerProviderStateMixin {
  int _currentPage = 0;
  static const Color backgroundColor = Color(0xFF181818);

  final PageController _pageController = PageController(initialPage: 0);

  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Splash screen โชว์ 3 วิ แล้วไปหน้าแรกของ onboarding
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen
    if (_showSplash) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 220,
                  child: Image.network(
                    'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExcjNjcGJjeHNmMTZxYnNlcTM3cTZuMHdjZHlndWM3eTdrdm96a3huZiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l3q2rPsZ7nZLawF7G/giphy.gif',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Car Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Onboarding screens
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            // หน้า 1
            _OnboardContent(
              gifUrl: 'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExY3U4ODBjeHJ5anl4czdocnY4Ymc5MnNydjBuM2R3ejl1NDgxa3J1dSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/9HnHZz8z5PeVsKiZpH/giphy.gif',
              title: 'Welcome to Car Gallery!',
              desc: 'Discover a world of stunning car collections. Explore rare models, classic beauties, and the latest supercars all in one place.',
              showBack: false,
              showNext: true,
              showSkip: true, // ✅ Skip แค่หน้าแรก
              onBack: () {},
              onNext: () => animateToPage(1),
              onSkip: () => animateToPage(2), // ✅ ไปหน้าสุดท้าย
            ),
            // หน้า 2
            _OnboardContent(
              gifUrl: 'https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExbDNtcmhubm5wZnY3bGduaWJsNnRsbmhzZ3o5MHlxYTU5eXIwa2I5NyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/jObSEsMnQk4BGhjXQ1/giphy.gif',
              title: 'Share Your Passion',
              desc: 'Upload your own car photos and stories. Connect with fellow enthusiasts, comment, and build your dream garage.',
              showBack: true,
              showNext: true,
              onBack: () => animateToPage(0),
              onNext: () => animateToPage(2),
            ),
            // หน้า 3
            _OnboardContent(
              gifUrl: 'https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExM3dmMWllYnZ1a3NuZWxtM2Q5N3YwcDR0dzVtaXMyNnZ6aDlqODEzNyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/WUXTyq8A1C7OebUXOv/giphy.gif',
              title: 'Start Your Journey',
              desc: 'Enjoy browsing, sharing, and connecting in the ultimate car gallery app. Let\'s hit the road together!',
              showBack: true,
              showNext: false,
              onBack: () => animateToPage(1),
              onNext: () {
                // เปลี่ยนปลายทางจาก Home ไปหน้า Sign In / Sign Up
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SignInSignUpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget สำหรับแต่ละหน้า onboarding
class _OnboardContent extends StatelessWidget {
  final String gifUrl;
  final String title;
  final String desc;
  final bool showBack;
  final bool showNext;
  final bool showSkip;        // ✅ เพิ่ม
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback? onSkip; // ✅ เพิ่ม

  const _OnboardContent({
    required this.gifUrl,
    required this.title,
    required this.desc,
    required this.showBack,
    required this.showNext,
    required this.onBack,
    required this.onNext,
    this.showSkip = false,    // ✅ ค่า default
    this.onSkip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInBack,
      child: Column(
        key: ValueKey(title),
        children: [
          // จุดบอกหน้าปัจจุบัน (Page Indicator)
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final parentState = context.findAncestorStateOfType<_OnboardingScreensState>();
                final currentPage = parentState?._currentPage ?? 0;
                final isActive = currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? Color(0xFFFFA726) : Colors.grey[700],
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Color(0xFFFFA726).withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                );
              }),
            ),
          ),
          const Spacer(),
          Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.35),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  gifUrl,
                  fit: BoxFit.cover,
                  width: 180,
                  height: 180,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              desc,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              children: [
                if (showBack)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 8,
                        shadowColor: Colors.white.withOpacity(0.2),
                      ),
                      onPressed: onBack,
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (showBack) const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.orangeAccent,
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ).copyWith(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: onNext,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFA726),
                              Color(0xFFFF7043),
                              Color(0xFFFFD54F),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          child: Text(
                            showNext ? 'Next' : 'Get Started',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ✅ ปุ่ม Skip โชว์เฉพาะถ้า showSkip = true
          if (showSkip)
            TextButton(
              onPressed: onSkip,
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
