import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery/About Dazzle Me')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'About Dazzle Me',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Dazzle Me is a platform that brings inspiration, creativity, and learning to the forefront. Our goal is to help you discover the latest trends in tech, design, and education.',
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Gallery',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 6, // Example, you can fetch more from a database
              itemBuilder: (context, index) {
                return Image.network('assets/aust_logo.png${index + 1}.jpg');
              },
            ),
          ),
        ],
      ),
    );
  }
}
// TODO Implement this library.// TODO Implement this library.