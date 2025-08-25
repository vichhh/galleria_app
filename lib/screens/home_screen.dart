import 'dart:async';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'profile_screen.dart';
import 'package:galleria_app/screens/Onboarding_Screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Timer? _inactivityTimer;

  final List<Widget> _screens = [
    const GalleryScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
    const FavPhotoScreen(),
  ];

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 10), () {
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
          color: const Color(0xFF424242),
          index: _selectedIndex,
          height: 62,
          animationDuration: const Duration(milliseconds: 400),
          items: const [
            Icon(Icons.home, color: Colors.white, size: 32),
            Icon(Icons.person, color: Colors.white, size: 32),
            Icon(Icons.settings, color: Colors.white, size: 32),
            Icon(Icons.favorite, color: Colors.white, size: 32),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final posts = [
    'https://i.pinimg.com/736x/31/f4/53/31f453a3b1bbe02a304023b3b5c8310e.jpg',
    'https://i.pinimg.com/736x/9b/49/f4/9b49f4ec79bd1f483c757e964f8bbd16.jpg',
    'https://i.pinimg.com/1200x/3a/0a/fd/3a0afd1d66cfb03ac5861ea78f6d65f7.jpg',
  ];

  final gifUrl = 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExcGs5NjVoZDc2Y21ua2lpYzl4aTlwczBwcTc3dzk2cTY2dnk0dHB3biZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/kU7nXasJEJz44/giphy.gif';
  final gifPreview = 'https://i.pinimg.com/736x/a9/dd/f8/a9ddf8caa7d575cdd6d9841b4c6b69d4.jpg';

  List<bool> liked = [false, false, false, false];
  bool gifPlaying = false;

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String comment = '';
        return AlertDialog(
          backgroundColor: const Color(0xFF232526),
          title: const Text('Add a comment', style: TextStyle(color: Colors.white)),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Type your comment...',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              comment = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Send', style: TextStyle(color: Colors.purpleAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Galleria',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
              letterSpacing: 1.2,
            )),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index < posts.length) {
            return Card(
              color: Colors.black.withOpacity(0.6),
              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(posts[index], fit: BoxFit.cover, height: 270, width: double.infinity),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage('https://i.pinimg.com/736x/89/89/1e/89891e418aeb131b956a8ea7304a3881.jpg'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Car lover',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              liked[index] = !liked[index];
                            });
                          },
                          child: Icon(
                            liked[index] ? Icons.favorite : Icons.favorite_border,
                            color: liked[index] ? Colors.red : Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () => _showCommentDialog(context),
                          child: const Icon(Icons.comment_outlined, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // กรอบ gif
            return Card(
              color: Colors.black.withOpacity(0.6),
              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      children: [
                        Image.network(
                          gifPlaying ? gifUrl : gifPreview,
                          fit: BoxFit.cover,
                          height: 270,
                          width: double.infinity,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              gifPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                gifPlaying = !gifPlaying;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage('https://i.pinimg.com/736x/89/89/1e/89891e418aeb131b956a8ea7304a3881.jpg'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Car lover',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              liked[index] = !liked[index];
                            });
                          },
                          child: Icon(
                            liked[index] ? Icons.favorite : Icons.favorite_border,
                            color: liked[index] ? Colors.red : Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () => _showCommentDialog(context),
                          child: const Icon(Icons.comment_outlined, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
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
