import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<PushNotificationsScreen> createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  bool _isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _updateNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enable Notifications',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Switch(
              value: _isNotificationsEnabled,
              onChanged: (value) async {
                await _updateNotificationPreference(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TODO Implement this library.