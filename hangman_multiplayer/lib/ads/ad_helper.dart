import 'dart:io';

class AdHelper {
  static String get intersitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3936477201554498/2044722914";
    } else {
      throw new UnsupportedError('Unsoported Platform');
    }
  }
}