import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

class CoordinateSpace {
  int _maxCols = 0;
  int _maxRows = 0;

  CoordinateSpace(
      {@required int elementsInRow, @required int elementsInColumn}) {
    this._maxCols = elementsInRow;
    this._maxRows = elementsInColumn;
  }

  ///Convert those dirty integers into readable format
  Coord convert({@required int pos}) {
    var xPos = pos % _maxCols;
    var yPos = (pos / _maxCols).floor();

    return Coord(x: xPos, y: yPos, maxX: this._maxCols, maxY: this._maxRows);
  }

  ///Deconvert readable objects into dirty integers
  int deconvert({@required Coord coord}) {
    return coord.getX() + coord.getY() * _maxCols;
  }

  int getMaxRows() {
    return _maxRows;
  }

  int getMaxCols() {
    return _maxCols;
  }
}

class Coord extends Equatable {
  int _x = 0;
  int _y = 0;
  int maxX = 0;
  int maxY = 0;

  Coord({@required x, @required y, @required maxX, @required maxY}) {
    this._x = x;
    this._y = y;
    this.maxX = maxX;
    this.maxY = maxY;
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

  @override
  String toString() {
    return "{x: " + this._x.toString() + ", y: " + this._y.toString() + "}";
  }

  @override
  List<Object> get props => [this._x, this._y];

  Coord operator +(Coord b) {
    return Coord(
        x: (this._x + b.getX() + this.maxX) % this.maxX,
        y: (this._y + b.getY() + this.maxY) % this.maxY, maxY: this.maxY, maxX: this.maxX);
  }

  Coord operator -(Coord b) {
    return Coord(
        y: (this._y - b.getY() + this.maxX) % this.maxY,
        x: (this._x - b.getX() + this.maxX) % this.maxX, maxX: this.maxX, maxY: this.maxY);
  }

  ///feed me list of active Dots, max number of rows and rows from CoordinateSpace instance
  int countNeighboursWithWrap(List<Coord> activeDots) {
    int aliveNeighbours = 0;

    List<Coord> neighbours = [
      Coord(maxX: this.maxX, maxY: this.maxY, x: (_x - 1 + this.maxX) %this.maxX, y: (_y + 1 + this.maxY) % this.maxY),
      Coord(maxX: this.maxX, maxY: this.maxY, x: (_x + 1 + this.maxX) %this.maxX, y: (_y + 1 + this.maxY) % this.maxY),
      Coord(maxX: this.maxX, maxY: this.maxY, x: (_x - 1 + this.maxX) %this.maxX, y: _y),
      Coord(maxX: this.maxX, maxY: this.maxY, x: (_x + 1 + this.maxX) %this.maxX, y: _y),
      Coord(maxX: this.maxX, maxY: this.maxY, x: (_x - 1 + this.maxX) %this.maxX, y: (_y - 1 + this.maxY) % this.maxY),
      Coord(maxX: this.maxX, maxY: this.maxY, x: (_x + 1 + this.maxX) %this.maxX, y: (_y - 1 + this.maxY) % this.maxY),
      Coord(maxX: this.maxX, maxY: this.maxY, x: _x, y: _y - 1),
      Coord(maxX: this.maxX, maxY: this.maxY, x: _x, y: _y + 1),
    ];

    print(activeDots);
    print(neighbours);

    activeDots.forEach((element) {
      if (neighbours.contains(element)) aliveNeighbours++;
    });

    return aliveNeighbours;
  }
}
