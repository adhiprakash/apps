import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuestionPaperScreen extends StatefulWidget {
  const AddQuestionPaperScreen({super.key});

  @override
  _AddQuestionPaperScreenState createState() => _AddQuestionPaperScreenState();
}

class _AddQuestionPaperScreenState extends State<AddQuestionPaperScreen> {
  final TextEditingController _questionPaperController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionsControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int _correctAnswerIndex = 0;
  int? _editingIndex;

  Future<void> _addOrUpdateQuestion() async {
    if (_questionController.text.isEmpty ||
        _optionsControllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields for the question')),
      );
      return;
    }

    final question = _questionController.text.trim();
    final options = _optionsControllers.map((controller) => controller.text.trim()).toList();

    setState(() {
      if (_editingIndex != null) {
        _questions[_editingIndex!] = {
          'question': question,
          'options': options,
          'correctAnswer': _correctAnswerIndex,
        };
        _editingIndex = null;
      } else {
        if (_questions.length >= 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only add up to 10 questions')),
          );
          return;
        }
        _questions.add({
          'question': question,
          'options': options,
          'correctAnswer': _correctAnswerIndex,
        });
      }
      _clearInputs();
    });
  }

  Future<void> _saveQuestionPaper() async {
    if (_questionPaperController.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a question paper name and at least one question')),
      );
      return;
    }

    final questionPaperName = _questionPaperController.text.trim();

    try {
      await FirebaseFirestore.instance.collection('questionPapers').doc(questionPaperName).set({
        'name': questionPaperName,
        'questions': _questions,
      });

      _showSuccessDialog('Question paper saved successfully');

      setState(() {
        _clearAll();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving question paper: $e')),
      );
    }
  }

  void _editQuestion(int index) {
    final question = _questions[index];
    setState(() {
      _editingIndex = index;
      _questionController.text = question['question'];
      for (int i = 0; i < _optionsControllers.length; i++) {
        _optionsControllers[i].text = question['options'][i];
      }
      _correctAnswerIndex = question['correctAnswer'];
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _clearInputs() {
    _questionController.clear();
    for (var controller in _optionsControllers) {
      controller.clear();
    }
    _correctAnswerIndex = 0;
    _editingIndex = null;
  }

  void _clearAll() {
    _questionPaperController.clear();
    _questions.clear();
    _clearInputs();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Question Papers')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _questionPaperController,
                decoration: const InputDecoration(labelText: 'Question Paper Name'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return TextField(
                    controller: _optionsControllers[index],
                    decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                  );
                },
              ),
              const SizedBox(height: 20),
              DropdownButton<int>(
                value: _correctAnswerIndex,
                items: List.generate(4, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text('Correct Answer: Option ${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _correctAnswerIndex = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdateQuestion,
                child: Text(_editingIndex == null ? 'Add Question to Paper' : 'Update Question'),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final question = _questions[index];
                  return ListTile(
                    title: Text('${index + 1}. ${question['question']}'),
                    subtitle: Text('Correct Answer: Option ${question['correctAnswer'] + 1}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editQuestion(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteQuestion(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuestionPaper,
                child: const Text('Save Question Paper'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _clearAll();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ready to create a new question paper')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Add New Question Paper'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

