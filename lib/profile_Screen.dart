import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? _selectedImage;
  bool _isUploading = false;
  String? _uploadedImageUrl;

  final ImagePicker _picker = ImagePicker();

  // Pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Upload image to Cloudinary
  Future<String?> _uploadToCloudinary(File imageFile) async {
    try {
      final cloudinaryUrl = 'https://api.cloudinary.com/v1_1/YOUR_CLOUD_NAME/image/upload';
      final uploadPreset = 'YOUR_UNSIGNED_PRESET';

      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url']; // Cloudinary URL
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      debugPrint('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  // Save image URL to Firestore
  Future<void> _saveImageUrlToFirestore(String imageUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'profilePic': imageUrl,
      });
    }
  }

  // Handle image upload and Firestore update
  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    final imageUrl = await _uploadToCloudinary(_selectedImage!);
    if (imageUrl != null) {
      await _saveImageUrlToFirestore(imageUrl);
      setState(() {
        _uploadedImageUrl = imageUrl;
        _isUploading = false;
      });
    } else {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : (_uploadedImageUrl != null
                    ? NetworkImage(_uploadedImageUrl!)
                    : const AssetImage('assets/default_avatar.png')) as ImageProvider,
                child: _selectedImage == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            if (_uploadedImageUrl != null)
              Text(
                'Uploaded Image URL:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (_uploadedImageUrl != null)
              SelectableText(
                _uploadedImageUrl!,
                style: const TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.