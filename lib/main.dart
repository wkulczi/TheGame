import 'package:flutter/material.dart';
import 'package:flutter_app/golScreen.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Game',
      home: GolScreen(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text("Nic tu nie ma."),
        ),
      ),
    );
  }
}
