// language_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _currentLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _updateLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      _currentLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languages = ['English', 'French', 'Spanish', 'German'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return ListTile(
            title: Text(language),
            trailing: _currentLanguage == language
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await _updateLanguagePreference(language);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
// TODO Implement this library.// TODO Implement this library.