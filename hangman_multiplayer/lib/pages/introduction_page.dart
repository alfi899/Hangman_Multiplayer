import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangman_multiplayer/components/action_button.dart';
import 'package:hangman_multiplayer/components/auth.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:hangman_multiplayer/components/helperfunctions.dart';
import 'package:hangman_multiplayer/pages/home_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OnboardingScreen extends StatefulWidget {
  final Function toggleView;
  OnboardingScreen(this.toggleView);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  bool isLoading = false;

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  bool avatarSelected = false;
  bool dogSelected = false;
  bool foxSelected = false;
  bool pandaSelected = false;
  bool monkeySelected = false;
  bool catSelected = false;
  bool pigSelected = false;

  String profilePicture = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  QuerySnapshot result;

  final GlobalKey<FormFieldState> _nameFormKey = GlobalKey<FormFieldState>();
  // ignore: unused_field
  bool _isSubmittButtonEnable = false;

  bool _isFormValid() {
    return (_nameFormKey.currentState.isValid);
  }

  QuerySnapshot searchResultSnapshot;

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.blue);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          color: Colors.blue, fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      contentPadding: EdgeInsets.only(top: 60),
      pageColor: Colors.black87,
      imagePadding: EdgeInsets.only(top: 20),
      titlePadding: EdgeInsets.only(top: 20),
    );
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome to Hangman",
          decoration: pageDecoration,
          bodyWidget: SafeArea(
              child: Column(children: [
            SizedBox(height: 140),
            TextFormField(
              key: _nameFormKey,
              autocorrect: false,
              cursorColor: Colors.blue,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              controller: nameController,
              onChanged: (value) {
                setState(() {
                  _isSubmittButtonEnable = _isFormValid();
                  _nameFormKey.currentState.validate();
                });
              },
              validator: (value) {
                if (value.isEmpty || value.length < 3) {
                  return "Enter Name 3+ characters";
                } else {
                  return null;
                }
              },
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: "Name",
                fillColor: Colors.blue,
                labelStyle: TextStyle(color: Colors.blue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 30),
          ])),
        ),
        PageViewModel(
          title: "Suche dir einen Avatar aus",
          //body: "Die zweite Seite",
          decoration: pageDecoration,
          bodyWidget: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: GridView.count(
                    padding: EdgeInsets.all(10),
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 60.0,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Tapped the Fox");
                          setState(() {
                            foxSelected = true;
                            dogSelected = false;
                            pandaSelected = false;
                            monkeySelected = false;
                            pigSelected = false;
                            catSelected = false;
                            profilePicture = "Fox";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              //color: Colors.red,
                              border: Border.all(
                                  color:
                                      foxSelected ? Colors.green : Colors.red,
                                  width: 5.0),
                              image: DecorationImage(
                                image: AssetImage("assets/avatar/fox.jpg"),
                                fit: BoxFit.fill,
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Tapped the Dog");
                          setState(() {
                            foxSelected = false;
                            dogSelected = true;
                            pandaSelected = false;
                            monkeySelected = false;
                            pigSelected = false;
                            catSelected = false;
                            profilePicture = "Dog";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      dogSelected ? Colors.green : Colors.red,
                                  width: 5.0),
                              image: DecorationImage(
                                  image: AssetImage("assets/avatar/dog.jpg"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Tapped th Panda");
                          setState(() {
                            foxSelected = false;
                            dogSelected = false;
                            pandaSelected = true;
                            monkeySelected = false;
                            pigSelected = false;
                            catSelected = false;
                            profilePicture = "Panda";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      pandaSelected ? Colors.green : Colors.red,
                                  width: 5.0),
                              image: DecorationImage(
                                  image: AssetImage("assets/avatar/panda.jpg"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Tapped the monkey");
                          setState(() {
                            foxSelected = false;
                            dogSelected = false;
                            pandaSelected = false;
                            monkeySelected = true;
                            pigSelected = false;
                            catSelected = false;
                            profilePicture = "Monkey";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color:
                                    monkeySelected ? Colors.green : Colors.red,
                                width: 5.0),
                            image: DecorationImage(
                                image: AssetImage("assets/avatar/monkey.jpg"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Tapped the Cat");
                          setState(() {
                            foxSelected = false;
                            dogSelected = false;
                            pandaSelected = false;
                            monkeySelected = false;
                            pigSelected = false;
                            catSelected = true;
                            profilePicture = "Cat";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      catSelected ? Colors.green : Colors.red,
                                  width: 5.0),
                              image: DecorationImage(
                                  image: AssetImage("assets/avatar/cat.jpg"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Tapped the Pig");
                          setState(() {
                            foxSelected = false;
                            dogSelected = false;
                            pandaSelected = false;
                            monkeySelected = false;
                            pigSelected = true;
                            catSelected = false;
                            profilePicture = "Pig";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      pigSelected ? Colors.green : Colors.red,
                                  width: 5.0),
                              image: DecorationImage(
                                  image: AssetImage("assets/avatar/pig.jpg"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "Dein Profil",
          //body: "Die dritte Seite",
          bodyWidget: Column(
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                backgroundImage: getImage(),
                radius: 70,
              ),
              SizedBox(height: 50),
              Center(
                  child: Text("${nameController.text}",
                      style: TextStyle(color: Colors.blue, fontSize: 30))),
              SizedBox(
                height: 80,
              )
            ],
          ),
          footer: nameController.text.length < 3
              ? Container()
              : Container(
                  height: 44,
                  child: ActionButton(
                    buttonTitle: "Start",
                    onPress: () async {
                      print("${nameController.text}");
                      await databaseMethods
                          .searchByName(nameController.text)
                          .then((snapshot) {
                        searchResultSnapshot = snapshot;
                        print(">>>>>>>>>>>>>>>>>>$searchResultSnapshot");
                      });
                      if (searchResultSnapshot.docs.length == 0) {
                        // user name noch frei
                        signUp();
                      } else {
                        Alert(
                            context: context,
                            title: "Username schon vergeben",
                            desc: "Nimm ein anderer",
                            style: AlertStyle(
                              backgroundColor: Colors.black,
                              titleStyle: TextStyle(color: Colors.white),
                              descStyle: TextStyle(color: Colors.white),
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "OKAY",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ]).show();
                      }
                    },
                  ),
                ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => print("Go to Home Page"),
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward, color: Colors.blue),
      done: const Text("Done"),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  AssetImage getImage() {
    if (dogSelected == true) {
      return AssetImage("assets/avatar/dog.jpg");
    } else if (foxSelected == true) {
      return AssetImage("assets/avatar/fox.jpg");
    } else if (pandaSelected == true) {
      return AssetImage("assets/avatar/panda.jpg");
    } else if (catSelected == true) {
      return AssetImage("assets/avatar/cat.jpg");
    } else if (monkeySelected == true) {
      return AssetImage("assets/avatar/monkey.jpg");
    } else if (pigSelected == true) {
      return AssetImage("assets/avatar/pig.jpg");
    } else {
      return AssetImage("assets/avatar/panda.jpg");
    }
  }

  signUp() async {
    // create Map to upload to database
    Map<String, dynamic> userInfoMap = {
      "name": nameController.text,
      //"email" : emailController.text,
      "score": "0",
      "profile": profilePicture,
      "zufallScore": 0,
      "markenScore": 0,
      "tiereScore": 0,
      "landScore": 0,
      "sportScore": 0,
      "zeitScore": 0
    };

    databaseMethods.uploadUserInfo(userInfoMap);

    HelperFunctions.saveUserLoggedInSharedPreference(true);
    HelperFunctions.saveUserNameSharedPreference(nameController.text);
    HelperFunctions.saveUserEmailSharedPreference(emailController.text);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
