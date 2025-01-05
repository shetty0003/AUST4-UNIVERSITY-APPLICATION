import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView(
        children: [
          CourseCard(title: "Introduction to Flutter", description: "Learn how to build apps using Flutter."),
          CourseCard(title: "Web Development Basics", description: "Start with the basics of HTML, CSS, and JavaScript."),
          CourseCard(title: "Data Science with Python", description: "Learn the fundamentals of data analysis using Python."),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String description;

  const CourseCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to course details (optional)
        },
      ),
    );
  }
}
// TODO Implement this library.// TODO Implement this library.