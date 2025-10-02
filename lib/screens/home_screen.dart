import 'dart:async';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'profile_screen.dart';
import 'package:galleria_app/screens/Onboarding_Screens.dart';
import 'products_screen.dart'; // <-- add

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Timer? _inactivityTimer;

  final List<Widget> _screens = [
    const ProductsScreen(),  // <-- replace Gallery with Products
    const ProfileScreen(),
    const SettingsScreen(),
    const FavPhotoScreen(),
  ];

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 60), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreens()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      onPanDown: (_) => _resetTimer(),
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF232526), Color(0xFF181818)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: const Color(0xFF22252B), // แนวคาร์บอนไฟเบอร์เข้ม
          index: _selectedIndex,
          height: 62,
          animationDuration: const Duration(milliseconds: 400),
          items: const [
            Icon(Icons.home, color: Colors.white, size: 32),
            Icon(Icons.person, color: Colors.white, size: 32),
            Icon(Icons.settings, color: Colors.white, size: 32),
            Icon(Icons.favorite, color: Colors.white, size: 32),
          ],
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.1,
            )),
        centerTitle: true,
      ),
      body: const Center(
        child: Icon(Icons.settings, color: Colors.grey, size: 80),
      ),
    );
  }
}

class FavPhotoScreen extends StatelessWidget {
  const FavPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favPhotos = [
      'https://i.pinimg.com/736x/9b/49/f4/9b49f4ec79bd1f483c757e964f8bbd16.jpg',
      'https://i.pinimg.com/1200x/3a/0a/fd/3a0afd1d66cfb03ac5861ea78f6d65f7.jpg',
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Favorite Photos',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.1,
            )),
        centerTitle: true,
      ),
      body: favPhotos.isEmpty
          ? const Center(
              child: Icon(Icons.favorite, color: Colors.pink, size: 80),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(18),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: favPhotos.length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(favPhotos[index], fit: BoxFit.cover),
              ),
            ),
    );
  }
}
