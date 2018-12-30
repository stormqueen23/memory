import 'package:flutter/material.dart';
import 'board.dart';
import 'home.dart';

class Summary extends StatelessWidget {

  final int stars;
  final int points;
  final int difficulty;
  final MemoryType nextMemoryType;
  final MemoryType currentMemoryType;

  Summary(this.stars, this.points, this.difficulty, this.nextMemoryType, this.currentMemoryType, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Geschafft !', textScaleFactor: 1.5),

      ),
      body: Container(
          color: new Color(0xFFE3F2FD),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Icon(stars > 0 ? Icons.star : Icons.star_border, color: Colors.yellow, size: 100.0,)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new Icon(stars > 1 ? Icons.star : Icons.star_border, color: Colors.yellow, size: 100.0,)
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        new Icon(stars > 2 ? Icons.star : Icons.star_border, color: Colors.yellow, size: 100.0,)
                      ],
                    )
                  ],
                ),
                Text('Züge: ' + points.toString(), textScaleFactor: 3.0, style: TextStyle(color: Colors.grey),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.refresh, color: Colors.grey[600],),
                        iconSize: 70.0,
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                        onPressed: () {goToCurrentLevel(context);}
                    ),
                    IconButton(
                        icon: Icon(nextMemoryType != null ? Icons.fast_forward : Icons.home, color: Colors.grey[600],),
                        iconSize: 70.0,
                        padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                        onPressed: () {goToNextLevel(context);}
                    )
                  ],
                )

              ],
            )
          )
      ),
    );
  }

  void goToCurrentLevel(BuildContext context) {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => new Board(difficulty, currentMemoryType)
        )
    );
  }

  void goToNextLevel(BuildContext context) {
    if (nextMemoryType != null) {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new Board(difficulty, nextMemoryType)
          )
      );
    } else {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new HomeScreen()
          )
      );
    }
  }
}