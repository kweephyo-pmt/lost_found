import 'package:lost_found/const.dart';
import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'If you have any questions or need assistance, please feel free to contact our support team:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Email: supportt@lost&found.com',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Phone: +66-80-474-5234',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'You can also visit our website for more information:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Add the URL of your website
                // You can use the url_launcher package to open the website URL in the user's default browser
              },
              child: const Text(
                'www.LostAndFound.org',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 1, 93, 168)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
