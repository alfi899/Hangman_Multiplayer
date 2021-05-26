import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman_multiplayer/pages/game_screen.dart';
import 'package:hangman_multiplayer/pages/multiplayer_page.dart';
import 'package:hangman_multiplayer/components/constants.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final int guess;
  final String gegnerName;

  final bool gameBeendet;
  final bool win;
  final bool loose;

  Chat(
      {this.chatRoomId,
      this.guess,
      this.gameBeendet,
      this.win,
      this.loose,
      this.gegnerName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = TextEditingController();

  Stream<QuerySnapshot> words;
  DatabaseMethods database = DatabaseMethods();

  bool myTurn = false;

  bool _gameBeendet = false;

  bool red = false;
  bool green = false;

  String testWord = "";
  String sendby = "";
  String gameState = "";
  int myScore = 0;
  int otherScore = 0;
  DocumentSnapshot documentSnapshot;

  getWord() {
    database.getLatestWord(widget.chatRoomId).then((snapshot) {
      documentSnapshot = snapshot;
      print("${documentSnapshot.toString()}");
      setState(() {
        testWord = documentSnapshot.data()["message"];
        sendby = documentSnapshot.data()["sendBy"];
        gameState = documentSnapshot.data()["spielstatus"];
        myScore = documentSnapshot.data()["myScore"];
        otherScore = documentSnapshot.data()["otherScore"];

        if (gameState == "beendet_gewonnen") {
          green = true;
        }
        if (gameState == "beendet_verloren") {
          red = true;
        }
      });
      print("----------------------- testWord = $testWord -----------------");
      print("GAMESTATE ===>> $gameState");
    });
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      DatabaseMethods().updateWord(
          widget.chatRoomId,
          messageEditingController.text,
          Constants.myName,
          DateTime.now().toString(),
          "warte",
          myScore,
          otherScore);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });

    getWord();

    super.initState();
  }

  getColor() {
    if (red == true) {
      return Colors.red;
    } else if (green == true) {
      return Colors.green;
    } else {
      return Colors.grey[850];
    }
  }

  getTextButton() {
    if (gameState == "beendet_gewonnen") {
      setState(() {
        green = true;
      });
      return Text("Game beendet",
          style: TextStyle(color: Colors.white, fontSize: 18));
    } else if (gameState == "beendet_verloren") {
      setState(() {
        red = true;
      });
      return Text("Game beendet",
          style: TextStyle(color: Colors.white, fontSize: 18));
    } else if (testWord == "") {
      return Text("Dein Wort",
          style: TextStyle(color: Colors.white, fontSize: 18));
    } else if (sendby == Constants.myName) {
      return Text("$testWord",
          style: TextStyle(color: Colors.white, fontSize: 18));
    } else {
      return Text("Errate das Wort!",
          style: TextStyle(color: Colors.white, fontSize: 18));
    }
  }

  playButton() {
    if ((sendby != Constants.myName || sendby == "") && gameState != "warte" ||
        _gameBeendet == true) {
      // at the beginning oder wenn man dran ist das wort einzugeben
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 50,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
              style: TextStyle(color: Colors.white),
              controller: messageEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "  Gebe hier das Wort ein",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          SizedBox(height: 40),
          DialogButton(
            width: 130,
            onPressed: () {
              addMessage();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(
                          chatRoomId: widget.chatRoomId,
                          gegnerName: widget.gegnerName)));
            },
            child: Row(
              children: [
                Text("Send Word  ",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Icon(Icons.send, color: Colors.white, size: 25)
              ],
            ),
          ),
        ],
      );
    } else if (gameState == "warte") {
      return Container(
          child: DialogButton(
              child: Text(
                  sendby != Constants.myName ? "Play" : "warte auf gegner",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: sendby != Constants.myName
                  ? () {
                      print("Play button pressed");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameScreen(
                                  wordFromMultiPLayer: testWord.toLowerCase(),
                                  gegnerName: widget.gegnerName,
                                  yourScore: myScore,
                                  otherScore: otherScore,
                                  chatRoomID: widget.chatRoomId)));
                    }
                  : () {}));
    } else {
      return Container();
    }
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
        child: LiquidPullToRefresh(
          animSpeedFactor: 5.0,
          onRefresh: () async {
            initState();
            return await Future.delayed(Duration(seconds: 1));
          },
          child: SafeArea(
            child: ListView(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20
                        /*MediaQuery.of(context).size.height / 13*/),
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Color(0xFF1089ff)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MultiPlayerPage()));
                            }),
                        SizedBox(width: MediaQuery.of(context).size.width / 4),
                        Text(
                          "PLAY",
                          style: TextStyle(
                            color: Color(0xFF1089ff),
                            fontSize: 58.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          // left side
                          Column(
                            children: [
                              Text(
                                "   You",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 38),
                              ),
                              Text(
                                widget.chatRoomId
                                            .startsWith(widget.gegnerName, 0) ==
                                        false
                                    ? " $myScore"
                                    : "  $otherScore",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 38),
                              ),
                            ],
                          ),
                          Spacer(),
                          // right side
                          Column(
                            children: [
                              Text(
                                "${widget.gegnerName}  ",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 38),
                              ),
                              Text(
                                widget.chatRoomId
                                            .startsWith(widget.gegnerName, 0) ==
                                        false
                                    ? "$otherScore"
                                    : "$myScore",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 38),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Card(
                              color: getColor(),
                              margin: EdgeInsets.only(left: 30, right: 30),
                              shadowColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 10,
                              child: Container(
                                height: 50,
                                child: Center(
                                  child: getTextButton(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          playButton(),
                          SizedBox(height: 40),
                          Container(
                            child: Center(
                              child: Text(
                                "Ziehe nach unten um zu aktualisieren",
                                style: TextStyle(color: Colors.white, letterSpacing: 2.0),)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
