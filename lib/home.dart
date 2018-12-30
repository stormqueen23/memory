import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'board.dart';


class HomeScreen extends StatelessWidget {

  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: new Color(0xFFE3F2FD),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              width: 200.0,
              height: 60.0,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 60.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green[200],
                child: Text("Leicht", textScaleFactor: 2.0,),
                onPressed: () {setEasy(context);},
              ),
            ),
            Container (
              width: 200.0,
              height: 60.0,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 60.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.yellow[300],
                child: Text("Mittel", textScaleFactor: 2.0,),
                onPressed: () {setNormal(context);},
              ),
            ),
            Container (
              width: 200.0,
              height: 60.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.red[300],
                child: Text("Schwer", textScaleFactor: 2.0,),
                onPressed: () {setHard(context);},
              ),
            )
          ],
        )
      ),
    );

  }

  void navigateTo(BuildContext context, int difficulty) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new Board(difficulty, MemoryType.pawpatrol)
        )
    );
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

}

