import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/add_question_screen.dart';
import 'package:quiz_app/question_paper_deatils_screen.dart';


class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final CollectionReference _questionPapersCollection =
      FirebaseFirestore.instance.collection('questionPapers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _questionPapersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No question papers available'));
          }

          final questionPapers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: questionPapers.length,
            itemBuilder: (context, index) {
              final questionPaper = questionPapers[index];
              final data = questionPaper.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Untitled';
              final questions = data['questions'] as List<dynamic>?;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text('${questions?.length ?? 0} questions'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPaperDetailsScreen(
                          questionPaperId: questionPaper.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // Add Floating Action Button to create new question papers
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddQuestionPaperScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddQuestionPaperScreen(),
            ),
          );
        },
        tooltip: 'Add Question Paper',
        child: const Icon(Icons.add),
      ),
    );
  }
}

