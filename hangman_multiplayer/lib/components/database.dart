import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInformation(String name) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .snapshots();
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: searchField)
        .get();
  }

  // ignore: missing_return
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  getLatestWord(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc("WORT")
        .get();
  }

  getUserChats(String itIsMyName) async {
    // ignore: await_only_futures
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: itIsMyName)
        .snapshots();
  }

  deleteChats(chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .delete();
  }

  getUserByUserName(String username) {
    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  // ignore: missing_return
  Future<void> addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  // erstellt das leere document WORD in der Datenbank
  // ignore: missing_return
  Future<void> addeMessage(String chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc("WORT")
        .set({
      "message": "",
      "sendBy": "",
      "time": "",
      "spielstatus": "",
      "myScore": 0,
      "otherScore": 0
    }).catchError((e) {
      print(e.toString());
    });
  }

  // updated das aktuelle Word in der Database
  // ignore: missing_return
  Future<void> updateWord(String chatRoomId, message, sendby, time, spielstatus,
      myscore, otherscore) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc("WORT")
        .update({
      "message": message,
      "sendBy": sendby,
      "time": time,
      "spielstatus": spielstatus,
      "myScore": myscore,
      "otherScore": otherscore
    }).catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<void> updateGameState(String chatRoomId, spielstatus) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc("WORT")
        .update({"spielstatus": spielstatus}).catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<void> updateScore(String chatRoomId, myscore, otherSore) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc("WORT")
        .update({"myScore": myscore, "otherScore": otherSore}).catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  DocumentSnapshot documentsnapshot;

  getCurrentScore(docId) {
    return FirebaseFirestore.instance.collection("users").doc(docId).get();
  }

  test(String name, int score, String category) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        print("document ID----" + f.reference.id);
        getCurrentScore(f.reference.id).then((snapshot) {
          documentsnapshot = snapshot;
          //var highscore = documentsnapshot.data()["score"];
          //print("$highscore ----------------- old Score");
          print("$score ----------------- new Score");
          print("$category -------------- Category");
          if (category == "Zufall") {
            int highscore = documentsnapshot.data()["zufallScore"];

            if (score > highscore) {
              updateSingleScore(score, f.reference.id);
            }
          } else if (category == "Tiere") {
            int highscore = documentsnapshot.data()["tiereScore"];

            if (score > highscore) {
              updateTierScore(score, f.reference.id);
            }
          } else if (category == "Marken") {
            int highscore = documentsnapshot.data()["markenScore"];

            if (score > highscore) {
              updateMarkenScore(score, f.reference.id);
            }
          } else if (category == "Land") {
            int highscore = documentsnapshot.data()["landScore"];

            if (score > highscore) {
              updateLandScore(score, f.reference.id);
            }
          } else if (category == "Sport") {
            int highscore = documentsnapshot.data()["sportScore"];

            if (score > highscore) {
              updateSportScore(score, f.reference.id);
            }
          } else if (category == "Zeit") {
            int highscore = documentsnapshot.data()["zeitScore"];

            if (score > highscore) {
              updateZeitScore(score, f.reference.id);
            }
          }
        });
      });
    });
  }

  /*DocumentSnapshot _snapshot;
  Ranking scor = Ranking();
  var score;
  HighScore high;

  Future<String> getHighscore(String name) async {
    await FirebaseFirestore.instance
      .collection("users")
      .where("name", isEqualTo: name)
      .get()
      .then(
        (QuerySnapshot snapshot) {
          snapshot.docs.forEach((f) {
            getCurrentScore(f.reference.id).then((snapshot) {
              _snapshot = snapshot;
              score = _snapshot.data()["score"];
              //return _snapshot.data()["score"];
             return score;
            });
          });
      });
  }*/

  // ignore: missing_return
  Future<void> updateSingleScore(int score, id) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"zufallScore": score}).catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<void> updateMarkenScore(int score, id) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"markenScore": score}).catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<void> updateTierScore(int score, id) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"tiereScore": score}).catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<void> updateZeitScore(int score, id) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"zeitScore": score}).catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<void> updateLandScore(int score, id) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"landScore": score}).catchError((e) {
      print(e.toString());
    });
  }

  // ignore: missing_return
  Future<void> updateSportScore(int score, id) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"sportScore": score}).catchError((e) {
      print(e.toString());
    });
  }

  getData(String userName) async {
    // ignore: await_only_futures
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: userName)
        .snapshots();
  }
}
