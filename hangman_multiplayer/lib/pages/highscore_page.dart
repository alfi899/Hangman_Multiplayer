import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangman_multiplayer/components/constants.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:hangman_multiplayer/components/helperfunctions.dart';
import 'package:hangman_multiplayer/pages/home_page.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HighScore extends StatefulWidget {
  @override
  _HighScoreState createState() => _HighScoreState();
}

class _HighScoreState extends State<HighScore> {
  String test;
  static int scoreTest = 0;
  static int markenScore = 0;
  static int landScore = 0;
  static int sportScore = 0;
  static int tierScore = 0;
  static int zeitScore = 0;

  @override
  void initState() {
    getUserName();
    getHighscore(Constants.myName);
    print("Constant name -- ${Constants.myName}");
    super.initState();
  }

  getUserName() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DocumentSnapshot _snapshot;

  getHighscore(String name) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        DatabaseMethods().getCurrentScore(f.reference.id).then((snapshot) {
          _snapshot = snapshot;
          print("---------------------$scoreTest");
          setState(() {
            scoreTest = _snapshot.data()["zufallScore"];
            landScore = _snapshot.data()["landScore"];
            markenScore = _snapshot.data()["markenScore"];
            tierScore = _snapshot.data()["tiereScore"];
            sportScore = _snapshot.data()["sportScore"];
            zeitScore = _snapshot.data()["zeitScore"];
          });
        });
      });
    });
  }

  final zufallCard = Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(64, 75, 96, .9),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: Text("🥇", style: TextStyle(fontSize: 25)),
        ),
        title: Text(
          "$scoreTest",
          style: GoogleFonts.roboto(
            textStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Text(
          "Zufall",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    ),
  );

  final markenCard = Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(64, 75, 96, .9),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: Text("🥇", style: TextStyle(fontSize: 25)),
        ),
        title: Text(
          "$markenScore",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        trailing: Text(
          "Marken",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    ),
  );

  final tiereCard = Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(64, 75, 96, .9),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: Text("🥇", style: TextStyle(fontSize: 25)),
        ),
        title: Text(
          "$tierScore",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        trailing: Text(
          "Tiere",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    ),
  );

  final sportCard = Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(64, 75, 96, .9),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: Text("🥇", style: TextStyle(fontSize: 25)),
        ),
        title: Text(
          "$sportScore",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        trailing: Text(
          "Sport",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    ),
  );

  final landCard = Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(64, 75, 96, .9),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: Text("🥇", style: TextStyle(fontSize: 25)),
        ),
        title: Text(
          "$landScore",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        trailing: Text(
          "Länder/Städte",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    ),
  );


  final zeitCard = Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(64, 75, 96, .9),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.white24)),
          ),
          child: Text("🥇", style: TextStyle(fontSize: 25)),
        ),
        title: Text(
          "$zeitScore",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        trailing: Text(
          "Zeit",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    ),
  );



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
        child: LiquidPullToRefresh(
          animSpeedFactor: 5.0,
          onRefresh: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HighScore()));

            return await Future.delayed(Duration(seconds: 2));
          },
          child: SafeArea(
            child: ListView(children: [
              SizedBox(
                height: 20
                /*MediaQuery.of(context).size.height / 13*/,
              ),
              Row(children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Color(0xFF1089ff)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }),
                SizedBox(width: MediaQuery.of(context).size.width / 9),
                Center(
                  child: Container(
                    child: Text(
                      'HIGHSCORE',
                      style: TextStyle(
                        color: Color(0xFF1089ff),
                        fontSize: 58.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(height: 30),
                  Container(child: zufallCard),
                  Container(child: tiereCard),
                  Container(child: markenCard),
                  Container(child: sportCard),
                  Container(child: landCard),
                  //Container(child: zeitCard),
                  Container(
                    child: Center(
                      child: Text(
                        "Ziehe um die Tabelle zu aktualisieren",
                        style: TextStyle(color: Colors.white, letterSpacing: 0.5))
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
