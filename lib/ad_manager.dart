import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7326884795508047~2791709945";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7326884795508047/9165546609";
    }
    else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}