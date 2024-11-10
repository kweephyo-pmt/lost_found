import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class LostPage extends StatefulWidget {
  const LostPage({super.key});

  @override
  State<LostPage> createState() => _LostPageState();
}

class _LostPageState extends State<LostPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
 // final TextEditingController _locationController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;

  // ImgBB API key
  final String _imgBBApiKey = '0d6d27523acb2120f2ac29d61022c860';

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Method to upload the image to ImgBB
  Future<String?> _uploadImage(File image) async {
    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_imgBBApiKey');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        return data['data']['url']; // Return the image URL from ImgBB
      } else {
        print("Image upload failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  // Method to add a new lost item post to Firestore
  Future<void> _createLostPost() async {
    if (_itemController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      final User? user = FirebaseAuth.instance.currentUser ;
      final userName = user?.displayName ?? "Anonymous"; // Use displayName if available, else fallback to "Anonymous"

      await _firestore.collection('lost_items').add({
        'item': _itemController.text,
        'description': _descriptionController.text,
        'image_url': imageUrl,
        'user_id': user?.uid,
        'user_name': userName, // Store the username
        'created_at': FieldValue.serverTimestamp(),
      });

      _itemController.clear();
      _descriptionController.clear();
      setState(() {
        _imageFile = null;
      });
      Navigator.pop(context);
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  // Show a dialog to enter lost item details
void _showCreatePostDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of screen width
        decoration: BoxDecoration(
          color: Colors.white, // Use solid white background
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Subtle shadow for depth
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        padding: const EdgeInsets.all(20), // Increased padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with custom style
            const Text(
              "Report Lost Item",
              style: TextStyle(
                color: Colors.black, // Black text color
                fontSize: 35, // Increased font size
                //fontWeight: FontWeight.bold,
                //letterSpacing: 1.,
              ),
            ),
            const SizedBox(height: 25),

            // Item Name Input
            TextField(
              controller: _itemController,
              decoration:  InputDecoration(
                labelText: "Item Name",
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200], // Light grey background for input
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),

            // Description Input
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200], // Light grey background for input
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              maxLines: 4, // Increased max lines for description
            ),
            const SizedBox(height: 16),

            /*TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Location",
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200], // Light grey background for input
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              maxLines: 4, // Increased max lines for description
            ),
            const SizedBox(height: 16),*/
            // Add Image Button
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20), 
                backgroundColor: Colors.green, // Black button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Add Photo", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),

            // Image Preview
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _imageFile!,
                    height: 200, // Increased height for image preview
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
                // Report Button
                ElevatedButton(
                  onPressed: _createLostPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Report", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  // Method to format timestamp to only show date, hours, and minutes
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return 'Unknown time'; // Handle null timestamps
    }
    final DateTime dateTime = (timestamp as Timestamp).toDate();
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Lighter background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _showCreatePostDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 0, 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(color: Colors.white), // Change text color to white
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text("Report Lost Item", style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('lost_items').orderBy('created_at', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator ());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No lost items reported.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final createdAt = data['created_at'];
                      final formattedTime = _formatTimestamp(createdAt);
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color for the box
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3), // Light shadow
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0), // Padding inside the box
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['item'] ?? 'No name',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Reported by: ${data['user_name']} - $formattedTime',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['description'] ?? 'No description',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (data['image_url'] != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Open image in full-screen view
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FullScreenImage(imageUrl: data['image_url']),
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        data['image_url'],
                                        height: 300, // Adjust height for image size
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context), // Close full-screen image on tap
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}