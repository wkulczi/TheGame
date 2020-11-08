import 'package:flutter/material.dart';
import 'package:flutter_app/golScreen.dart';
import 'package:flutter_app/routeGenerator.dart';
import 'package:flutter_app/snakeScreen.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(fontFamily: 'UbuntuMono'),
      title: 'The Game',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

//https://resocoder.com/2019/04/27/flutter-routes-navigation-parameters-named-routes-ongenerateroute/

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int snakeSpeed = 3;
  int golSpeed = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "The game of Snake",
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontSize: 30),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: InkWell(
                          child: Text(
                            (snakeSpeed > 1 && snakeSpeed < 30) ? "-" : " ",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onTap: () {
                            if (snakeSpeed > 1 && snakeSpeed < 30) {
                              setState(() {
                                snakeSpeed -= 1;
                              });
                            }
                          },
                        ),
                      ),
                      InkWell(
                        child: Text(
                          "Snak" + snakeSpeed.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, SnakeScreen.routeName,
                              arguments:snakeSpeed);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: InkWell(
                          child: Text(
                            (snakeSpeed < 29 && snakeSpeed > 0) ? "+" : " ",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onTap: () {
                            if (snakeSpeed < 29 && snakeSpeed > 0) {
                              setState(() {
                                snakeSpeed += 1;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: InkWell(
                          child: Text(
                            (golSpeed > 1 && golSpeed < 30) ? "-" : " ",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onTap: () {
                            if (golSpeed > 1 && golSpeed < 30) {
                              setState(() {
                                golSpeed -= 1;
                              });
                            }
                          },
                        ),
                      ),
                      InkWell(
                        child: Text("Game Of L" + golSpeed.toString() + "fe",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        onTap: () {
                          print(golSpeed);
                          Navigator.pushNamed(context, GolScreen.routeName,
                              arguments: golSpeed);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: InkWell(
                          child: Text(
                            (golSpeed < 29 && golSpeed > 0) ? "+" : " ",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onTap: () {
                            if (golSpeed < 29 && golSpeed > 0) {
                              setState(() {
                                golSpeed += 1;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Text("Exit",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
