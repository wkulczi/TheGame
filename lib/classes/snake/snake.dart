import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/coordinate_system/point.dart';

import '../../enums/direction.dart';
import '../coordinate_system/coord_space.dart';

class Snake extends Point {
  List<Coord> snakeCoords;
  Direction snakeDirection;
  Color snakeColor;
  bool isAlive;
  int maxCols;
  int maxRows;

  Snake({Color snakeColor = Colors.white, @required maxCols, @required int maxRows}) {
    this.maxCols = maxCols;
    this.maxRows = maxRows;
    this.snakeCoords = [
      Coord(x: 8, y: 24, maxX: this.maxCols, maxY: this.maxRows),
      Coord(x: 9, y: 24, maxX: this.maxCols, maxY: this.maxRows),
      Coord(x: 9, y: 23, maxX: this.maxCols, maxY: this.maxRows),
      Coord(x: 9, y: 22, maxX: this.maxCols, maxY: this.maxRows)
    ];
    this.snakeDirection = Direction.north;
    this.snakeColor = snakeColor;
    this.isAlive = true;
  }

  getDirection() {
    return snakeDirection;
  }

  int getScore(){
    return this.snakeCoords.length - 4;
  }

  void reset() {
    this.isAlive = true;
    this.snakeCoords = [
      Coord(x: 8, y: 24, maxX: this.maxCols, maxY: this.maxRows),
      Coord(x: 9, y: 24, maxX: this.maxCols, maxY: this.maxRows),
      Coord(x: 9, y: 23, maxX: this.maxCols, maxY: this.maxRows),
      Coord(x: 9, y: 22, maxX: this.maxCols, maxY: this.maxRows)
    ];
    this.snakeDirection = Direction.north;
  }

  updateSnakePos({@required List<Coord> snakeLocation}) {
    this.snakeCoords = snakeLocation;
  }

  updateSnake(List<Coord> activePoints) {
    if (!isHurtingItself()) {
      if (willBeEating(activePoints)) {
        eatApple();
      } else {
        moveSnake();
      }
    } else {
      this.isAlive = false;
    }
  }

  bool alive() {
    return this.isAlive;
  }

  void eatApple() {
    //move tail to new position
    var newSnakePos = this._calculateNewSnakePos(this.getSnakePosCopy());

    //add the tail back to snake
    newSnakePos.insert(0, this.getSnakePosCopy().first);

    this.updateSnakePos(snakeLocation: newSnakePos);
  }

  bool willBeEating(List<Coord> activePoints) {
    //activepoints - snakepoints = apple position
    activePoints.removeWhere((element) => getSnakePosCopy().contains(element));
    var futureSnakePos = _calculateNewSnakePos(getSnakePosCopy());
    if (activePoints.isNotEmpty) {
      return futureSnakePos.contains(activePoints.first);
    } else {
      return false;
    }
  }

  moveSnake() {
    this.updateSnakePos(
        snakeLocation: this._calculateNewSnakePos(this.getSnakePosCopy()));
  }

  changeDirection({@required Direction newDirection}) {
    this.snakeDirection = newDirection;
  }

  List<Coord> getSnakePosCopy() {
    return new List<Coord>.from(this.snakeCoords);
  }

  List<Coord> _calculateNewSnakePos(List<Coord> snakeLocation) {
    Coord newHead = snakeLocation.last;
    snakeLocation.removeAt(0);
    switch (this.snakeDirection) {
      case Direction.north:
        {
          newHead += Coord(x: 0, y: -1, maxX: this.maxCols, maxY: this.maxRows);
        }
        break;

      case Direction.east:
        {
          newHead += Coord(x: 1, y: 0, maxX: this.maxCols, maxY: this.maxRows);
        }
        break;

      case Direction.south:
        {
          newHead += Coord(x: 0, y: 1, maxX: this.maxCols, maxY: this.maxRows);
        }
        break;

      case Direction.west:
        {
          newHead += Coord(x: -1, y: 0, maxX: this.maxCols, maxY: this.maxRows);
        }
        break;
    }
    snakeLocation.add(newHead);
    return snakeLocation;
  }

  //not sure but should work
  bool isHurtingItself() {
    for (var value in this.getSnakePosCopy()) {
      var foundElements =
          this.getSnakePosCopy().where((element) => element == value).toList();
      if (foundElements.length > 1) {
        return true;
      }
    }
    return false;
  }

  @override
  Color getColor() {
    return this.snakeColor;
  }

  @override
  bool isActive(Coord location) {
    return this.getSnakePosCopy().contains(location);
  }

  @override
  List<Coord> activePoints() {
    return this.getSnakePosCopy();
  }

  @override
  // TODO: implement props
  List<Object> get props => [this.isAlive, this.maxRows, this.maxCols, this.snakeCoords, this.snakeDirection, this.snakeColor];
}
