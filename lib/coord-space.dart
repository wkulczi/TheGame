import 'package:flutter/cupertino.dart';

class CoordinateSpace {
  int _maxCols = 0; //X value counting from left

  CoordinateSpace({@required int elementsInRow}) {
    this._maxCols = elementsInRow;
  }

  Coord convert({@required int pos}) {
    var xPos = pos % _maxCols;
    var yPos = (pos / _maxCols).floor();

    return Coord(x: xPos, y: yPos);
  }
}

class Coord {
  int _x = 0;
  int _y = 0;

  Coord({@required x, @required y}) {
    this._x = x;
    this._y = y;
  }

  bool checkCollision(Coord co2) {
    return this._x == co2.getX() && this._y == co2.getY();
  }

  int getX() {
    return this._x;
  }

  int getY() {
    return this._y;
  }
}
