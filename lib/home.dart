import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'gameController.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/forest.png'), fit: BoxFit.fitHeight)
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "DINO",
                        textScaleFactor: 1.5,
                        style: getTitleTextStyle(),
                      ),
                      Text(
                        "MEMORY",
                        textScaleFactor: 1.5,
                        style: getTitleTextStyle(),
                      )
                    ],
                  )

              ),
              getButton(context, 1),
              getButton(context, 2),
              getButton(context, 3)
            ],
          )),
    );
  }

  Container getButton(BuildContext context, int diff) {
    Color color = diff == 1 ? Colors.green[200] : diff == 2 ? Colors.yellow[300] : Colors.red[300];
    String text = diff == 1 ? 'Leicht' : diff == 2 ? 'Mittel' : 'Schwer';
    return Container(
      width: 200.0,
      height: 60.0,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 60.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: color,
        child: Text(
          text,
          textScaleFactor: 2.0,
        ),
        onPressed: () {
          if (diff == 1) {
            setEasy(context);
          } else if (diff == 2) {
            setNormal(context);
          } else {
            setHard(context);
          }
        },
      ),
    );
  }

  TextStyle getTitleTextStyle() {
    TextStyle result = TextStyle(
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w500,
        fontFamily: 'Coiny',
        color: Colors.brown[800],
        letterSpacing: 1.5);
    return result;
  }

  void navigateTo(BuildContext context, int difficulty) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new GameController(difficulty)));
  }

  void setEasy(BuildContext context) {
    navigateTo(context, 1);
    //GameController.of(context).startGame(1);
  }

  void setNormal(BuildContext context) {
    // GameController.of(context).startGame(2);
    navigateTo(context, 2);
  }

  void setHard(BuildContext context) {
    //GameController.of(context).startGame(3);
    navigateTo(context, 3);
  }
}
