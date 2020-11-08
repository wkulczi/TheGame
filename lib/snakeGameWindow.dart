import 'package:flutter/cupertino.dart';
import 'package:flutter_app/coordSpace.dart';

import 'conditionallyColoredRect.dart';
import 'point.dart';

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