import 'dart:ui';

import 'coord-space.dart';

abstract class Point {

  Color getColor();

  bool isActive(Coord location);

  List<Coord> activePoints();
}