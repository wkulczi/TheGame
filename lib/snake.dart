import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coord-space.dart';
import 'direction.dart';

class Snake extends Equatable {
  List<Coord> snakeCoords;
  Direction snakeDirection;

  Snake({@required List<Coord> snakeLocation}) {
    this.snakeCoords = snakeLocation;
    this.snakeDirection = Direction.north;
  }

  updateSnakePos({@required List<Coord> snakeLocation}) {
    this.snakeCoords = snakeLocation;
  }

  moveSnake(){
    this.updateSnakePos(snakeLocation: this._calculateNewSnakePos(this.snakeCoords));
  }

  changeSnakeDirection({@required Direction newDirection}) {
    this.snakeDirection = newDirection;
  }

  getSnakePos() {
    return this.snakeCoords;
  }

  List<Coord> _calculateNewSnakePos(List<Coord> snakeLocation) {
    Coord newHead = snakeLocation.last;
    snakeLocation.removeAt(0);
    switch (this.snakeDirection) {
      case Direction.north:
        {
          newHead += Coord(x: 0, y: -1);
        }
        break;

      case Direction.east:
        {
          newHead += Coord(x: 1, y: 0);
        }
        break;

      case Direction.south:
        {
          newHead += Coord(x: 0, y: 1);
        }
        break;

      case Direction.west:
        {
          newHead += Coord(x: -1, y: 0);
        }
        break;
    }
    snakeLocation.add(newHead);
    return snakeLocation;
  }

  //not sure but should work
  bool isColliding() {
    this.snakeCoords.forEach((element) {
      var foundElements = this.snakeCoords.where((elem) => elem == element);
      if (foundElements.length > 1) {
        return true;
      }
    });
  }

  @override
  List<Object> get props => [this.snakeCoords];
}
