import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionPaperDetailsScreen extends StatelessWidget {
  final String questionPaperId;

  const QuestionPaperDetailsScreen({super.key, required this.questionPaperId});

  @override
  Widget build(BuildContext context) {
    final DocumentReference questionPaperDoc =
        FirebaseFirestore.instance.collection('questionPapers').doc(questionPaperId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Paper Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: questionPaperDoc.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Question paper not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['name'] ?? 'Untitled';
          final questions = data['questions'] as List<dynamic>?;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question Paper: $name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                if (questions == null || questions.isEmpty)
                  const Text('No questions available'),
                if (questions != null && questions.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final options = question['options'] as List<dynamic>;
                        final correctAnswer = question['correctAnswer'] as int;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Q${index + 1}: ${question['question']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                ...options.asMap().entries.map((entry) {
                                  final optionIndex = entry.key;
                                  final optionText = entry.value;
                                  return Text(
                                    '${optionIndex + 1}. $optionText',
                                    style: TextStyle(
                                      color: correctAnswer == optionIndex
                                          ? Colors.green
                                          : null,
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
