import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../gameController.dart';
import '../homeController.dart';
import '../service/preferencesService.dart';

enum DialogType { ok }


class HomeWidget extends StatefulWidget {
  final PreferencesService prefService;

  HomeWidget(this.prefService);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  void navigateTo(BuildContext context, int difficulty) {
    int maxGames = widget.prefService.maxGames;
    bool showTimer = widget.prefService.timerOn;

    GameData data = new GameData(difficulty, maxGames, showTimer, widget.prefService.type);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new GameController(gameData: data, prefService: widget.prefService)));
  }

  void setEasy(BuildContext context) {
    navigateTo(context, 1);
  }

  void setNormal(BuildContext context) {
    navigateTo(context, 2);
  }

  void setHard(BuildContext context) {
    navigateTo(context, 3);
  }

  @override
  Widget build(BuildContext context) {
   Widget home = Column(
        children: <Widget>[
          getInfoRow(context),
          getTitle(),
          getLevelChange(),
          getButton(context, 1),
          getButton(context, 2),
          getButton(context, 3)
        ],
      );
    return home;
  }

  Padding getInfoRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              iconSize: 30.0,
              color: Colors.black,
              onPressed: () {
                showSettings(context);
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
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                transform: Matrix4.identity()..setRotationZ(-0.0), //-0.15
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: Colors.black, width: 5.0),
                    color: Colors.white),
                child: Text(
                  FlutterI18n.translate(context, "title"),
                  textScaleFactor: 3.1,
                  style: getTitleTextStyle(),
                ))
          ],
        ));
  }

  Container getLevelChange() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 40),
      child: new Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              getChangeSkin(false),
            ],
          ),

          Column(
            children: <Widget>[
              getChangeSkin(true),
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
    String text = diff == 1 ? FlutterI18n.translate(context, "easy") : diff == 2 ? FlutterI18n.translate(context, "normal") : FlutterI18n.translate(context, "hard");
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
          style: TextStyle(color: Colors.black),
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
        color: Colors.black,
        letterSpacing: 1.5);
    return result;
  }

  Future<void> showInfo(BuildContext context) async {
    switch (await showDialog<DialogType>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: new Text(FlutterI18n.translate(context, "infoDialog"),),
            titlePadding: EdgeInsets.fromLTRB(24.0, 20.0, 0.0, 20.0),
            contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 0.0, 0.0),
            children: <Widget>[
              Center(
                  child: Text(
                    FlutterI18n.translate(context, "infoContent"),)),
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: IconButton(icon: Icon(Icons.check), onPressed: null))
            ],
          );
        })) {
      case DialogType.ok:
        break;
    }
  }

  Container getChangeSkin(bool rightWay) {
    return Container(
        child: RaisedButton(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(70.0),
                side:
                BorderSide(width: 2.0, color: Colors.brown[200])),
            child: Icon(
              rightWay ? Icons.arrow_right : Icons.arrow_left,
              color: Colors.black,
              size: 80.0,
            ),
            onPressed: () {
              HomeScreen.of(context).setState(() {
                widget.prefService.changeSkin(rightWay);
              });
            })
    );
  }

  void showSettings(BuildContext context) {
    HomeScreen.of(context).setDisplayTypePrefs();
  }
}