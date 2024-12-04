import 'package:flutter/material.dart';

class ExamCompletedScreen extends StatelessWidget {
  final int totalScore;
  final List<Map<String, dynamic>> userAnswers;

  const ExamCompletedScreen({
    super.key,
    required this.totalScore,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Completed')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Score: $totalScore/${userAnswers.length}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userAnswers.length,
                itemBuilder: (context, index) {
                  final answer = userAnswers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q: ${answer['question']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your Answer: ${answer['selectedAnswer']}',
                            style: TextStyle(
                              color: answer['isCorrect']
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          Text('Correct Answer: ${answer['correctAnswer']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
