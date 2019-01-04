import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

import 'package:memory/gameController.dart';

const int _timerMillis = 1500;
const int max_rounds = 3;
const int maxCards = 6;

enum TileState {found, open, covered}

class Board extends StatefulWidget {
  final int difficulty;
  final MemoryType type;

  Board(this.difficulty, this.type, {Key key}) : super(key: key);

  @override
  BoardState createState() {
    return new BoardState(difficulty, type); }
}

class BoardState extends State<Board> {
  final int difficulty;
  final MemoryType selectedMemoryType;

  BoardState(this.difficulty, this.selectedMemoryType);

  int rows = 1;
  int cols = 2;

  Timer timer;

  int moves = 0;
  int minMoveCounter = 0;

  int turnedCards = 0;

  int firstValue;
  int firstX;
  int firstY;

  int secondValue;
  int secondX;
  int secondY;


  List<List<TileState>> uiState;
  List<List<int>> tileValue;

  List<int> shuffeledNumbers;

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('$moves', style: new TextStyle(fontSize: 30.0),),
          centerTitle: true,
        ),
        body: new Container(
          color: Colors.blue,
          child: buildBoardUI(),
        )
    );
  }

  Widget buildBoardUI() {
    debugPrint('buildBoard');
    List<Row> boardRow = <Row>[];
    for (int x = 0 ; x < rows; x++) {
      List<Widget> rowChildren = <Widget>[];
      for (int y = 0; y < cols; y++) {
        TileState state = uiState[x][y];
        if (state == TileState.covered || state == TileState.open) {
          rowChildren.add(GestureDetector(
            onTap: () {
              move(x,y);
            },
            child: Listener(
              child: MemoryCard(
                tileState: state,
                value: shuffeledNumbers.elementAt(tileValue[x][y]-1), //tileValue[x][y],
                posX: x,
                posY: y,
                selectedMemoryType: selectedMemoryType,
              ),
            ),
          ),
          );
        } else {
          rowChildren.add(
              MemoryCard(
                tileState: state,
                value: shuffeledNumbers.elementAt(tileValue[x][y]-1), //tileValue[x][y],
                posX: x,
                posY: y,
                selectedMemoryType: selectedMemoryType,
              )
          );
        }
      }
      boardRow.add(Row (
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey<int>(x),
      ));
    }
    Widget main = Container(
      color: new Color(0xFFE3F2FD),
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      //padding: EdgeInsets.all(10.0),
      child: Column(
        children: boardRow,
      ),
    );
    return Container(
        color: new Color(0xFFE3F2FD),
        padding: EdgeInsets.all(10.0),
        child: Column(
            children: <Widget>[
              main
              //RaisedButton (
              //  child: Text ('Neues Spiel'),
              //onPressed: _resetGame
              //),
            ]
        )
    );
  }

  Widget buildOpenMemoryCard(Widget child) {
    return Container(
      margin: EdgeInsets.all(4.0),
      height: 100.0,
      width: 100.0,
      color: Colors.grey,
      child: child,
    );
  }

  Widget buildCoveredMemoryCard(Widget child) {
    return Container(
      margin: EdgeInsets.all(4.0),
      height: 100.0,
      width: 100.0,
      color: Colors.grey,
      child: child,
    );
  }

  void move(int x, int y) {
    setState(() {
      if (uiState[x][y] == TileState.covered && turnedCards < 2) {
        uiState[x][y] = TileState.open;
        turnedCards ++;
        if (turnedCards == 1) {
          firstValue = tileValue[x][y];
          firstX = x;
          firstY = y;
        } else if (turnedCards == 2) {
          secondValue = tileValue[x][y];
          secondX = x;
          secondY = y;
        }
        //debugPrint('first: ' + '$firstValue');
        //debugPrint('second: ' + '$secondValue');
      }
    });
    if (turnedCards == 2) {
      timer = new Timer(const Duration(milliseconds: _timerMillis), () {
        setState(() {
          if (turnedCards == 2) {
            if (firstValue == secondValue) {
              uiState[firstX][firstY] = TileState.found;
              uiState[secondX][secondY] = TileState.found;
            } else {
              uiState[firstX][firstY] = TileState.covered;
              uiState[secondX][secondY] = TileState.covered;
            }
            moves++;
            firstValue = null;
            firstX = null;
            firstY = null;
            secondValue = null;
            secondX = null;
            secondY = null;
            turnedCards = 0;

            bool allFound = true;
            for (int x = 0 ; x < rows; x++) {
              for (int y = 0; y < cols; y++) {
                //debugPrint('uiState[ ' + x.toString() + '][' + y.toString() + ']=' + (uiState[x][y]).toString());
                if (uiState[x][y] != TileState.found) {
                  allFound = false;
                }
              }
            }
            //debugPrint('allfound: ' + allFound.toString());
            if (allFound) {
              goToSummary(context);
            }
          }
        });
      });
    }

  }

  void resetBoard() {
    debugPrint('resetBoard');
    debugPrint('difficulty: ' + difficulty.toString());
    if (difficulty == 1) {
      rows = 3;
      cols = 2;
    } else if (difficulty == 2) {
      rows = 4;
      cols = 3;
    }
    turnedCards = 0;
    moves = 0;
    firstValue = null;
    firstX = null;
    firstY = null;
    secondValue = null;
    secondX = null;
    secondY = null;

    int fields = rows * cols;
    double differentNumbers = (rows*cols)/2;

    int counter = 0;
    int number = 1;
    shuffeledNumbers = new List<int>.generate(maxCards, (i) => i + 1);
    List<int> numbers;
    numbers = new List<int>.generate(fields, (entry) {
      if (counter > 0 && counter % 2 == 0) {
        number ++;
      }
      counter++;
      return number;
    });

    debugPrint(shuffeledNumbers.toString());
    shuffeledNumbers.shuffle();
    debugPrint(shuffeledNumbers.toString());
    shuffeledNumbers = shuffeledNumbers.sublist(0, differentNumbers.round());
    debugPrint(shuffeledNumbers.toString());

    debugPrint(numbers.toString());
    numbers.shuffle();
    debugPrint(numbers.toString());
    uiState = new List<List<TileState>>.generate(rows, (row) {
      return new List<TileState>.filled(cols, TileState.covered);
    });
    tileValue = new List<List<int>>.generate(rows, (row) {
      return new List<int>.generate(cols, (col) {
        int index;
        index = (row+col) + ((cols-1)*row);
        debugPrint(index.toString());
        //print(col);
        return numbers[index];
      });
    });
    debugPrint(tileValue.toString());
  }



  void goToSummary(BuildContext context) {
    debugPrint('goToSummary');
    int stars = determineStars();
    GameController.of(context).goToSummary(stars, moves);
  }

  int determineStars() {
    double cards = (rows*cols)/2;
    double diff = (100/cards)*(moves-cards);
    debugPrint('diff for stars: ' + diff.toString());
    if (diff >= 0 && diff < 81) {
      return 3;
    } else if (diff >= 81 && diff < 150) {
      return 2;
    } else if (diff >= 150 && diff < 250) {
      return 1;
    } else {
      return 0;
    }
  }
}

