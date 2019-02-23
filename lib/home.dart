import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'gameController.dart';


enum DialogType {ok}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  Future<void> showInfo(BuildContext context) async {
    switch (await showDialog<DialogType>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: new Text('Infos'),
          titlePadding: EdgeInsets.fromLTRB(24.0, 20.0, 0.0, 20.0),
          contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 0.0, 0.0),
          children: <Widget>[
            Center(child: Text('Diese App wurde entwickelt von Melanie Siekmöller')),
            // Dinosaurier: designed by Freepik from Flaticon
            // Hintergrund: Graphics from pngtree.com
            SimpleDialogOption (
              onPressed: () {
                Navigator.pop(context);
              },
              child: IconButton(icon: Icon(Icons.check), onPressed: null)
            )
          ],
        );
      }
    )

    ) {
      case DialogType.ok:
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: AssetImage('assets/forest.png'),
                  fit: BoxFit.fitHeight)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                getInfoRow(context),
                getTitle(),
                // getLevelChange(),
                getButton(context, 1),
                getButton(context, 2),
                getButton(context, 3)
              ],
            ),
          )
      ),
    );
  }
  
  Padding getInfoRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 70.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              iconSize: 30.0,
              color: Colors.brown,
              onPressed: () {
                showInfo(context);
              }),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: IconButton(
                icon: Icon(Icons.info, color: Colors.white),
                iconSize: 30.0,
                onPressed: () {
                  showInfo(context);
                }),
          ),
        ],
      ),
    );
  }
  
  Container getTitle() {
    return Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                transform: Matrix4.identity()..setRotationZ(-0.0), //-0.15
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: Colors.brown, width: 5.0),
                    color: Colors.white),
                child: Text(
                  "MEMORY",
                  textScaleFactor: 3.1,
                  style: getTitleTextStyle(),
                ))
          ],
        ));
  }

  Container getLevelChange() {
    return Container(
      child: new Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_left,
                      color: Colors.brown[800],
                    ),
                    splashColor: Colors.brown,
                    iconSize: 100.0,
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    onPressed: () {}),
                color: Colors.amber,
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                "DINO"
                    "",
                textScaleFactor: 3.0,
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                  child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(70.0),
                          side:
                              BorderSide(width: 2.0, color: Colors.brown[200])),
                      child: Icon(
                        Icons.arrow_right,
                        color: Colors.brown[800],
                        size: 80.0,
                      ),
                      onPressed: () {})),
            ],
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Container getButton(BuildContext context, int diff) {
    Color color = diff == 1
        ? Colors.green[200]
        : diff == 2 ? Colors.yellow[300] : Colors.red[300];
    String text = diff == 1 ? 'Leicht' : diff == 2 ? 'Mittel' : 'Schwer';
    return Container(
      width: 200.0,
      height: 60.0,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: color,
        child: Text(
          text,
          textScaleFactor: 2.0,
          style: TextStyle(color: Colors.brown[800]),
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
