import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'coord_space.dart';

abstract class Point extends Equatable {

  Color getColor();

  bool isActive(Coord location);

  List<Coord> activePoints();
}