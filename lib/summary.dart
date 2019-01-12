import 'package:flutter/material.dart';

import 'gameController.dart';

class Summary extends StatelessWidget {
  final int stars;
  final int points;
  final bool isLastLevel;

  Summary(this.stars, this.points, this.isLastLevel, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Geschafft !', textScaleFactor: 1.5),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/forest.png'),
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
                  Text(
                    'Züge: ' + points.toString(),
                    textScaleFactor: 3.0,
                    style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.home,
                            color: Colors.brown,
                          ),
                          iconSize: 70.0,
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                          onPressed: () {
                            goToHome(context);
                          }),
                      IconButton(
                          icon: Icon(
                            !isLastLevel ? Icons.fast_forward : Icons.home,
                            color: Colors.brown,
                          ),
                          iconSize: 70.0,
                          padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                          onPressed: () {
                            goToNextLevel(context);
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
