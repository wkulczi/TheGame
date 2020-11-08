import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/coordSpace.dart';
import 'package:flutter_app/gameOfLife.dart';

import 'golDot.dart';

class GolScreen extends StatefulWidget {
  @override
  _GolScreenState createState() => _GolScreenState();
}

class _GolScreenState extends State<GolScreen> {
  static int maxCols = 20;
  static int baseSpeed = 300;
  static int maxRows = 30;
  bool isRunning = false;
  static CoordinateSpace coordinateSpace =
      new CoordinateSpace(elementsInRow: maxCols, elementsInColumn: maxRows);
  GameOfLife gol = GameOfLife();

  @override
  void initState() {
    gol.setDots(this.fillWithEmtpy(coordinateSpace));
    super.initState();
  }

  void gameLoopStart() {
    Timer.periodic(Duration(milliseconds: baseSpeed), (timer) {
      this.updateScreen(timer);
    });
  }

  void updateScreen(Timer timer) {
    if (isRunning) {
      setState(() {
        gol.update();
      });
    } else {
      timer.cancel();
    }
  }

  void step() {
    gol.update();
  }

  void reset() {
    gol.dots = fillWithEmtpy(coordinateSpace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 12,
              child: gameOfLifeWindow(),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: InkWell(
                      child: Text(
                        isRunning ? "" : "Clear",
                        style: TextStyle(color:Colors.white),
                      ),
                      onTap: () => {
                        if (!isRunning){
                          setState((){
                            reset();
                          })
                        }
                      },
                    ),
                  ),Container(
                    child: InkWell(
                      child: Text(
                        isRunning ? "" : "Step",
                        style: TextStyle(color:Colors.white),
                      ),
                      onTap: () => {
                        if (!isRunning){
                          setState((){
                            step();
                          })
                        }
                      },
                    ),
                  ),
                  Container(
                    child: InkWell(
                      child: Text(
                        isRunning ? "Stop" : "Start",
                        style: TextStyle(color:Colors.white),
                      ),
                      onTap: () => {
                        setState(() {
                          if (isRunning) {
                            isRunning = false;
                          }else{
                            isRunning = true;
                            gameLoopStart();
                          }
                        })
                      },
                    ),
                  ),

                ],
              ),
            )
          ],
        ));
  }

  Widget gameOfLifeWindow() {
    return Container(
      child: GridView.builder(
        itemCount: maxCols * maxRows,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: maxCols),
        itemBuilder: (context, index) {
          return golCell(index, isCellAlive(index));
        },
      ),
    );
  }

  Widget golCell(int index, bool isAlive) {
    if (isAlive) {
      return InkWell(
        child: Container(
          padding: EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        onTap: () => {
          setState(() {
            findAndChangeState(index, coordinateSpace);
          }),
        },
      );
    } else {
      return InkWell(
        child: Container(
          padding: EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              color: Colors.grey[900],
            ),
          ),
        ),
        onTap: () => {
          setState(() {
            findAndChangeState(index, coordinateSpace);
          }),
        },
      );
    }
  }

  void findAndChangeState(int index, CoordinateSpace coordinateSpace) {
    var dotsCopy = gol.getDotsCopy();
    if (gol
        .getDotsCopy()[dotsCopy.indexOf(dotsCopy
            .where(
                (element) => element.dot == coordinateSpace.convert(pos: index))
            .first)]
        .isAlive) {
      gol.dots[gol.dots.indexOf(gol.dots
              .where((element) =>
                  element.dot == coordinateSpace.convert(pos: index))
              .first)]
          .kill();
    } else {
      gol.dots[gol.dots.indexOf(gol.dots
              .where((element) =>
                  element.dot == coordinateSpace.convert(pos: index))
              .first)]
          .create();
    }
  }

  List<GolDot> fillWithEmtpy(CoordinateSpace coordinateSpace) {
    List<int> dotsAsInts = new List<int>.generate(
        coordinateSpace.getMaxRows() * coordinateSpace.getMaxCols(),
        (index) => index);
    List<GolDot> dotsAsGolDots = [];
    dotsAsInts.forEach((element) {
      dotsAsGolDots
          .add(GolDot(location: coordinateSpace.convert(pos: element)));
    });
    return dotsAsGolDots;
  }

  bool isCellAlive(int index) {
    return gol
        .getDotsCopy()
        .where(
            (element) => coordinateSpace.deconvert(coord: element.dot) == index)
        .first
        .isAlive;
  }
}
