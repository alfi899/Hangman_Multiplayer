import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class HangmanWords {
  int wordCounter = 0;
  List<int> _usedNumbers = [];
  List<String> _words = [];

  Future readWords(int category) async {
    // Zufall
    if (category == 1) {
      String fileText = await rootBundle.loadString('lib/res/hangman_words.txt');
      _words = fileText.split(',');
    }
    if (category == 2) {
      String fileText = await rootBundle.loadString('lib/res/hangman_words_tiere.txt');
      _words = fileText.split(',');
    }
    if (category == 3) {
      String fileText = await rootBundle.loadString('lib/res/hangman_words_marken.txt');
      _words = fileText.split(',');
    }
    if (category == 4) {
      String fileText = await rootBundle.loadString('lib/res/hangman_words_stla.txt');
      _words = fileText.split(',');
    }
    if (category == 5) {
      String fileText = await rootBundle.loadString('lib/res/hangman_words_sport.txt');
      _words = fileText.split(',');
    }
  }

  void resetWords() {
    wordCounter = 0;
    _usedNumbers = [];
  }

  // ignore: missing_return
  String getWord() {
    wordCounter += 1;
    var rand = Random();
    int wordLength = _words.length;
    int randNumber = rand.nextInt(wordLength);
    bool notUnique = true;
    if (wordCounter - 1 == _words.length) {
      notUnique = false;
      return '';
    }
    while (notUnique) {
      if (!_usedNumbers.contains(randNumber)) {
        notUnique = false;
        _usedNumbers.add(randNumber);
        return _words[randNumber];
      } else {
        randNumber = rand.nextInt(wordLength);
      }
    }
  }

  String getHiddenWord(int wordLengthhhhh) {
    String hiddenWord = '';
    for (int i = 0; i < wordLengthhhhh; i++) {
      hiddenWord += '_';
    }
    return hiddenWord;
  }
}