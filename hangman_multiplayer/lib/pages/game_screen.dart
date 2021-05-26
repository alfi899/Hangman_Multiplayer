import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hangman_multiplayer/ads/ad_helper.dart';
import 'package:hangman_multiplayer/components/constants.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:hangman_multiplayer/components/helperfunctions.dart';
import 'package:hangman_multiplayer/components/word_button.dart';
import 'package:hangman_multiplayer/pages/categorie_page.dart';
import 'package:hangman_multiplayer/pages/chat.dart';
import 'package:hangman_multiplayer/pages/home_page.dart';
import 'package:hangman_multiplayer/utilities/alphabet.dart';
import 'package:hangman_multiplayer/utilities/constants.dart';
import 'package:hangman_multiplayer/utilities/hangman_words.dart';
import 'dart:async';

import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class GameScreen extends StatefulWidget {
  GameScreen(
      {this.hangmanObject,
      this.wordFromMultiPLayer,
      this.chatRoomID,
      this.gegnerName,
      this.otherScore,
      this.yourScore,
      this.category
      });

  final String category;
  final HangmanWords hangmanObject;
  final String wordFromMultiPLayer;
  final String chatRoomID;
  final String gegnerName;
  //bool aufZeit;

  int yourScore;
  int otherScore;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int lives = 5;
  Alphabet germanalphabet = Alphabet();
  String word;
  String hiddenWord;
  List<String> wordList = [];
  List<int> hintLetters = [];
  List<bool> buttonStatus;
  bool hintStatus;
  int hangState = 0;
  int wordCount = 0;
  bool finishedGame = false;
  bool resetGame = false;
  Stream test;
  User user;
  QuerySnapshot querySnapshot;

  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  void newGame() {
    setState(() {
      widget.hangmanObject.resetWords();
      germanalphabet = Alphabet();
      lives = 5;
      wordCount = 0;
      finishedGame = false;
      resetGame = false;
      initWords();
    });
  }

  
  void createInterstitialAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: AdHelper.intersitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print("${ad.runtimeType} loaded");
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print("${ad.runtimeType} failed to load: $error.");
          ad.dispose();
          _interstitialAd = null;
          createInterstitialAd();
        },
        onAdOpened: (Ad ad) => print("${ad.runtimeType} onAdOpend"),
        onAdClosed: (Ad ad) {
          print("${ad.runtimeType} closed");
          ad.dispose();
          createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print("${ad.runtimeType} onApplicationExit"),
      ),
    )..load();
  }

  getUserName() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  Widget createButton(index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
      child: Center(
        child: WordButton(
          buttonTitle: germanalphabet.alphabet[index].toUpperCase(),
          onPress: buttonStatus[index] ? () => wordPress(index) : null,
        ),
      ),
    );
  }

  void returnHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void initWords() {
    finishedGame = false;
    resetGame = false;
    hintStatus = true;
    hangState = 0;
    buttonStatus = List.generate(26, (index) {
      return true;
    });
    wordList = [];
    hintLetters = [];
    word = widget.wordFromMultiPLayer != null
        ? widget.wordFromMultiPLayer
        : widget.hangmanObject.getWord();

    //print
    print('this is word $word');

    if (word.length != 0) {
      if (widget.wordFromMultiPLayer != null) {
        String hW = '';
        for (int i = 0; i < word.length; i++) {
          hW += '_';
        }
        hiddenWord = hW;
      } else {
        hiddenWord = widget.hangmanObject.getHiddenWord(word.length);
      }
    } else {
      returnHomePage();
    }

    print(
        "---------------------------------${word.length} wordlength---------------");
    for (int i = 0; i < word.length; i++) {
      wordList.add(word[i]);
      hintLetters.add(i);
    }
  }

  void wordPress(int index) {
    if (lives == 0) {
      returnHomePage();
    }

    if (finishedGame) {
      setState(() {
        resetGame = true;
      });
      return;
    }

    bool check = false;
    setState(() {
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i] == germanalphabet.alphabet[index]) {
          check = true;
          wordList[i] = '';
          hiddenWord = hiddenWord.replaceFirst(RegExp('_'), word[i], i);
        }
      }
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i] == '') {
          hintLetters.remove(i);
        }
      }
      if (!check) {
        hangState += 1;
      }

      if (hangState == 6) {
        finishedGame = true;
        lives -= 1;
        if (lives < 1) {
          if (wordCount > 0) {
            // Save score in special category
            DatabaseMethods()
                .test(Constants.myName, wordCount, widget.category);
          }
          //Alert....
          Alert(
              style: kGameOverAlertStyle,
              context: context,
              title: "Game Over!",
              desc: "Your score is $wordCount",
              buttons: [
                DialogButton(
                  onPressed: () {
                    // Show an Add
                    if (_isInterstitialAdReady) {
                      _interstitialAd.show();
                      _isInterstitialAdReady = false;
                      _interstitialAd = null;
                    }
                    returnHomePage();
                  },
                  child: Icon(
                    Icons.home,
                    size: 30,
                    color: Colors.white,
                  ),
                  color: kDialogButtonColor,
                ),
                DialogButton(
                  onPressed: () {
                    newGame();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.refresh, size: 30, color: Colors.white),
                  color: kDialogButtonColor,
                ),
              ]).show();
        } else {
          Alert(
            context: context,
            style: kFailedAlertStyle,
            type: AlertType.error,
            title: word,
            buttons: [
              DialogButton(
                radius: BorderRadius.circular(10),
                child: Icon(
                  Icons.arrow_forward,
                  size: 30.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    initWords();

                    // Move to the multiplayer screen if multiplayer was player
                    if (widget.wordFromMultiPLayer != null) {
                      DatabaseMethods().updateGameState(
                          widget.chatRoomID, "beendet_verloren");

                      // Show an Add
                      if (_isInterstitialAdReady) {
                        _interstitialAd.show();
                        _isInterstitialAdReady = false;
                        _interstitialAd = null;
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                  chatRoomId: widget.chatRoomID,
                                  gameBeendet: true,
                                  loose: true,
                                  win: false,
                                  gegnerName: widget.gegnerName)));
                    }
                  });
                },
                width: 127,
                color: kDialogButtonColor,
                height: 52,
              ),
            ],
          ).show();
        }
      }

      buttonStatus[index] = false;
      if (hiddenWord == word) {
        finishedGame = true;
        Alert(
          context: context,
          style: kSuccesAlertStyle,
          type: AlertType.success,
          title: word,
          buttons: [
            DialogButton(
              radius: BorderRadius.circular(10),
              child: Icon(
                Icons.arrow_forward,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  // show add after every 2 game
                  /*if (wordCount == 10) {
                    // Show an Add
                    if (_intersitialReady) {
                      _interstitialAd.show();
                      _intersitialReady = false;
                      _interstitialAd = null;
                    }
                  }*/

                  wordCount += 1;
                  Navigator.pop(context);
                  initWords();

                  // Move to the multiplayer screen if multiplayer was player
                  if (widget.wordFromMultiPLayer != null) {
                    if (widget.chatRoomID.startsWith(widget.gegnerName, 0) ==
                        true) {
                      DatabaseMethods().updateScore(widget.chatRoomID,
                          widget.yourScore, widget.otherScore + 1);
                    } else {
                      DatabaseMethods().updateScore(widget.chatRoomID,
                          widget.yourScore + 1, widget.otherScore);
                    }
                    DatabaseMethods()
                        .updateGameState(widget.chatRoomID, "beendet_gewonnen");

                    // Show an Add
                    if (_isInterstitialAdReady) {
                      _interstitialAd.show();
                      _isInterstitialAdReady = false;
                      _interstitialAd = null;
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chat(
                                  chatRoomId: widget.chatRoomID,
                                  gameBeendet: true,
                                  loose: false,
                                  win: true,
                                  gegnerName: widget.gegnerName,
                                )));
                  }
                });
              },
              width: 127,
              color: kDialogButtonColor,
              height: 52,
            )
          ],
        ).show();
      }
    });
  }


  @override 
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    // ads init
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print("Initialization done: ${status.adapterStatuses}");
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
              tagForChildDirectedTreatment:
                  TagForChildDirectedTreatment.unspecified))
          .then((value) {
        createInterstitialAd();
      });
    });
    initWords();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    if (resetGame) {
      setState(() {
        initWords();
      });
    }
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
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
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_back,
                                    size: 30, color: Colors.blue),
                                onPressed: () {
                                  // Show an Add
                                  if (_isInterstitialAdReady) {
                                    _interstitialAd.show();
                                    _isInterstitialAdReady = false;
                                    _interstitialAd = null;
                                  }
                                  DatabaseMethods()
                                    .test(Constants.myName, wordCount, widget.category);
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CategoryScreen()),
                                  );
                                }),
                            Container(
                              child: Text(
                                wordCount == 1 ? "I" : '$wordCount',
                                style: kWordCounterTextStyle,
                              ),
                            ),
                            Container(
                              child: Row(children: [
                                Row(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 0.5),
                                          child: IconButton(
                                            tooltip: 'Lives',
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            iconSize: 39,
                                            icon: Icon(Icons.favorite),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              8.7, 7.9, 0, 0.8),
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 38,
                                            width: 38,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  lives.toString() == "1"
                                                      ? "I"
                                                      : lives.toString(),
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  tooltip: 'Hint',
                                  iconSize: 39,
                                  icon: Icon(Icons.lightbulb_outline,
                                      color: Colors.blue),
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: hintStatus
                                      ? () {
                                          int rand = Random()
                                              .nextInt(hintLetters.length);
                                          wordPress(germanalphabet.alphabet
                                              .indexOf(
                                                  wordList[hintLetters[rand]]));
                                          hintStatus = false;
                                        }
                                      : null,
                                ),
                              ]),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: FittedBox(
                            child: Image.asset(
                              'assets/images/$hangState.png',
                              height: 1001,
                              width: 991,
                              gaplessPlayback: true,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 35.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              hiddenWord,
                              style: kWordTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 2.0, 8.0, 10.0),
                  child: Table(
                    defaultVerticalAlignment:
                        TableCellVerticalAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    //columnWidths: {1: FlexColumnWidth(10)},
                    children: [
                      TableRow(children: [
                        TableCell(
                          child: createButton(0),
                        ),
                        TableCell(
                          child: createButton(1),
                        ),
                        TableCell(
                          child: createButton(2),
                        ),
                        TableCell(
                          child: createButton(3),
                        ),
                        TableCell(
                          child: createButton(4),
                        ),
                        TableCell(
                          child: createButton(5),
                        ),
                        TableCell(
                          child: createButton(6),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: createButton(7),
                        ),
                        TableCell(
                          child: createButton(8),
                        ),
                        TableCell(
                          child: createButton(9),
                        ),
                        TableCell(
                          child: createButton(10),
                        ),
                        TableCell(
                          child: createButton(11),
                        ),
                        TableCell(
                          child: createButton(12),
                        ),
                        TableCell(
                          child: createButton(13),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: createButton(14),
                        ),
                        TableCell(
                          child: createButton(15),
                        ),
                        TableCell(
                          child: createButton(16),
                        ),
                        TableCell(
                          child: createButton(17),
                        ),
                        TableCell(
                          child: createButton(18),
                        ),
                        TableCell(
                          child: createButton(19),
                        ),
                        TableCell(
                          child: createButton(20),
                        ),
                      ]),
                      TableRow(children: [
                        TableCell(
                          child: createButton(21),
                        ),
                        TableCell(
                          child: createButton(22),
                        ),
                        TableCell(
                          child: createButton(23),
                        ),
                        TableCell(
                          child: createButton(24),
                        ),
                        TableCell(
                          child: createButton(25),
                        ),
                        TableCell(
                          child: Text(''),
                        ),
                        TableCell(
                          child: Text(''),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
