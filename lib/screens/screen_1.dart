import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dumper_list.dart'; // Import your DumperListScreen class
import 'dumper_list1.dart';
import 'home_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Screen1(),
      '/DumperListScreen': (context) => DumperListScreen(),
      '/HomePage': (context) => HomePage(),
    },
  ));
}

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late String username = '';
  late String role = '';
  late String userPhotoUrl = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // PageController to control the PageView
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetching user data from Firestore
  _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Fetch user data from Firestore from the 'login' collection
      DocumentSnapshot docSnapshot =
          await _firestore.collection('login').doc(user.uid).get();
      if (docSnapshot.exists) {
        setState(() {
          username = docSnapshot['username'] ?? 'No name';
          role = docSnapshot['role'] ?? 'No role';
          userPhotoUrl =
              user.photoURL ?? ''; // Can be used for displaying profile picture
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Tyre Pulse',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle), // Profile icon
            color: Colors.black,
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'name',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Name: Admin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'role',
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Role: Admin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: MainContent(
        pageController: _pageController,
        currentPage: _currentPage,
        onPageChanged: _onPageChanged,
      ),
    );
  }

  // Logout function
  _logout() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage()), // Redirecting to the HomePage
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }
}

class MainContent extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;

  MainContent({
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          // PageView for swiping between cards
          Expanded(
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: onPageChanged,
              children: [
                CustomCard(
                  label: 'Inventory Record',
                  icon: Icons.inventory,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DumperListScreen1(),
                      ),
                    );
                  },
                ),
                CustomCard(
                  label: 'Tkph Calculator',
                  icon: Icons.calculate,
                  onPressed: () {
                    const link = "https://tkph-calculator-1.onrender.com/";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  },
                ),
                CustomCard(
                  label: 'Tyre Analysis',
                  icon: Icons.analytics,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DumperListScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Dot indicators below the cards
          _buildPageIndicators(),
        ],
      ),
    );
  }

  // Function to build the dots based on the number of pages
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: currentPage == index ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  CustomCard({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = MediaQuery.of(context).size.height * 0.3;

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.5),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 150),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.yellow),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.black,
              ),
              SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
