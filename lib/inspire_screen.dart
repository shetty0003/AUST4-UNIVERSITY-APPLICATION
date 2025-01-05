import 'package:flutter/material.dart';
import 'courses_screen.dart';
import 'blog_screen.dart';
import 'gallery_screen.dart';



class InspireScreen extends StatefulWidget {
  const InspireScreen({Key? key}) : super(key: key);

  @override
  _InspireScreenState createState() => _InspireScreenState();
}

class _InspireScreenState extends State<InspireScreen> {
  int _selectedIndex = 0;

  // List of screens to navigate to
  final List<Widget> _screens = [
    const CoursesScreen(),
    BlogScreen(),
    const GalleryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INSPIRE')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery/About',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
// TODO Implement this library.