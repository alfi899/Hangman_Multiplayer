import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hangman_multiplayer/components/authenticate.dart';
import 'package:hangman_multiplayer/components/helperfunctions.dart';
import 'package:hangman_multiplayer/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => new MaterialApp(
                                        debugShowCheckedModeBanner: false,
                                        home: MyApp()
                                      ),
                                    ),
                                  );
} 

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override 
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 9,
      navigateAfterSeconds: AfterSplash(),
      title: Text(
        "Welcome to Hangman",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white),
      ),
      image: Image.asset("assets/images/6.png"),
      backgroundColor: Colors.black,
      loaderColor: Colors.blue,
      photoSize: 100.0,
      loadingText: Text("Loading...", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18.0),),
    );
  }
  /*bool userIsLoggedIn;

  @override 
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman',
      theme: ThemeData(
        textTheme: GoogleFonts.creepsterTextTheme(),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xff434656),
      ),
      home: userIsLoggedIn != null ? 
              userIsLoggedIn ? HomePage() : Authenticate()
            : Authenticate()
    );
  }*/
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {

  bool userIsLoggedIn;

  @override 
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman',
      theme: ThemeData(
        textTheme: GoogleFonts.creepsterTextTheme(),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xff434656),
      ),
      home: userIsLoggedIn != null ? 
              userIsLoggedIn ? HomePage() : Authenticate()
            : Authenticate()
    );
  }
}