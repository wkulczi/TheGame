import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/coordinate_system/coord_space.dart';
import 'package:flutter_app/classes/coordinate_system/point.dart';

class GolDot extends Point {
  Coord dot;
  bool isAlive;

  GolDot({@required Coord location, bool alive = false}) {
    this.dot = location;
    this.isAlive = alive;
  }

  @override
  List<Coord> activePoints() {
    return isAlive ? [dot] : [];
  }

  void kill(){
    this.isAlive=false;
  }

  void create(){
    this.isAlive=true;
  }

  @override
  Color getColor() {
    if (this.isAlive) {
      return Colors.white;
    } else {
      return Colors.grey[900];
    }
  }

  @override
  bool isActive(Coord location) {
    return location == this.dot;
  }

  int countAliveNeighboursWithWrap(List<GolDot> activeDots) {
    int aliveNeighbours = 0;

    List<GolDot> neighbours = [
      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: (this.dot.getX() - 1 + this.dot.maxX) %this.dot.maxX, y: (this.dot.getY() + 1 + this.dot.maxY) % this.dot.maxY)),
      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: (this.dot.getX() + 1 + this.dot.maxX) %this.dot.maxX, y: (this.dot.getY() + 1 + this.dot.maxY) % this.dot.maxY)),

      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: (this.dot.getX() - 1 + this.dot.maxX) %this.dot.maxX, y: this.dot.getY())),
      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: (this.dot.getX() + 1 + this.dot.maxX) %this.dot.maxX, y: this.dot.getY())),

      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: (this.dot.getX() - 1 + this.dot.maxX) %this.dot.maxX, y: (this.dot.getY() - 1 + this.dot.maxY) % this.dot.maxY)),
      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: (this.dot.getX() + 1 + this.dot.maxX) %this.dot.maxX, y: (this.dot.getY() - 1 + this.dot.maxY) % this.dot.maxY)),

      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: this.dot.getX(), y: (this.dot.getY() - 1 + this.dot.maxY)%this.dot.maxY )),
      GolDot(alive:true, location: Coord(maxX: this.dot.maxX, maxY: this.dot.maxY, x: this.dot.getX(), y: (this.dot.getY() + 1+ this.dot.maxY) %this.dot.maxY))
    ];

    activeDots.forEach((element) {
      if (neighbours.contains(element)) aliveNeighbours++;
    });

    return aliveNeighbours;
  }

  @override
  // TODO: implement props
  List<Object> get props => [this.isAlive, this.dot];
}
