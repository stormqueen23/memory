import 'package:flutter/material.dart';

import 'gameController.dart';

class Summary extends StatelessWidget {
  final int stars;
  final int moves;
  final int points;
  final bool isLastLevel;
  final bool failed;
  final bool allSummary;
  final String backgroundImage;
  final Color appBarColor;

  Summary(this.failed, this.stars, this.moves, this.points, this.isLastLevel, this.allSummary, this.backgroundImage, this.appBarColor,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(failed ? 'Verloren!' : allSummary ? 'Insgesamt' : 'Geschafft !', textScaleFactor: 1.5),
        backgroundColor: appBarColor,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.75), BlendMode.dstATop))),
        child: Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Icon(
                        stars > 0 ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                        size: 100.0,
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      new Icon(
                        stars > 1 ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                        size: 100.0,
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      new Icon(
                        stars > 2 ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                        size: 100.0,
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                child: Text(
                  'Punkte: ' + (points != 0 ? points.toString() : '0'),
                  textScaleFactor: 3.0,
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 !isLastLevel ? IconButton(
                          icon: Icon(
                            Icons.home,
                            color: Colors.black,
                          ),
                          iconSize: 70.0,
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 30.0, 0.0),
                          onPressed: () {
                            goToHome(context);
                          }) : new Text('')
                      ,
                  IconButton(
                      icon: Icon(
                        !isLastLevel ? Icons.fast_forward : !allSummary ? Icons.format_list_numbered : Icons.home,
                        color: Colors.black,
                      ),
                      iconSize: 70.0,
                      padding: EdgeInsets.fromLTRB(!isLastLevel ? 30.0 : 0.0, !isLastLevel ? 10.0 : 20.0, 0.0, 0.0),
                      onPressed: () {
                        !isLastLevel
                            ? goToNextLevel(context)
                            : !allSummary ? goToAllSummary(context) : goToHome(context);
                      })
                ],
              )
            ],

          ),
        )),
      ),
    );
  }

  void goToCurrentLevel(BuildContext context) {
    GameController.of(context).goToCurrentLevel();
  }

  void goToAllSummary(BuildContext context) {
    GameController.of(context).goToAllSummary();
  }

  void goToHome(BuildContext context) {
    GameController.of(context).goToHomeScreen();
  }

  void goToNextLevel(BuildContext context) {
    if (isLastLevel) {
      GameController.of(context).goToHomeScreen();
    } else {
      GameController.of(context).goToNextLevel();
    }
  }
}
