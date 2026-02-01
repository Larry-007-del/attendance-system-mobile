import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/firebase_options.dart';
import 'package:project/screens/home_screen/home_screen.dart';
import 'package:project/screens/login_screen/signup_screen.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login_screen(),
    ),
  );
}

class login_screen extends StatefulWidget {
  static String routeName = 'login_screen';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<login_screen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        print('Signed in: ${user.email}');
        Navigator.pushNamed(context, HomeScreen.routeName);
      } else {
        print('Sign in failed. User is null.');
      }
    } catch (e) {
      print('Sign in failed: $e');
    }
  }

  void _navigateToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40,),
            Center(
              child: Text('Sign in',style: TextStyle(fontSize: 25,)),
            ),
            SizedBox(height: 150,),
          TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the circular border radius
          ),
        ),
      ),
      SizedBox(height: 16.0),

      // Password Field
      TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the circular border radius
          ),
        ),
      ),
            SizedBox(height: 32.0),

            // Sign In Button
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Sign In'),
            ),
            SizedBox(height: 16.0),

            // Sign Up Button
            TextButton(
              onPressed: _navigateToSignUpScreen,
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
