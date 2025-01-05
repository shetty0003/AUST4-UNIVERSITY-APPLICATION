import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blog', style: TextStyle(fontFamily: 'Georgia', fontSize: 24)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('blog_posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No blog posts yet. Create one to get started!',
                style: TextStyle(fontSize: 18, fontFamily: 'Georgia'),
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final postData = post.data() as Map<String, dynamic>?;

              final subject = postData?.containsKey('subject') == true ? postData!['subject'] : 'No Subject';
              final content = postData?.containsKey('content') == true ? postData!['content'] : 'No Content';
              final image = postData?.containsKey('image') == true ? postData!['image'] : '';
              final createdAt = (postData?['createdAt'] as Timestamp?)?.toDate();
              final formattedDate = createdAt != null
                  ? "${createdAt.day}/${createdAt.month}/${createdAt.year}"
                  : "Unknown date";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      if (image.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text(
                                  'Image failed to load',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        subject,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Date
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),

                      // Content Preview
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Georgia',
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      // Read More Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlogDetailScreen(postId: post.id),
                              ),
                            );
                          },
                          child: const Text(
                            'Read More',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Example BlogDetailScreen
class BlogDetailScreen extends StatelessWidget {
  final String postId;

  const BlogDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details', style: TextStyle(fontFamily: 'Georgia', fontSize: 24)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('blog_posts').doc(postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Post not found.'));
          }

          final post = snapshot.data!;
          final postData = post.data() as Map<String, dynamic>?;
          final subject = postData?['subject'] ?? 'No Subject';
          final content = postData?['content'] ?? 'No Content';
          final image = postData?['image'] ?? '';

          return SingleChildScrollView(
            child: Column(
              children: [
                if (image.isNotEmpty)
                  Image.network(image, fit: BoxFit.cover, width: double.infinity, height: 300),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: const TextStyle(fontSize: 16, fontFamily: 'Georgia', height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
//Use Firebase Storage for image uploads.
// Use Firebase Remote Config for lightweight, dynamic app updates.
// Use Firebase App Distribution or Hosting for distributing new builds.// TODO Implement this library.