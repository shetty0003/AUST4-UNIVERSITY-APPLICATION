// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _name;
  String? _email;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _name = userData['name'];
        _email = user.email;
      });
    }
  }

  Future<void> _updateUserInfo(String newName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({'name': newName});
      setState(() {
        _name = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: _name == null || _email == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $_name', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Email: $_email', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showEditNameDialog();
              },
              child: const Text('Edit Name'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateUserInfo(nameController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
// TODO Implement this library.