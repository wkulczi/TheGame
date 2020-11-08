import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/golScreen.dart';
import 'package:flutter_app/snakeScreen.dart';

import 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/snakeScreen':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => SnakeScreen(speed: args),
          );
        }
        return _errorRoute();
      case '/golScreen':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => GolScreen(speed: args),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "ERRROR",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }
}
