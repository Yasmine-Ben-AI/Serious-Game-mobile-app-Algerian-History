import 'package:flutter/material.dart';
import 'package:notre_serious_game/quiz_page.dart';
import 'main.dart';

class RevisionPage extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final List<int> userAnswers;

  const RevisionPage({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المراجعة',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final userAnswer = userAnswers[index];
          final correctAnswer = question['correct'];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(question['question']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(question['answers'].length, (i) {
                  return Text(
                    question['answers'][i],
                    style: TextStyle(
                      color: i == correctAnswer
                          ? Colors.green
                          : (i == userAnswer ? Colors.red : Colors.black),
                      fontWeight: i == correctAnswer ? FontWeight.bold : null,
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
          );
        },
        label: const Text('العودة إلى الصفحة الرئيسية'),
        icon: const Icon(Icons.home),
      ),
    );
  }
}
