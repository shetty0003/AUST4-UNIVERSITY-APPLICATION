// email_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailSettingsScreen extends StatefulWidget {
  const EmailSettingsScreen({Key? key}) : super(key: key);

  @override
  State<EmailSettingsScreen> createState() => _EmailSettingsScreenState();
}

class _EmailSettingsScreenState extends State<EmailSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        await _firestore.collection('users').doc(user.uid).update({'email': newEmail});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email updated successfully.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating email: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Settings'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your email settings below:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Update Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newEmail = _emailController.text.trim();
                if (newEmail.isNotEmpty) {
                  await _updateEmail(newEmail);
                }
              },
              child: const Text('Save Email'),
            ),
          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.