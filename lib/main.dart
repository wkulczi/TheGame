import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/coord-space.dart';

void main() {
  runApp(MaterialApp(home: GameScreen(), routes: <String, WidgetBuilder>{
    '/game': (BuildContext context) => GameScreen(),
  }));
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

class GameScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Game',
      home: GameScreenState(),
    );
  }
}

class GameScreenState extends StatefulWidget {
  GameScreenState({Key key}) : super(key: key);

  @override
  _GameScreenStateState createState() => _GameScreenStateState();
}

class _GameScreenStateState extends State<GameScreenState> {
  int score = 0;
  bool isPlaying = true;
  static int maxCols = 20;
  static int maxRows = 34;

  //coordinate space scales, to freely convert from int to Coord and back
  static CoordinateSpace coordinateSpace = new CoordinateSpace(elementsInRow: maxCols, elementsInColumn: maxRows);

  var activeDots = [222, 224, 226, 228, 230, 233, 235, 237];
  
  void gameLoop() {
    print(this.activeDots);
    var activeDotsAsCoords = [];
    this.activeDots.forEach((element) {activeDotsAsCoords.add(coordinateSpace.convert(pos: element));});
    print(activeDotsAsCoords);
    // Timer.periodic(Duration(milliseconds: 700), (timer) {
       // update stuff
      // this.updateScreen();
    // });
  }

  void updateScreen() {
    //  rules go here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 12,
              child: Container(
                child: GridView.builder(
                    //don't ask me why
                    itemCount: maxCols*maxRows,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: maxCols),
                    itemBuilder: (context, index) {
                      return this.ConditionallyColoredRectangle(
                          activeDots.contains(index), index);
                    }),
              )),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "Score: " + getScore().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                InkWell(
                  child: Container(
                    child: Text(
                      "Clear dots",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () => ({setState(() => this.activeDots.clear())}),
                ),
                InkWell(
                  child: Container(
                    child: Text(
                      this.isPlaying ? "Exit" : "Play",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () => ({this.gameLoop(), setState(() => score++)}),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int getScore() {
    return this.score;
  }

  Widget ConditionallyColoredRectangle(bool predicate, int index) {
    if (predicate) {
      return Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: InkWell(
            onTap: () => ({
              setState(() => this.activeDots.remove(index)),
            }),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: InkWell(
            onTap: () => ({
              setState(() => this.activeDots.add(index)),
            }),
            child: Container(
              color: Colors.grey[900],
            ),
          ),
        ),
      );
    }
  }
}
