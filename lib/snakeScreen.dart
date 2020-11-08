import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/snake.dart';
import 'package:flutter_app/snakeGameWindow.dart';

import 'apple.dart';
import 'coordSpace.dart';
import 'direction.dart';
import 'point.dart';

class SnakeScreen extends StatefulWidget {
  SnakeScreen({Key key}) : super(key: key);

  @override
  _SnakeScreenState createState() => _SnakeScreenState();
}

class _SnakeScreenState extends State<SnakeScreen> {
  int score = 0;
  bool isPlaying = false;
  static int baseSpeed = 300;
  static int maxCols = 20;
  static int maxRows = 30;

  //coordinate space scales, to freely convert from int to Coord and back
  static CoordinateSpace coordinateSpace =
      new CoordinateSpace(elementsInRow: maxCols, elementsInColumn: maxRows);

  var apple = Apple(maxCols: maxCols, maxRows: maxRows);

  //a snake object to move around the guy
  var snake = Snake(maxCols: maxCols, maxRows: maxRows);

  List<Point> activePoints = [];

  @override
  void initState() {
    activePoints.add(snake);
    activePoints.add(apple);
    super.initState();
  }

  void startGameLoop() {
    Timer.periodic(Duration(milliseconds: baseSpeed), (timer) {
      this.updateScreen(timer);
    });
  }

  void updateScreen(Timer timer) {
    setState(() {
      if (this.isPlaying) {
        if (snake.alive()) {
          snakeGameRoutine(timer);
        } else {
          this.isPlaying = false;
          timer.cancel();
          //  popup
        }
      } else {
        timer.cancel();
      }
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
                child: snakeGameWindow(
                    maxCols: maxCols,
                    maxRows: maxRows,
                    activePoints: activePoints,
                    coordinateSpace: coordinateSpace)),
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
                        this.isPlaying ? "Exit" : "Play",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () => ({
                      if (this.isPlaying)
                        {
                          setState(() {
                            this.isPlaying = false;
                            snake.reset();
                          }),
                        }
                      else
                        {
                          setState(() {
                            snake.reset();
                            this.isPlaying = true;
                            startGameLoop();
                          })
                        }
                    }),
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
    return this.snake.getScore();
  }

  void snakeGameRoutine(timer) {
    var actualPos = [apple, snake]
        //get active points from apple and snake (lists)
        .map((e) => e.activePoints())
        //flatten lists
        .expand((element) => element)
        //to list :V
        .toList();
    this.snake.updateSnake(actualPos);
    this.apple.updateApple(coordinateSpace, snake.activePoints());
  }

// void golSettingUp() {
//   var alivedots = [apple, snake]
//       //get active points from apple and snake (lists)
//       .map((e) => e.activePoints())
//       //flatten lists
//       .expand((element) => element)
//       //to list :V
//       .toList();
//
//   var aliveDotsNoDuplicates = alivedots.toSet().toList();
//
//   List<GolDot> aliveDots = aliveDotsNoDuplicates
//       .map((e) => GolDot(location: e, alive: true))
//       .toList();
//   List<GolDot> allDots = coordinateSpace
//       .outerJoin(aliveDotsNoDuplicates)
//       .map((e) => GolDot(location: e, alive: false))
//       .toList();
//   allDots.addAll(aliveDots);
//
//   this.gol.setDots(allDots);
// }
//
// void gameOfLifeRoutine(Timer timer) {
//   if (this.gameOverScreenOn) {
//     this.gol.update();
//     setState(() {
//       this.activePoints = this.gol.getDotsCopy().map((e) => e.dot);
//     });
//   } else {
//     print('aloha');
//     timer.cancel();
//     this.startGameLoop();
//   }
// }
}
