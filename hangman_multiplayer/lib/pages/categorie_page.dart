import 'package:flutter/material.dart';
import 'package:hangman_multiplayer/pages/game_screen.dart';
import 'package:hangman_multiplayer/pages/home_page.dart';
import 'package:hangman_multiplayer/utilities/hangman_words.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CategoryScreen extends StatefulWidget {
  final HangmanWords hangmanWords = HangmanWords();

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/background/game_background_3. 2_high.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20
                  /*MediaQuery.of(context).size.height / 13*/,
                ),
                Row(children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFF1089ff)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                      }),
                  SizedBox(width: MediaQuery.of(context).size.width / 9),
                  Text(
                    "Kategorie",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 58.0,
                      letterSpacing: 3.0,
                      color: Color(0xFF1089ff),
                    ),
                  ),
                ]),
                SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    print("Tapped Zufall");
                    widget.hangmanWords.readWords(1);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameScreen(
                                  hangmanObject: widget.hangmanWords,
                                  category: "Zufall",
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 40.0,
                      percent: 1.0,
                      center: Text("Zufall",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Tapped Tiere");
                    widget.hangmanWords.readWords(2);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameScreen(
                                  hangmanObject: widget.hangmanWords,
                                  category: "Tiere",
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 40.0,
                      percent: 1.0,
                      center: Text("Tiere",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Tapped Marken");
                    widget.hangmanWords.readWords(3);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameScreen(
                                  hangmanObject: widget.hangmanWords,
                                  category: "Marken",
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 40.0,
                      percent: 1.0,
                      center: Text("Marken",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Tapped Sportarten");
                    widget.hangmanWords.readWords(5);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameScreen(
                                  hangmanObject: widget.hangmanWords,
                                  category: "Sport",
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 40.0,
                      percent: 1.0,
                      center: Text("Sportarten",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Tapped Städte/Länder");
                    widget.hangmanWords.readWords(4);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameScreen(
                                  hangmanObject: widget.hangmanWords,
                                  category: "Land",
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 40.0,
                      percent: 1.0,
                      center: Text("Städte/Länder",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.blue,
                    ),
                  ),
                ),
                /*GestureDetector(
                  onTap: () {
                    print("Tapped auf Zeit");
                    widget.hangmanWords.readWords(1);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameScreen(
                                  hangmanObject: widget.hangmanWords,
                                  category: "Zeit",
                                  aufZeit: true,
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 40.0,
                      percent: 1.0,
                      center: Text("Auf Zeit",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.blue,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
