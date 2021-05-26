import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangman_multiplayer/components/constants.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:hangman_multiplayer/components/helperfunctions.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream testName;

  getUserName() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  void initState() {
    DatabaseMethods().getData(Constants.myName);
    getUserName();
    DatabaseMethods().getUserInformation(Constants.myName).then((info) {
      setState(() {
        _info = info;
      });
    });

    super.initState();
  }

  Stream _info;
  String picture = "";

  CircleAvatar getProfileImage(String name) {
    return CircleAvatar();
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
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20
                  /*MediaQuery.of(context).size.height / 13*/),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFF1089ff)),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(width: MediaQuery.of(context).size.width / 6),
                  Center(
                    child: Container(
                      child: Text(
                        'PROFILE',
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      height: 200,
                      color: Color(0x54FFFFFF), //Color(0xFF1089ff),
                      //transform: Matrix4.skewY(0.3),
                      child: Center(
                        child: StreamBuilder(
                          stream: _info,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                  child: Container(color: Color(0x54FFFFFF)));
                            }
                            return ListView(
                              shrinkWrap: true,
                              children:
                                  snapshot.data.docs.map<Widget>((document) {
                                if (document["profile"] == "Fox") {
                                  return CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage("assets/avatar/fox.jpg"),
                                    ),
                                  );
                                }
                                if (document["profile"] == "Cat") {
                                  return CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage("assets/avatar/cat.jpg"),
                                    ),
                                  );
                                }
                                if (document["profile"] == "Dog") {
                                  return CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage("assets/avatar/dog.jpg"),
                                    ),
                                  );
                                }
                                if (document["profile"] == "Panda") {
                                  return CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage("assets/avatar/panda.jpg"),
                                    ),
                                  );
                                }
                                if (document["profile"] == "Monkey") {
                                  return CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: AssetImage(
                                          "assets/avatar/monkey.jpg"),
                                    ),
                                  );
                                }
                                if (document["profile"] == "Pig") {
                                  return CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage("assets/avatar/pig.jpg"),
                                    ),
                                  );
                                }
                                return CircleAvatar(
                                  radius: 60,
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      Constants.myName,
                      style: GoogleFonts.odibeeSans(
                        textStyle: TextStyle(
                          color: Colors.blue, 
                          fontSize: 30, 
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0)
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      child: Image.asset(
                        'assets/images/6.png',
                        height: 500,
                        width: 791,
                        gaplessPlayback: true,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}