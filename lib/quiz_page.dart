import 'dart:async';
import 'package:flutter/material.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 50;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  Timer? _timer;


  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'من هو مؤسس الحكم العثماني في الجزائر؟',
      'answers': ['خير الدين بربروس', 'السلطان سليم الأول', 'حسين باشا', 'عروج بربروس'],
      'correct': 2,
    },
    {
      'question': 'متى بدأت السيطرة العثمانية على الجزائر؟',
      'answers': ['1492', '1600', '1516', '1541'],
      'correct': 2,
    },
    {
      'question': 'من كان آخر دايات الجزائر؟ ',
      'answers': ['حسن باشا', 'السلطان سليم الأول', 'حسين باشا', 'أحمد باي'],
      'correct': 2,
    },
    {
      'question': 'أين اندلعت ثورة الدرقاوية؟ ',
      'answers': ['منطقة الأوراس', 'بايليك الغرب', 'تلمسان', 'مدينة الجزائر'],
      'correct': 1,
    },
    {
      'question': 'متى كانت حادثة المروحة؟ ',
      'answers': ['29 أبريل 1827', ' 28 سبتمبر 1538', ' 14 يونيو 1830', '1832'],
      'correct': 0,
    },
    {
      'question': 'متى وقعت معهادة استسلام حسين باشا مع العدو الفرنسي ؟ ',
      'answers': ['29 أبريل 1827', '  5 يوليو 1830', ' 14 يونيو 1830', '1832'],
      'correct': 1,
    },
    {
      'question': 'في اي سنة كانت معركة ناڤرين ؟ ',
      'answers': ['1827', '1830', '1831', '1516'],
      'correct': 3,
    },
    {
      'question': 'في اي مدة زمنية وقعت ثورة الكراغلة ؟ ',
      'answers': ['1632', '1517', '1633', '1519'],
      'correct': 2,
    },
  ];

  int? _selectedAnswer;

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
  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      _endQuiz();
    }
  }

  List<int> userAnswers = [];

  void _answerQuestion(int index) {
    setState(() {
      _selectedAnswer = index;
      userAnswers.add(index);

      if (index == _questions[_currentQuestionIndex]['correct']) {
        _score += 5;
        _correctAnswers++;
      } else {
        _incorrectAnswers++;
      }

      Future.delayed(const Duration(seconds: 1), () {
        _moveToNextQuestion();
      });
    });
  }

  void _endQuiz() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          score: _score,
          totalQuestions: _questions.length,
          correctAnswers: _correctAnswers,
          incorrectAnswers: _incorrectAnswers,
          timeSpent: 50 - _timeLeft,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'تحدي الوقت',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'الوقت المتبقي: $_timeLeft ثانية',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'السؤال ${_currentQuestionIndex + 1}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                question['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(question['answers'].length, (index) {
              return GestureDetector(
                onTap: () => _answerQuestion(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedAnswer == index
                        ? (index == question['correct'] ? Colors.green : Colors.red)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: Text(
                      question['answers'][index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}