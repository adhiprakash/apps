
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'admin_screen.dart';
import 'student_screen.dart';

class MergedSignInScreen extends StatefulWidget {
  final bool isAdmin;
  const MergedSignInScreen({super.key, required this.isAdmin});

  @override
  _MergedSignInScreenState createState() => _MergedSignInScreenState();
}

class _MergedSignInScreenState extends State<MergedSignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final List<String> adminEmails = ["adithyaprakash143@gmail.com"];

  Future<void> signIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      if (widget.isAdmin && adminEmails.contains(user.email)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else if (!widget.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudentScreen()),
        );
      } else {
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized Access')),
        );
      }
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Sign In'),
    ),
    backgroundColor: const Color.fromARGB(255, 70, 233, 225),
    body: Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                "WIN THE ONE",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 2),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: signIn, // Ensure `signIn` is properly defined elsewhere
                child: const Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}