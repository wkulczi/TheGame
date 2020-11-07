import 'package:flutter_app/golDot.dart';

class GameOfLife {
  List<GolDot> dots= [];

  GameOfLife({List<GolDot> dots }) {
    this.dots = dots;
  }

  List<GolDot> getDotsCopy() {
    return new List<GolDot>.from(dots);
  }

  void setDots(List<GolDot>dots){
    this.dots = dots;
  }

  update() {
    List<GolDot> nextIterList = [];
    for (var dot in this.dots) {
      var aliveNeighbours = dot.countAliveNeighboursWithWrap(getAliveFromAll());
      nextIterList.add(GolDot(
          location: dot.dot,
          alive: this.applyGolRules(dot.isAlive, aliveNeighbours)));
    }
    this.dots = nextIterList;
  }

  List<GolDot> getAliveFromAll() {
    var dotsCopy = this.getDotsCopy();
    dotsCopy.removeWhere((element) => (!element.isAlive));
    return dotsCopy;
  }

  bool applyGolRules(bool isAlive, int aliveNeighbours) {
    if (isAlive && (aliveNeighbours > 1 && aliveNeighbours < 4)) {
      return true;
    } else if (!isAlive && aliveNeighbours == 3) {
      return true;
    } else {
      return false;
    }
  }
}
