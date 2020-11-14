import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/classes/routing/route_generator.dart';
import 'package:flutter_app/views/gol_screen.dart';
import 'package:flutter_app/views/snake_screen.dart';

import 'classes/ads/ad_manager.dart';

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
  int queryno = 0;

  BannerAd _bannerAd;

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  void setUpBannerAd() {
    _bannerAd = BannerAd(adUnitId: AdManager.bannerAdUnitId, size: AdSize.banner, targetingInfo: MobileAdTargetingInfo(nonPersonalizedAds: true));
    _loadBannerAd();
  }

  @override
  void initState() {
    setUpBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

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
                style: TextStyle(color: Colors.white, decoration: TextDecoration.underline, fontSize: 30),
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
                          Navigator.pushNamed(context, SnakeScreen.routeName, arguments: snakeSpeed);
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
                        child: Text("Game Of L" + golSpeed.toString() + "fe", style: TextStyle(color: Colors.white, fontSize: 30)),
                        onTap: () {
                          Navigator.pushNamed(context, GolScreen.routeName, arguments: golSpeed);
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
                  InkWell(
                    onTap: () => {SystemNavigator.pop()},
                    child: Container(
                      child: Text("Exit", style: TextStyle(color: Colors.white, fontSize: 30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.black,
              child: FutureBuilder(
                future: _initAdMob(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error while initiating the ads",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // return Center();
                    return FutureBuilder(
                        future: _bannerAd.isLoaded(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (!snapshot.data) {
                              return Center(
                                child: InkWell(
                                    onTap: () => {
                                          setState(() {
                                            this._initAdMob().then((value) => {this._bannerAd?.dispose(), this.setUpBannerAd()});
                                          })
                                        },
                                    child: Text(
                                      "Reload ad",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    )),
                              );
                            }
                          }
                          return Container();
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
