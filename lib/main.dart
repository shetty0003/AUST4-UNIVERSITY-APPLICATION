import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core for initialization
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase SDK
import 'login_screen.dart'; // Your custom login screen

void main() async {
  // Ensure Flutter framework bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(); // Required for Firebase services

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://femvrwwntiesmwvxehqc.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZlbXZyd3dudGllc213dnhlaHFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxNzEzNzgsImV4cCI6MjA1MTc0NzM3OH0.NXsbpp3tGsis8I3yfpkjmQy-XCIw1XU1PETBfATqH_g', // Replace with your Supabase anonymous key
  );

  // Run the app
  runApp(const Aust4());
}

class Aust4 extends StatelessWidget {
  const Aust4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AUST School App', // App name
      theme: ThemeData(
        primarySwatch: Colors.orange, // Use a consistent primary color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(), // Navigate to the login screen on startup
      debugShowCheckedModeBanner: false, // Disable debug banner for a cleaner UI
    );
  }
}
