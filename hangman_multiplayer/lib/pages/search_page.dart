import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangman_multiplayer/components/constants.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:hangman_multiplayer/pages/multiplayer_page.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      if (searchEditingController.text == Constants.myName) {
        setState(() {
          isLoading = false;
        });
      } else {
        await databaseMethods
            .searchByName(searchEditingController.text)
            .then((snapshot) {
          searchResultSnapshot = snapshot;
          print(">>>>>>>>>>>>>>>>>>$searchResultSnapshot");
          setState(() {
            isLoading = false;
            haveUserSearched = true;
          });
        });
      }
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              print("${searchResultSnapshot.docs[index].data()["name"]}");
              print("--------------------------------------------------------");
              DocumentSnapshot test = searchResultSnapshot.docs[index];
              print("----${test["name"]}");
              return userTile(
                searchResultSnapshot.docs[index].data()["name"],
              );
            },
          )
        : Container(
            child: Text("No Data found"),
          );
  }

  // 1. create a chatroom,send user to the chatroom, other userdetails
  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    // create doc WORD in database
    databaseMethods.addeMessage(chatRoomId);

    // push to chat with chat room id
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MultiPlayerPage()));
  }

  Widget userTile(String userName) {
    return GestureDetector(
      onTap: () {
        sendMessage(userName);
        // push to chat
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
        margin: EdgeInsets.only(top: 8, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black,
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Material(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF1089ff),
                child: Text(
                  userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(userName,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                color: Color(0xFF1089ff), fontSize: 18.0),
                          )),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
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
          child: Column(children: [
            SizedBox(height: 20
                /*MediaQuery.of(context).size.height / 13*/),
            Row(children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Color(0xFF1089ff)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              SizedBox(width: MediaQuery.of(context).size.width / 5),
              Text(
                "SUCHE",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 59.0,
                  letterSpacing: 3.0,
                  color: Color(0xFF1089ff),
                ),
              ),
            ]),
            SizedBox(
              height: 30,
            ),
            isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            color: Color(0x54FFFFFF),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: searchEditingController,
                                    style: GoogleFonts.roboto(),
                                    decoration: InputDecoration(
                                      hintText: "search username...",
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    initiateSearch();
                                  },
                                  child: Icon(
                                    Icons.search,
                                    size: 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          userList()
                        ],
                      ),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