class MemoryCard extends StatelessWidget {
  final TileState tileState;
  final int value;

  final int posX;
  final int posY;

  final MemoryType selectedMemoryType;

  MemoryCard(
      {this.tileState, this.value, this.posX, this.posY, this.selectedMemoryType});

  @override
  @override
  Widget build(BuildContext context) {
    Widget card;
    String pre;
    String imagePath;
    String coveredImagePath;

    if (selectedMemoryType == MemoryType.number) {
      //no images yet
    } else if (selectedMemoryType == MemoryType.pokemon) {
      pre = 'graphics/p-';
    } else if (selectedMemoryType == MemoryType.pawpatrol) {
      pre = 'graphics/pp-';
    }
    if (pre != null) {
      coveredImagePath = pre + 'back.png';
      imagePath = pre + value.toString() + '.png';
    }

    if (tileState == TileState.open || tileState == TileState.found) {
      if (imagePath != null) {
        card = new Container(
            color: tileState == TileState.open ? Colors.black12 : Colors.white,
            child: new DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.scaleDown
                    )
                )
            ));
      } else {
        card = new Container(
            color: tileState == TileState.open ? Colors.black12 : Colors.white,
            child: new Center (
              child: new Text(value.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 2.0,),
            )
        );
      }
    } else if (tileState == TileState.covered) {
      if (coveredImagePath != null) {
        card = new Container(
            color: Colors.black45,
            child: new DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(coveredImagePath),
                        fit: BoxFit.none
                    )
                )
            ));
      } else {
        card = new Container(
            color: Colors.black45,
            child: new Center (
              child: new Text('',
                style: TextStyle(fontWeight: FontWeight.bold),),
            )
        );
      }
    }
    Widget outer = Container(
      margin: EdgeInsets.all(4.0),
      height: 90.0,
      width: 90.0,
      child: card,
    );

    return outer;
  }
}