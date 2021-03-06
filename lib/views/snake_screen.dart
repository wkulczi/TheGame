import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/snake/snake.dart';
import 'package:flutter_app/views/widgets/snake_game_window.dart';

import '../classes/coordinate_system/coord_space.dart';
import '../classes/coordinate_system/point.dart';
import '../classes/snake/apple.dart';
import '../enums/direction.dart';

class SnakeScreen extends StatefulWidget {
  static const routeName = '/snakeScreen';

  final int speed;

  const SnakeScreen({Key key, this.speed}) : super(key: key);

  @override
  _SnakeScreenState createState() => _SnakeScreenState(speed);
}

class _SnakeScreenState extends State<SnakeScreen> {
  int score = 0;
  bool isPlaying = false;
  static int baseSpeed = 300;
  static int maxCols = 20;
  static int maxRows = 30;
  int snakeSpeedMultiplier;

  //coordinate space scales, to freely convert from int to Coord and back
  static CoordinateSpace coordinateSpace =
      new CoordinateSpace(elementsInRow: maxCols, elementsInColumn: maxRows);

  var apple = Apple(maxCols: maxCols, maxRows: maxRows);

  //a snake object to move around the guy
  var snake = Snake(maxCols: maxCols, maxRows: maxRows);

  List<Point> activePoints = [];

  _SnakeScreenState(int speed) {
    this.snakeSpeedMultiplier = speed;
  }

  @override
  void initState() {
    activePoints.add(snake);
    activePoints.add(apple);
    baseSpeed = baseSpeed - (10 * snakeSpeedMultiplier);
    super.initState();
  }

  Timer globalTimer;

  void startGameLoop() {
    Timer.periodic(Duration(milliseconds: baseSpeed), (timer) {
      globalTimer = timer;
      this.updateScreen(timer);
    });
  }

  @override
  void dispose() {
    globalTimer?.cancel();
    super.dispose();
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
            ),
            Expanded(
              flex: 1,
              child: Container(color: Colors.black,),
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

}
