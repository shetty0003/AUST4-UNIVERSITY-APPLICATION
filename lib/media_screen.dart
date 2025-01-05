import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_Screen.dart';


class NewsMediaScreen extends StatefulWidget {
  const NewsMediaScreen({Key? key}) : super(key: key);

  @override
  _NewsMediaScreenState createState() => _NewsMediaScreenState();
}

class _NewsMediaScreenState extends State<NewsMediaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _postController = TextEditingController();
  bool _isLoading = false;

  // Create a post
  Future<void> createPost() async {
    if (_postController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post content cannot be empty!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final username = userDoc['username'] ?? user.email;

      try {
        await _firestore.collection('user_posts').add({
          'userId': user.uid,
          'username': username,
          'content': _postController.text,
          'hashtags': extractHashtags(_postController.text),
          'likes': 0,
          'comments': [],
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _postController.clear();
        });
      } catch (e) {
        debugPrint("Error creating post: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Extract hashtags from the post content
  List<String> extractHashtags(String text) {
    final RegExp hashtagRegExp = RegExp(r'#\w+');
    return hashtagRegExp.allMatches(text).map((match) => match.group(0)!).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News/Media')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('user_posts').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint("Error in post stream: ${snapshot.error}");
                  return const Center(child: Text("Failed to load posts."));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(post['content']),
                            const SizedBox(height: 4),
                            if (post['hashtags'] != null && post['hashtags'].isNotEmpty)
                              Wrap(
                                spacing: 8.0,
                                children: (post['hashtags'] as List<dynamic>).map((hashtag) {
                                  return Chip(
                                    label: Text(
                                      hashtag,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: const InputDecoration(
                      hintText: 'Write something... (use #hashtags)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: _isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                  onPressed: createPost,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
