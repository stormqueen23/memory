import 'package:flutter/material.dart';


enum TileState { found, open, covered }

final double margin = 4.0;

class MemoryCard extends StatelessWidget {
  final TileState tileState;
  final int value;

  final int posX;
  final int posY;

  final double size;

  final String prefix;

  MemoryCard({this.tileState,
    this.value,
    this.posX,
    this.posY,
    this.size,
    this.prefix});

  @override
  Widget build(BuildContext context) {
    Widget card;
    String pre = prefix;
    String imagePath;
    String coveredImagePath;

    if (pre != null) {
      //coveredImagePath = pre + 'back.png';
      imagePath = pre + value.toString() + '.png';
    }

    if (tileState == TileState.open) {
      if (imagePath != null) {
        card = new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: Colors.indigo,
                ),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: new DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imagePath), fit: BoxFit.scaleDown))),
            ));
      } else {
        card = new Container(
            color: Colors.white,
            child: new Center(
              child: new Text(
                value.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 2.0,
              ),
            ));
      }
    } else if (tileState == TileState.found) {
      card = new Container(
        //remove
      );
    } else if (tileState == TileState.covered) {
      if (coveredImagePath != null) {
        card = new Container(
            color: Colors.grey,
            child: new DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        image: AssetImage(coveredImagePath),
                        fit: BoxFit.none)
                )
            )
        );
      } else {
        card = new Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.orange[300].withOpacity(0.95), //for dino
            ),
            child: new Center(
              child: new Text(
                '?',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textScaleFactor: 2.5,
              ),
            ));
      }
    }
    Widget outer = Container(
      margin: EdgeInsets.all(margin),
      height: size,
      width: size,
      child: card,
    );

    return outer;
  }
}