import 'package:flutter/material.dart';

import 'package:memory/gameController.dart';

enum TileState { found, open, covered }

final double margin = 4.0;

class MemoryCard extends StatelessWidget {
  final TileState tileState;
  final int value;

  final int posX;
  final int posY;

  final double size;

  //final MemoryType selectedMemoryType;

  MemoryCard({this.tileState,
    this.value,
    this.posX,
    this.posY,
    this.size});

  @override
  @override
  Widget build(BuildContext context) {
    Widget card;
    String pre = 'assets/dino-';
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
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.brown,
                ),
                color: Colors.white),
            child: new DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(imagePath), fit: BoxFit.scaleDown))));
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
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                        image: AssetImage(coveredImagePath),
                        fit: BoxFit.none))));
      } else {
        card = new Container(
            color: Colors.brown[400].withOpacity(0.95),
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