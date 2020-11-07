import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/coord-space.dart';
import 'package:flutter_app/point.dart';
import 'package:flutter_app/snake.dart';

import 'apple.dart';
import 'direction.dart';

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
  bool isPlaying = false;
  static int baseSpeed = 320;
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

  void startGameLoop(duration) {
    Timer.periodic(Duration(milliseconds: duration), (timer) {
      this.updateScreen(timer);
    });
  }

  void updateScreen(Timer timer) {
    setState(() {
      if (snake.alive() && this.isPlaying) {
        var actualPos = [apple, snake]
            //get active points from apple and snake (lists)
            .map((e) => e.activePoints())
            //flatten lists
            .expand((element) => element)
            //to list :V
            .toList();
        this.snake.updateSnake(actualPos);
        this.apple.updateApple(coordinateSpace, snake.activePoints());
        timer.cancel();
        startGameLoop(baseSpeed - (8 * getScore()));
      } else {
        this.isPlaying = false;
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
                child: Container(
                  child: GridView.builder(
                      //don't ask me why
                      itemCount: maxCols * maxRows,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: maxCols),
                      itemBuilder: (context, index) {
                        return this.conditionallyColoredRectangle(
                            isPointActive(index), getPointColor(index), index);
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
                            startGameLoop(baseSpeed);
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

  Widget conditionallyColoredRectangle(bool predicate, Color color, int index) {
    if (predicate) {
      return Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            color: color,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            color: color,
          ),
        ),
      );
    }
  }

  Color getPointColor(int index) {
    if (isPointActive(index)) {
      return activePoints
          .where((element) =>
              element.isActive(coordinateSpace.convert(pos: index)))
          .first
          .getColor();
    } else {
      return Colors.grey[900];
    }
  }

  bool isPointActive(int index) {
    return activePoints
        .any((point) => point.isActive(coordinateSpace.convert(pos: index)));
  }
}
