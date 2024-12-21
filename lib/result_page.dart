import 'package:flutter/material.dart';
import 'package:notre_serious_game/quiz_page.dart';
import 'main.dart';
import 'revision_page.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int timeSpent;
  final List<Map<String, dynamic>> questions;
  final List<int> userAnswers;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.timeSpent,
    required this.questions,
    required this.userAnswers,
  });

  int calculateStars() {
    if (correctAnswers == totalQuestions) {
      return 3;
    } else if (correctAnswers >= totalQuestions * 0.6) {
      return 2;
    } else if (correctAnswers >= totalQuestions * 0.3) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    int stars = calculateStars();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'النتيجة النهائية',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('مجموع النقاط: $score', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('الإجابات الصحيحة: $correctAnswers'),
              Text('الإجابات الخاطئة: $incorrectAnswers'),
              Text('الوقت المستغرق: $timeSpent ثانية'),
              const SizedBox(height: 20),
              // Display stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) => Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RevisionPage(
                        questions: questions,
                        userAnswers: userAnswers,
                      ),
                    ),
                  );
                },
                child: const Text('المراجعة'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false,
                  );
                },
                child: const Text('العودة إلى الصفحة الرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
