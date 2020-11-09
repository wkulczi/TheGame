import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/coordinate_system/coord_space.dart';

import '../../classes/coordinate_system/point.dart';
import 'conditionally_colored_rect.dart';

Widget snakeGameWindow({@required int maxCols, @required int maxRows, @required List<
    Point> activePoints, @required CoordinateSpace coordinateSpace}) {
  return Container(
    child: GridView.builder(
      //don't ask me why
        itemCount: maxCols * maxRows,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: maxCols),
        itemBuilder: (context, index) {
          return conditionallyColoredRectangle(
              isPointActive(index, activePoints, coordinateSpace),
              getPointColor(index, activePoints, coordinateSpace));
        }),
  );
}