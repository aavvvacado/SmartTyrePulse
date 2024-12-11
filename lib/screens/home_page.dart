import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_tyre_pulse/screens/screen_1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogin = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  void toggleAuthPage() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Lottie.asset(
          'assets/images/tyre.json',
          width: 200,
          height: 200,
          repeat: true,
        ),
      ),
    );

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('login')
          .where('username', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      Navigator.of(context).pop(); // Close the loader dialog

      if (snapshot.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Screen1()),
        );
      } else {
        showErrorDialog("Invalid username or password.");
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loader dialog
      showErrorDialog("An error occurred. Please try again.");
    }
  }

  Future<void> register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String role = roleController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && role.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('login').add({
          'username': email,
          'password': password,
          'role': role,
        });
        showSuccessDialog("Registration successful! Please login.");
        toggleAuthPage();
      } catch (e) {
        showErrorDialog("Registration failed. Please try again.");
      }
    } else {
      showErrorDialog("All fields are required.");
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text("Error", style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK", style: TextStyle(color: Colors.yellow)),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.yellow),
            SizedBox(width: 10),
            Text("Success", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK", style: TextStyle(color: Colors.yellow)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 320,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg1.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                isLogin ? "Login" : "Register",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow[800],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1800),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.3),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          buildTextField(
                            "Username",
                            emailController,
                            icon: Icons.person,
                          ),
                          SizedBox(height: 20),
                          buildTextField(
                            "Password",
                            passwordController,
                            obscureText: true,
                            icon: Icons.lock,
                          ),
                          if (!isLogin)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: buildTextField(
                                "Role",
                                roleController,
                                icon: Icons.supervisor_account,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  FadeInUp(
                    duration: Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: isLogin ? login : register,
                      child: buildAuthButton(),
                    ),
                  ),
                  if (isLogin) buildForgotPassword(),
                  buildToggleAuthButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField buildTextField(String hintText, TextEditingController controller,
      {bool obscureText = false, IconData? icon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.yellow[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(icon, color: Colors.yellow[800]),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[900]),
      ),
    );
  }

  Container buildAuthButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Colors.yellow[800]!,
            Colors.yellow[600]!,
          ],
        ),
      ),
      child: Center(
        child: Text(
          isLogin ? "Login" : "Register",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  FadeInUp buildForgotPassword() {
    return FadeInUp(
      duration: Duration(milliseconds: 2000),
      child: Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.yellow[800]),
      ),
    );
  }

  FadeInUp buildToggleAuthButton() {
    return FadeInUp(
      duration: Duration(milliseconds: 2100),
      child: TextButton(
        onPressed: toggleAuthPage,
        child: Text(
          isLogin
              ? "Don't have an account? Register"
              : "Already have an account? Login",
          style: TextStyle(color: Colors.yellow[800]),
        ),
      ),
    );
  }
}
