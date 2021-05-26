import 'package:flutter/material.dart';
import 'package:hangman_multiplayer/pages/introduction_page.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return OnboardingScreen(toggleView);
    } else {
      return OnboardingScreen(toggleView);
    }
  }
}