import 'package:flutter/material.dart';
import 'main.dart';

class ResultPersonnagePage extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int incorrectAnswers;
  final int timeSpent;
  final int totalQuestions;
  final List<Map<String, dynamic>> questions;
  final List<int> userAnswers;

  const ResultPersonnagePage({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.timeSpent,
    required this.totalQuestions,
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
                    MaterialPageRoute(builder: (context) => const MyApp()),
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
        title: const Text('المراجعة'),
        backgroundColor: const Color(0xFF715C25),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final userAnswer = userAnswers[index];
          final correctAnswer = question['correct'];

          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portrait
                if (question['portrait'] != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      question['portrait'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                // Question
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    question['question'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
                // Answers
                Column(
                  children: List.generate(question['answers'].length, (i) {
                    Color textColor;

                    if (i == correctAnswer) {
                      textColor = Colors.green; // Correct answer
                    } else if (i == userAnswer) {
                      textColor = Colors.red; // Incorrect user-selected answer
                    } else {
                      textColor = Colors.black; // Unselected answers
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        question['answers'][i],
                        style: TextStyle(
                          color: textColor,
                          fontWeight:
                          i == correctAnswer ? FontWeight.bold : null,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
