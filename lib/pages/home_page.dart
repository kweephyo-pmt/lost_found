import 'package:lost_found/components/bottom_nav_bar.dart';
import 'package:lost_found/const.dart';
import 'package:lost_found/pages/about_us_page.dart';
import 'package:lost_found/pages/found_page.dart';
import 'package:lost_found/pages/help_support.dart';
import 'package:lost_found/pages/settings.dart';
import 'profile_page.dart';
import 'package:lost_found/pages/lost_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});

 final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    LostPage(),
    FoundPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Lost And Found'),
        actions: [
          IconButton(
            onPressed: () => widget.signUserOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 225, 223, 223),
              ),
              child: Image.asset(
                'lib/images/lost_found.png', // Adjust the path to your image asset
                fit: BoxFit.contain, // Adjust the fit as per your requirement
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SettingsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: const Text('Help & Support'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  HelpAndSupportPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: const Text('About Us'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AboutUsPage()),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context); 
                  widget.signUserOut();                
                },
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
