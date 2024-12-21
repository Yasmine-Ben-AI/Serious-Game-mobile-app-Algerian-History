import 'package:flutter/material.dart';

void main() => runApp(PasswordGame());

class PasswordGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PasswordScreen(),
    );
  }
}

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final String correctPassword = "الامير عبد القادر";
  String inputPassword = "";

  void onKeyPress(String letter) {
    setState(() {
      if (letter == "←" && inputPassword.isNotEmpty) {
        inputPassword = inputPassword.substring(0, inputPassword.length - 1);
      } else if (letter != "←") {
        inputPassword += letter;
      }
    });
  }

  void checkPassword() {
    if (inputPassword == correctPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mot de passe incorrect")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EEDC),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EEDC),
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("DZ", style: TextStyle(color: Colors.black, fontSize: 18)),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Image
          Image.asset(
            'images/mystery_character.gif',
            height: 150,
          ),

          // Texte principal
          Text(
            "هل تعرفت علي؟",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          // Zone de texte
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: inputPassword,
                hintStyle: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),

          // Clavier
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...['ا', 'ل', 'م', 'ي', 'ر', 'ع', 'ب', 'د', 'ا', 'ل', 'ق', 'ا', 'د', 'ر', ' '].map(
                    (letter) => KeyButton(letter: letter, onPress: onKeyPress),
              ),
              KeyButton(letter: '←', onPress: onKeyPress),
            ],
          ),

          // Bouton confirmer
          ElevatedButton(
            onPressed: checkPassword,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text("تأكد", style: TextStyle(fontSize: 22, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class KeyButton extends StatelessWidget {
  final String letter;
  final Function(String) onPress;

  const KeyButton({required this.letter, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPress(letter),
    child: Container(
    alignment: Alignment.center,
    width: 50,
    height: 50,
    decoration: BoxDecoration(
    color: Colors.brown.shade200,
    borderRadius:BorderRadius.circular(8),
    ),
      child: Text(
        letter,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4C4C4C),
      appBar: AppBar(
        backgroundColor: Color(0xFF4C4C4C),
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image du succès
            Image.asset('images/frame_amir_abd_elkader.png', height: 300),
            SizedBox(height: 20),
            Text(
              "الأمير عبد القادر",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}