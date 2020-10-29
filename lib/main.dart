import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: GameScreen(), routes: <String, WidgetBuilder>{
    '/game': (BuildContext context) => GameScreen(),
  }));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text("Nic tu nie ma."),
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake',
      home: GameScreenState(),
    );
  }
}

class GameScreenState extends StatefulWidget {
  GameScreenState({Key key}) : super(key: key);

  @override
  _GameScreenStateState createState() => _GameScreenStateState();
}

class _GameScreenStateState extends State<GameScreenState> {
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 9,
              child: Container(
                child: GridView.builder(
                    //don't ask me why
                    itemCount: 660,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }),
              )),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "Score: " + getScore().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                InkWell(
                  child: Container(
                    child: Text(
                      "Exit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () => ({
                    setState(() => score++)
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int getScore(){
    return this.score;
  }
}
