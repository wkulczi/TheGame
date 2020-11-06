import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/coord-space.dart';
import 'package:flutter_app/snake.dart';

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
  static CoordinateSpace coordinateSpace =
      new CoordinateSpace(elementsInRow: maxCols, elementsInColumn: maxRows);

  //a snake object to move around the guy
  var snake = Snake(snakeLocation: [488, 489, 469, 449, 429]
      .map((e) => coordinateSpace.convert(pos: e))
      .toList());

  void gameLoop() {
    Timer.periodic(Duration(milliseconds: 400), (timer) {
    this.updateScreen();
    });
  }

  void updateScreen() {
    setState(() {
      this.snake.moveSnake();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (snake.getDirection() == Direction.south ||
              snake.getDirection() == Direction.north) {
            if (details.delta.dx > 0) {
              setState(() {
                snake.changeDirection(newDirection: Direction.east);
              });
            } else {
              setState(() {
                snake.changeDirection(newDirection: Direction.west);
              });
            }
          }
        },
        onVerticalDragUpdate: (details) {
          if (snake.getDirection() == Direction.west ||
              snake.getDirection() == Direction.east) {
            if (details.delta.dy > 0) {
              setState(() {
                snake.changeDirection(newDirection: Direction.south);
              });
            } else {
              setState(() {
                snake.changeDirection(newDirection: Direction.north);
              });
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 12,
                child: Container(
                  child: GridView.builder(
                      //don't ask me why
                      itemCount: maxCols * maxRows,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: maxCols),
                      itemBuilder: (context, index) {
                        return this.conditionallyColoredRectangle(
                            snake
                                .getSnakePos()
                                .map((e) => coordinateSpace.deconvert(coord: e))
                                .toList()
                                .contains(index),
                            index);
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
                    onTap: () => {this.gameLoop()},
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
      ),
    );
  }

  int getScore() {
    return this.score;
  }

  Widget conditionallyColoredRectangle(bool predicate, int index) {
    if (predicate) {
      return Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            color: Colors.grey[900],
          ),
        ),
      );
    }
  }
}
