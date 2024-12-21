import 'package:flutter/material.dart';
import 'result_page.dart';

class OrderGamePage extends StatefulWidget {
  const OrderGamePage({super.key});

  @override
  State<OrderGamePage> createState() => _OrderGamePageState();
}

class _OrderGamePageState extends State<OrderGamePage> {
  final List<Map<String, String>> events = [
    {"date": "1830", "title": "احتلال الجزائر (5 يوليو)"},
    {"date": "1832", "title": "انتفاضة الأمير عبد القادر "},
    {"date": "1845", "title": "مجزرة قبائل أولاد رياح"},
    {"date": "1881", "title": "ثورة الشيخ بوعمامة"},
    {"date": "1945", "title": "مظاهرات 8 ماي"},
  ];

  late List<Map<String, String>> shuffledEvents;
  late List<Map<String, String>> correctOrder;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    correctOrder = List.from(events)..sort((a, b) => a['date']!.compareTo(b['date']!));
    shuffledEvents = List.from(events)..shuffle();
    stopwatch = Stopwatch()..start();
  }

  void onDonePressed() {
    stopwatch.stop();

    bool isCorrect = shuffledEvents.asMap().entries.every((entry) {
      return entry.value['date'] == correctOrder[entry.key]['date'];
    });

    // Convert user-selected order to List<int> for passing to ResultPage
    List<int> userAnswers = shuffledEvents.map((event) => int.parse(event['date']!)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          score: isCorrect ? 1 : 0,
          totalQuestions: 1,
          correctAnswers: isCorrect ? 1 : 0,
          incorrectAnswers: isCorrect ? 0 : 1,
          timeSpent: stopwatch.elapsed.inSeconds,
          questions: correctOrder.map((event) {
            return {
              'question': event['title']!,
              'answers': [event['date']!],
              'correct': event['date']!,
            };
          }).toList(),
          userAnswers: userAnswers, // Correctly passed as List<int>
        ),
      ),
    );
  }

  void moveUp(int index) {
    if (index > 0) {
      setState(() {
        final item = shuffledEvents.removeAt(index);
        shuffledEvents.insert(index - 1, item);
      });
    }
  }

  void moveDown(int index) {
    if (index < shuffledEvents.length - 1) {
      setState(() {
        final item = shuffledEvents.removeAt(index);
        shuffledEvents.insert(index + 1, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ترتيب الأحداث',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'قم بترتيب الأحداث حسب التسلسل الزمني من الأقدم إلى الأحدث.',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shuffledEvents.length,
              itemBuilder: (context, index) {
                return Card(
                  key: ValueKey(shuffledEvents[index]['title']),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      shuffledEvents[index]['title']!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () => moveUp(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: () => moveDown(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onDonePressed,
              child: const Text('تم'),
            ),
          ),
        ],
      ),
    );
  }
}

