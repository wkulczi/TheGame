import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/point.dart';
import 'dart:math';
import 'coord-space.dart';

class Apple extends Point {
  Coord location;
  Color appleColor;

  Apple({Color appleColor = Colors.red, @required maxCols, @required maxRows}) {
    this.location = Coord(x: 10, y: 10, maxX: maxCols, maxY: maxRows);
    this.appleColor = appleColor;
  }

  void updateApple(CoordinateSpace coordSpace, List<Coord> snakePos) {
    if (_isBeingEaten(snakePos)) {
      _setNewPos(generatePos(coordSpace, snakePos));
    }
  }

  void _setNewPos(Coord newPos) {
    this.location = newPos;
  }

  Coord generatePos(CoordinateSpace coordSpace, List<Coord> pointsOccupied) {
    List<int> pointsOccupiedRetardedValues = [];
    pointsOccupied.forEach((element) {
      pointsOccupiedRetardedValues.add(coordSpace.deconvert(coord: element));
    });
    var newpos = 0;
    Random rng = new Random();
    do {
      newpos = rng.nextInt(coordSpace.getMaxCols() * coordSpace.getMaxRows());
    } while (pointsOccupiedRetardedValues.contains(newpos));
    return coordSpace.convert(pos: newpos);
  }

  bool _isBeingEaten(List<Coord> snakepos) {
    return snakepos.contains(this.location);
  }

  @override
  Color getColor() {
    return this.appleColor;
  }

  @override
  bool isActive(Coord location) {
    return this.location == location;
  }

  @override
  List<Coord> activePoints() {
    return [this.location];
  }

  @override
  // TODO: implement props
  List<Object> get props => [this.location, this.appleColor];
}
