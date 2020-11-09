import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/coordinate_system/coord_space.dart';
import '../../classes/coordinate_system/point.dart';

Widget conditionallyColoredRectangle(bool predicate, Color color) {
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

Color getPointColor(
    int index, List<Point> activePoints, CoordinateSpace coordinateSpace) {
  if (isPointActive(index, activePoints, coordinateSpace)) {
    return activePoints
        .where((element) =>
        element.isActive(coordinateSpace.convert(pos: index)))
        .first
        .getColor();
  } else {
    return Colors.grey[900];
  }
}

bool isPointActive(
    int index, List<Point> activePoints, CoordinateSpace coordinateSpace) {
  return activePoints
      .any((point) => point.isActive(coordinateSpace.convert(pos: index)));
}