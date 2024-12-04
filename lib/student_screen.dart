import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  bool _isRegistered = false;

  Future<void> _registerStudent() async {
    if (_nameController.text.isEmpty || _regNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both name and registration number')),
      );
      return;
    }

    try {
      // Save the student details to Firestore
      await FirebaseFirestore.instance.collection('students').add({
        'name': _nameController.text,
        'registrationNumber': _regNoController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Once registered, set _isRegistered to true
      setState(() {
        _isRegistered = true;
      });

      // Proceed to the quiz screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering student: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRegistered) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _regNoController,
                decoration: const InputDecoration(
                  labelText: 'Enter Registration Number',
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: _registerStudent,
                child: const Text('Register '),
              ),
            ] else ...[
              const Text('Exam is completed.'),
            ],
          ],
        ),
      ),
    );          
  }
}
