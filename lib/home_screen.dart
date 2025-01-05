import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SettingsScreen.dart';
import 'inspire_screen.dart';
import 'media_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tapCount = 0;

  void _onHeaderTap() {
    setState(() {
      _tapCount++;
    });

    if (_tapCount == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PlaceholderScreen('Simple Game'),
        ),
      );
      _tapCount = 0;
    }
  }

  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return snapshot.data()?['name'] ?? 'User';
    }
    return 'User';
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AUST Home'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: _onHeaderTap,
            child: Container(
              width: double.infinity,
              color: Colors.orangeAccent,
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<String>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  final userName = snapshot.data ?? 'User';
                  return Text(
                    'Welcome, $userName!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureButton(
                    context,
                    title: 'AUST News/Media',
                    icon: Icons.newspaper,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewsMediaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    title: 'Library',
                    icon: Icons.library_books,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceholderScreen('Library'),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    title: 'Academics',
                    icon: Icons.school,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceholderScreen('Academics'),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    title: 'General Chat',
                    icon: Icons.chat,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceholderScreen('General Chat'),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    title: 'Department Chat',
                    icon: Icons.group,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceholderScreen('Department Chat'),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    title: 'Map',
                    icon: Icons.map,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceholderScreen('Map'),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    title: 'AUST-Inspire',
                    icon: Icons.star,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InspireScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    context,
                    title: 'AUST-Sporty',
                    icon: Icons.sports,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceholderScreen('AUST-Sporty'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Text('This is the $title screen'),
      ),
    );
  }
}
