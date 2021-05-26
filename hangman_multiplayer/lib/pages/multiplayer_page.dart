import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangman_multiplayer/components/constants.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:hangman_multiplayer/components/helperfunctions.dart';
import 'package:hangman_multiplayer/pages/chat.dart';
import 'package:hangman_multiplayer/pages/home_page.dart';
import 'package:hangman_multiplayer/pages/search_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MultiPlayerPage extends StatefulWidget {
  @override
  _MultiPlayerPageState createState() => _MultiPlayerPageState();
}

class _MultiPlayerPageState extends State<MultiPlayerPage> {
  TextEditingController textEditingController = TextEditingController();
  final database = FirebaseFirestore.instance;
  String searchString;

  Stream chatRooms;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRooms,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ChatRoomsTile(
                      userName: snapshot.data.docs[index]
                          .data()["chatRoomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRoomId:
                          snapshot.data.docs[index].data()["chatRoomId"],
                    );
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshot) {
      setState(() {
        chatRooms = snapshot;
        print(
            "we got the data + ${chatRooms.toString()} this is name ${Constants.myName})");
      });
    });
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
                                builder: (context) => HomePage()));
                      }),
                  SizedBox(width: MediaQuery.of(context).size.width / 5),
                  Center(
                    child: Container(
                      child: Text(
                        'Games',
                        style: TextStyle(
                          color: Color(0xFF1089ff),
                          fontSize: 58.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: chatRoomList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  final snackBar = SnackBar(content: Text('Removed Player'));

  @override
  void initState() {
    getTest(widget.userName);
    super.initState();
  }

  DocumentSnapshot documentsnapshot;
  String testImage;
  String imageName;

  void getTest(String name) {
    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        print("document ID----" + f.reference.id);
        getProfileImage(f.reference.id, imageName).then((snapshot) {
          documentsnapshot = snapshot;
          imageName = documentsnapshot.data()["profile"];
          print("$imageName -----------------");
          setState(() {
            testImage = imageName;
          });
        });
      });
    });
  }

  getProfileImage(docID, String imagename) {
    return FirebaseFirestore.instance.collection("users").doc(docID).get();
  }

  getImage(String name) {
    if (name == "Dog") {
      return AssetImage("assets/avatar/dog.jpg");
    } else if (name == "Cat") {
      return AssetImage("assets/avatar/cat.jpg");
    } else if (name == "Fox") {
      return AssetImage("assets/avatar/fox.jpg");
    } else if (name == "Monkey") {
      return AssetImage("assets/avatar/monkey.jpg");
    } else if (name == "Pig") {
      return AssetImage("assets/avatar/pig.jpg");
    } else if (name == "Panda") {
      return AssetImage("assets/avatar/panda.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // push to chat
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                    chatRoomId: widget.chatRoomId,
                    gegnerName: widget.userName)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
        margin: EdgeInsets.only(top: 8, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black, //Color(0xff434656),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Material(
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF1089ff),
                  backgroundImage: getImage(testImage)),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        widget.userName,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Color(0xFF1089ff),
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
            GestureDetector(
              onTap: () {
                // remove player from List

                Alert(
                    style: AlertStyle(
                        backgroundColor: Colors.black,
                        titleStyle: TextStyle(color: Colors.blue)),
                    context: context,
                    title: "Sicher ?",
                    type: AlertType.info,
                    //desc: "Wenn der Spieler entfert wird, gehen diese Spielstände verloren!",
                    buttons: [
                      DialogButton(
                          child: Text("Nein",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      DialogButton(
                          child: Text("Ja",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          onPressed: () {
                            DatabaseMethods().deleteChats(widget.chatRoomId);
                            Navigator.pop(context);
                          }),
                    ]).show();
                //Scaffold.of(context).showSnackBar(snackBar);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24)),
                child: Text("Remove",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
                margin: EdgeInsets.only(left: 30),
              ),
            )
          ],
        ),
      ),
    );
  }
}
