import 'dart:async';
import 'package:flutter/material.dart';
import 'ResultPersonnagePage.dart';

class PersonnagePage extends StatefulWidget {
  const PersonnagePage({super.key});

  @override
  State<PersonnagePage> createState() => _PersonnagePageState();
}

class _PersonnagePageState extends State<PersonnagePage> {
  final int _quizDuration = 60; // Total time for the quiz (seconds)
  int _timeLeft = 60; // Timer countdown
  Timer? _timer;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  List<int> userAnswers = []; // Tracks the user's selected answers// Tracks the user's selected answers

  // Sample questions with portraits
  final List<Map<String, dynamic>> _questions = [
    {
      'portrait1': 'images/person_1.jpg',
      'portrait2': 'images/person_2.jpg', // Path to the second portrait image
      'question':
      'نفته السلطات الفرنسية عام 1940 إلى منطقة\nأفلو بالجنوب الغربي للجزائر،\nوبعد أسبوع من نفيه مات الشيخ بن باديس. \nانتخابه رئيسا لجمعية العلماء المسلمين\nوتولى رئاستها عن بعد لمدة ثلاث\nسنوات، إلى حين إطلاق سراحه عام 1943.',
      'answers': ['العربي التبسي', 'مبارك الميلي'],
      'correct': 0, // Index of the correct answer
    },
    {
      'portrait1': 'images/person_3.jpg',
      'portrait2': 'images/person_2.jpg',
      'question':
      'شارك في تأسيس جمعية العلماء المسلمين\nوكان كاتبًا بارعًا ومؤلفًا بارزًا في النهضة الجزائرية.',
      'answers': ['عبد الحميد بن باديس', 'مبارك الميلي'],
      'correct': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endQuiz();
        }
      });
    });
  }

  void _selectAnswer(int index) {
    setState(() {
      userAnswers.add(index); // Store the user's selected answer

      // Check if the answer is correct
      if (index == _questions[_currentQuestionIndex]['correct']) {
        _correctAnswers++;
      }

      Future.delayed(const Duration(seconds: 1), () {
        _moveToNextQuestion();
      });
    });
  }

  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _endQuiz();
    }
  }

  void _endQuiz() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPersonnagePage(
          score: _correctAnswers * 10, // Calculate score
          correctAnswers: _correctAnswers,
          incorrectAnswers: _questions.length - _correctAnswers,
          timeSpent: _quizDuration - _timeLeft,
          totalQuestions: _questions.length,
          questions: _questions,
          userAnswers: userAnswers,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("من أنا ؟"),
        centerTitle: true,
        backgroundColor: const Color(0xFF715C25),
      ),
      body: Container(
        color: const Color(0xFFFCDFA6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer display
              Text(
                'الوقت المتبقي: $_timeLeft ثانية',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Question text
              Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Portraits and answers side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              question['answers'].length,
                  (index) => Column(
                children: [
                  // Portrait image for each answer
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    child: Image.asset(
                      index == 0 ? question['portrait1'] : question['portrait2'],
                      height: 80, // Smaller height
                      width: 80, // Smaller width
                      fit: BoxFit.cover, // Ensures the image fits within the frame
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Answer button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: userAnswers.length > _currentQuestionIndex &&
                          userAnswers[_currentQuestionIndex] == index
                          ? (index == question['correct'] ? Colors.green : Colors.red)
                          : const Color(0xFFFFFFFF),
                    ),
                    onPressed: userAnswers.length > _currentQuestionIndex
                        ? null // Disable button after selection
                        : () => _selectAnswer(index),
                    child: Text(question['answers'][index]),
                  ),
                ],
              ),
            ),
          ),

            ],
          ),
        ),
      ),
    );
  }
}
