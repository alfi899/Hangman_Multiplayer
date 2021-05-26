import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangman_multiplayer/components/database.dart';
import 'package:hangman_multiplayer/components/user.dart';

class AuthService {
  final snackbar = SnackBar(content: Text("Keine Anmeldung möglich"));

  final FirebaseAuth _auth = FirebaseAuth.instance;
  QuerySnapshot searchResultSnapshot;

  bool vergeben = false;

  UserClass _userFromFirebaseUser(User user) {
    return user != null ? UserClass(uid: user.uid) : null;
  }

  Future signUpWithEmailAndPassword(String name, String email, String password) async {
    try {

      await DatabaseMethods().searchByName(name).then((snapshot) {
        searchResultSnapshot = snapshot;
        if (searchResultSnapshot.docs.length != 0) {
          vergeben = true;
          //return null;
        }
      });
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

      User user = result.user;
      return _userFromFirebaseUser(user);
      
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return false;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}