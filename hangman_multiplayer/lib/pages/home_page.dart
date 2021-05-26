import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hangman_multiplayer/components/action_button.dart';
import 'package:hangman_multiplayer/components/constants.dart';
import 'package:hangman_multiplayer/components/helperfunctions.dart';
import 'package:hangman_multiplayer/pages/categorie_page.dart';
import 'package:hangman_multiplayer/pages/highscore_page.dart';
import 'package:hangman_multiplayer/pages/multiplayer_page.dart';
import 'package:hangman_multiplayer/pages/profile_page.dart';
import 'package:hangman_multiplayer/utilities/hangman_words.dart';

class HomePage extends StatefulWidget {
  final HangmanWords hangmanWords = HangmanWords();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName;

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  getUserName() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  // ignore: unused_element
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Center(
                child: Container(
                  child: Text(
                    'HANGMAN',
                    style: TextStyle(
                      color: Color(0xFF1089ff),
                      fontSize: 58.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 65.0,
              ),
              Center(
                child: IntrinsicWidth(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                      ActionButton(
                        buttonTitle: 'Start',
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen()
                                  //GameScreen(hangmanObject: widget.hangmanWords)
                                  ));
                        },
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      ActionButton(
                        buttonTitle: "Multiplayer",
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiPlayerPage()));
                        },
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      ActionButton(
                        buttonTitle: 'High Scores',
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HighScore(),
                              ));
                        },
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      ActionButton(
                        buttonTitle: "Profile",
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ));
                        },
                      ),
                      /*SizedBox(height: 20),
                      ActionButton(
                        buttonTitle: "Test",
                        onPress: () {
                          HelperFunctions.saveUserLoggedInSharedPreference(false);
                          AuthService().signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Authenticate()));
                        },
                      ),*/
                      /*SizedBox(
                        height: 18.0,
                      ),
                      ActionButton(
                        buttonTitle: "Shop",
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Store(),
                              ));
                        },
                      ),*/
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
