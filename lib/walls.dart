import 'package:flutter/cupertino.dart';

class Walls {

  int _maxCols = 0;
  int _maxRows = 0;

  Walls({@required elemsInRow, @required totalElems}){
    this._maxCols = elemsInRow;
    this._maxRows = (totalElems/elemsInRow).floor();
  }

//  prolly walls should have coords notation system
// na razie nie robie, bez sensu chyba
}