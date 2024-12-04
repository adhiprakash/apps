import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<QueryDocumentSnapshot> _questions = [];

  void _submitAnswer(int selectedOption, int correctAnswer) {
    if (selectedOption == correctAnswer) {
      _score++;
    }
    setState(() {
      _currentQuestionIndex++;
    });

   

    if (_currentQuestionIndex < (_questions[0].data() as Map)["questions"].length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _showScore(
        _score
      );
    }
  }

  void _showScore(int totalScore) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Quiz Completed'),
      content: Text('Your Score: $_score out of $_currentQuestionIndex'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}



  Future<void> _loadQuestions() async {
    final snapshot = await FirebaseFirestore.instance.collection('questionPapers').get();
    setState(() {
      _questions = snapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    // print((_questions[0].data() as Map)["questions"].length);
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: (_questions[0].data() as Map)["questions"].isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (_questions[0].data() as Map)["questions"].length,
              itemBuilder: (context, index) {
                final question = (_questions[0].data() as Map)["questions"][index];
                final options = List<String>.from(question['options']);
                final correctAnswer = question['correctAnswer'];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${index + 1}: ${question['question']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(
                        options.length,
                        (i) => ListTile(
                          title: Text(options[i]),
                          leading: Radio<int>(
                            value: i,
                            groupValue: null,
                            onChanged: (value) => _submitAnswer(value!, correctAnswer),
                          ),
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
