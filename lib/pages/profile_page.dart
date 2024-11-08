import 'package:lost_found/components/text_box.dart';
import 'package:lost_found/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User
  final currentUser = FirebaseAuth.instance.currentUser;
  // All users
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // Edit field function
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // Cancel button
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          // Save button
          TextButton(
            child: Text('Save', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // Update Firestore if newValue is not empty
    if (newValue.trim().isNotEmpty) {
      await userCollection.doc(currentUser?.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Center(child: Text('User not logged in.'));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person,
                  size: 72,
                ),
                const SizedBox(height: 25),
                // Using MyTextBox here
                MyTextBox(
                  text: userData['username'] ?? "Username not set",
                  sectionName: 'Username',
                  onPressed: () => editField('username'),
                ),
                const SizedBox(height: 10),
                MyTextBox(
                  text: userData['bio'] ?? "Bio not set",
                  sectionName: 'Bio',
                  onPressed: () => editField('bio'),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
