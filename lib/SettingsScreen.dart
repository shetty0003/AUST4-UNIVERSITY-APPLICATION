import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profiles_screen.dart';
import 'email_settings_screen.dart';
import 'push_notifications_screen.dart';
import 'language_selection_screen.dart';

class ModernSettingsScreen extends StatefulWidget {
  const ModernSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ModernSettingsScreen> createState() => _ModernSettingsScreenState();
}

class _ModernSettingsScreenState extends State<ModernSettingsScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveDarkModePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'isDarkMode': isDarkMode}, SetOptions(merge: true));
  }

  Future<void> _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'language': language}, SetOptions(merge: true));
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveDarkModePreference(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
        title: const Text('Settings'),
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    elevation: 1,
    ),
    body: ListView(
    padding: const EdgeInsets.all(16.0),
    children: [
       _buildSettingsOption(
        context,
        title: 'Push Notifications',
        icon: Icons.notifications,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PushNotificationsScreen(),
            ),
          );
        },
      ),
      const Divider(),
      _buildSectionTitle('App Settings'),
      _buildSettingsOption(
        context,
        title: 'Language',
        icon: Icons.language,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            ),
          );
        },
      ),
      _buildSettingsOption(
        context,
        title: 'Dark Mode',
        icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
        onTap: _toggleDarkMode,
        trailing: Switch(
          value: _isDarkMode,
          onChanged: (value) {
            _toggleDarkMode();
          },
        ),
      ),
    ],
    ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
        Widget? trailing,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
