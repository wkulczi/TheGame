import 'package:flutter/material.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'UbuntuMono'),
      title: 'The Game',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "The game of Snake",
                style: TextStyle(color: Colors.white, decoration: TextDecoration.underline, fontSize: 30),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Text(
                      "Snake",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Container(
                    child: Text("Game Of Life",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                  Container(
                    child: Text("Exit",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
