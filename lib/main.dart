import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart'; // Import Firebase Auth

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(aust4());
}

class aust4 extends StatelessWidget {
  const aust4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AUST School App',
      home: LoginScreen(), // The screen that shows after Firebase initialization
    );
  }
}