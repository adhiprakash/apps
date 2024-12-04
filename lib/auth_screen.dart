import 'package:flutter/material.dart';
import 'merged_signin.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/plain.jpeg",fit: BoxFit.fill,),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

Spacer(flex: 1,),
                Text("WIN THE ONE ",style: TextStyle(fontSize: 50,color: const Color.fromARGB(255, 7, 240, 220),fontWeight: FontWeight.bold),),
                Spacer(flex: 1,),

                 ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MergedSignInScreen(isAdmin: true),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 250, 9), // Change color to red
              ),
              child: const Text('Login as Authenticator'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MergedSignInScreen(isAdmin: false),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 9, 245, 29), // Change color to blue
              ),
              child: const Text('Login as Student'),
            ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

