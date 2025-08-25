import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gallery = [
      'https://i.pinimg.com/736x/15/36/21/153621fa2a771e8681e866afa8b18713.jpg',
      'https://i.pinimg.com/736x/62/00/60/6200602dcf47a90dc05f8e6cf74eab3a.jpg',
      'https://i.pinimg.com/736x/7b/53/7e/7b537eada3a15d5ad051f421b1590893.jpg',
      'https://i.pinimg.com/736x/ad/ef/c2/adefc256c08d78c18378df8fdc86429b.jpg',
      'https://i.pinimg.com/736x/db/48/89/db4889d285bd228419dadb3ae134c29d.jpg',
      'https://i.pinimg.com/736x/71/a9/11/71a911b41637a5e8c89c99f6b1e85a98.jpg',
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF232526), Color(0xFF0f0f0f)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar with soft gray glow border
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // สีเทาเรื่อนแสง
                      blurRadius: 18,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('https://i.pinimg.com/736x/68/79/4b/68794b914089c7b919846da5060c78ca.jpg'),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Vich Kub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  )),
              const SizedBox(height: 4),
              const Text('Runner | Photographer',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  )),
              const SizedBox(height: 16),
              // Stats Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Card(
                  color: Colors.black.withOpacity(0.5),
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat('Posts', '128'),
                        _buildStat('Followers', '2.4K'),
                        _buildStat('Following', '180'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Edit Profile Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700], // สีเทาเข้ม
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {},
              ),
              const SizedBox(height: 18),
              // Gallery Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: gallery.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      // สามารถเพิ่มฟีเจอร์ดูรูปเต็มจอได้
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // เงาสีเทาเรื่อนแสง
                            blurRadius: 12,
                            offset: const Offset(2, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(gallery[index], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            )),
      ],
    );
  }
}