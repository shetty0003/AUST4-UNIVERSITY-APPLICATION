import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> createPost() async {
    if (_postController.text.trim().isEmpty) {
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
        _postController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post created successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error creating post.")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News/Media', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user_posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Failed to load posts."));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No posts yet. Be the first to post!"));
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(post: post);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'Write something... (use #hashtags)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: _isLoading ? null : createPost,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final QueryDocumentSnapshot post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 8),
            Text(
              post['content'],
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (post['hashtags'] != null && (post['hashtags'] as List<dynamic>).isNotEmpty)
              Wrap(
                spacing: 8.0,
                children: (post['hashtags'] as List<dynamic>).map((hashtag) {
                  return Chip(
                    label: Text(
                      hashtag,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

List<String> extractHashtags(String text) {
  final RegExp hashtagRegExp = RegExp(r'#\w+');
  return hashtagRegExp.allMatches(text).map((match) => match.group(0)!).toList();
}
