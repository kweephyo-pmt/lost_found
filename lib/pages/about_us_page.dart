import 'package:lost_found/const.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/lost_found.png', // Adjust the path as per your project structure
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Lost&Found helps people reunite with their lost items by providing a simple platform for posting and finding lost and found belongings in the community.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
