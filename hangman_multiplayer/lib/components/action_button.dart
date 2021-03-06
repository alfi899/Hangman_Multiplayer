import 'package:flutter/material.dart';
import 'package:hangman_multiplayer/utilities/constants.dart';


class ActionButton extends StatelessWidget {
  ActionButton({this.buttonTitle, this.onPress});
  
  final Function onPress;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 3.0,
        color: kActionButtonColor,
        highlightColor: kActionButtonHighlightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: onPress,
        child: Text(
          buttonTitle,
          style: kActionButtonTextStyle,
        ),
      ),
    );
  }
}