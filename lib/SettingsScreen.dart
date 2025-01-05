import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart'; // Ensure this file has a valid ProfileScreen widget

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false; // Default theme is light

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    // Display feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isDarkMode ? 'Dark mode enabled' : 'Light mode enabled'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Account Settings'),
            _buildSettingsOption(
              context,
              title: 'Profile',
              icon: Icons.account_circle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Email Settings',
              icon: Icons.email,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceholderScreen('Email Settings')),
                );
              },
            ),
            _buildDivider(),
            _buildSectionTitle('Notification Settings'),
            _buildSettingsOption(
              context,
              title: 'Push Notifications',
              icon: Icons.notifications,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceholderScreen('Push Notifications')),
                );
              },
            ),
            _buildDivider(),
            _buildSectionTitle('App Settings'),
            _buildSettingsOption(
              context,
              title: 'Dark Mode',
              icon: Icons.dark_mode,
              onTap: _toggleDarkMode,
            ),
            _buildSettingsOption(
              context,
              title: 'Language',
              icon: Icons.language,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceholderScreen('Language')),
                );
              },
            ),
            _buildDivider(),
            _buildSettingsOption(
              context,
              title: 'Log Out',
              icon: Icons.logout,
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing out: $e'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen(this.title, {Key? key}) : super(key: key);

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
