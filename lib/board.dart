import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:memory/bloc/preferencesService.dart';

import 'package:memory/gameController.dart';
import 'package:memory/boardUI.dart';
import 'package:memory/memory_timer.dart';

const int _timerMillis = 1500;
const int max_rounds = 3;


class Board extends StatefulWidget {
  final int currentGame;
  final GameData gameData;

  Board(this.currentGame, this.gameData, {Key key}) : super(key: key);

  @override
  BoardState createState() {
    return new BoardState();
  }

  static BoardState of(BuildContext context) {
    final BoardState navigator =
        context.ancestorStateOfType(const TypeMatcher<BoardState>());

    assert(() {
      if (navigator == null) {
        throw new FlutterError('Operation requested with a context that does '
            'not include a GameState.');
      }
      return true;
    }());

    return navigator;
  }
}

class BoardState extends State<Board> {
  //PreferencesService prefService;

  BoardState();

  double width;
  double height;

  int rows = 1;
  int cols = 2;

  Timer timer;

  int points = 0;
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

  MemoryTimer levelTimer;

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  AppBar getAppBar() {
    //bool showText = result.preferredSize.height > 55;
    AppBar result = doGetAppBar(true);
    debugPrint("appBarSize: " + result.preferredSize.toString());
    if (result.preferredSize.height < 56) {
      result = doGetAppBar(false);
      debugPrint("appBarSize: " + result.preferredSize.toString());
    }
    return result;
  }

  AppBar doGetAppBar(bool showDetails) {
    AppBar result = new AppBar(
      title: Column(
        children: getAppBarDetails(showDetails),
      ),
      centerTitle: true,
      backgroundColor: widget.gameData.getAppBarColor(),
    );
    return result;
  }

  List<Widget> getAppBarDetails(bool showDetailRow) {
    List<Widget> result = <Widget>[];
    if (widget.gameData.showTimer) {
      result.add(Center(child: levelTimer));
    } else {
      result.add(Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 15)));
    }
    if (showDetailRow) {
      Row row = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Punkte: $points', style: new TextStyle(fontSize: 20.0)),
            Text('Level: ${widget.currentGame+1} von ${widget.gameData.maxGames}', style: new TextStyle(fontSize: 20.0)),
            ]
      );

      result.add(row);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    double cardSize = determineCardSize();
    debugPrint('width: ' + width.toString());
    debugPrint('height: ' + height.toString());

    return new Scaffold(
        appBar: getAppBar(),
        body: new Container(
          child: buildBoardUI(cardSize),
        ));
  }

  double determineCardSize() {
    double result = 80.0;

    double spaceForHeight = height - ((rows * 2 * margin) + 180);
    double spaceForWidth = width - ((cols * 2 * margin) + 20);
    debugPrint('spaceForHeight ' + spaceForHeight.toString());
    debugPrint('spaceForWidth ' + spaceForWidth.toString());

    double heightPerCard = spaceForHeight / rows;
    double widthPerCard = spaceForWidth / cols;
    debugPrint('heightPerCard ' + heightPerCard.toString());
    debugPrint('widthPerCard ' + widthPerCard.toString());
    result = min(heightPerCard, widthPerCard);
    result = min(result, 200);
    debugPrint('cardSize:  ' + result.toString());
    return result;
  }

  Widget buildBoardUI(double cardSize) {
    debugPrint('buildBoard');

    List<Row> boardRow = <Row>[];
    for (int x = 0; x < rows; x++) {
      List<Widget> rowChildren = <Widget>[];
      for (int y = 0; y < cols; y++) {
        TileState state = uiState[x][y];
        if (state == TileState.covered) {
          rowChildren.add(
            GestureDetector(
              onTap: () {
                move(x, y);
              },
              child: Listener(
                child: MemoryCard(
                  tileState: state,
                  value: shuffeledNumbers.elementAt(tileValue[x][y] - 1),
                  //tileValue[x][y],
                  posX: x,
                  posY: y,
                  size: cardSize,
                  prefix: widget.gameData.getCardPrefix(),
                  cardColor: widget.gameData.getCardColor(),
                ),
              ),
            ),
          );
        } else {
          rowChildren.add(MemoryCard(
            tileState: state,
            value: shuffeledNumbers.elementAt(tileValue[x][y] - 1),
            //tileValue[x][y],
            posX: x,
            posY: y,
            size: cardSize,
            prefix: widget.gameData.getCardPrefix(),
            cardColor: widget.gameData.getCardColor(),
          ));
        }
      }
      boardRow.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey<int>(x),
      ));
    }
    Widget main = Container(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      //padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: boardRow,
      ),
    );
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(widget.gameData.getBackgroundImage()),
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.75), BlendMode.dstATop))),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: main,
        ));
  }

  void move(int x, int y) {
    setState(() {
      if (uiState[x][y] == TileState.covered && turnedCards < 2) {
        uiState[x][y] = TileState.open;
        turnedCards++;
        if (turnedCards == 1) {
          firstValue = tileValue[x][y];
          firstX = x;
          firstY = y;
        } else if (turnedCards == 2) {
          secondValue = tileValue[x][y];
          secondX = x;
          secondY = y;
        }
        debugPrint('first: ' + '$firstValue');
        debugPrint('second: ' + '$secondValue');
      }
    });
    debugPrint("cards turned: " + turnedCards.toString());
    if (turnedCards == 2) {
      timer = new Timer(const Duration(milliseconds: _timerMillis), () {
        setState(() {
          if (turnedCards == 2) {
            if (firstValue == secondValue) {
              uiState[firstX][firstY] = TileState.found;
              uiState[secondX][secondY] = TileState.found;
              points += 10;
            } else {
              uiState[firstX][firstY] = TileState.covered;
              uiState[secondX][secondY] = TileState.covered;
              if (points > 0) {
                points --;
              }
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
            for (int x = 0; x < rows; x++) {
              for (int y = 0; y < cols; y++) {
                //debugPrint('uiState[ ' + x.toString() + '][' + y.toString() + ']=' + (uiState[x][y]).toString());
                if (uiState[x][y] != TileState.found) {
                  allFound = false;
                }
              }
            }
            //debugPrint('allfound: ' + allFound.toString());
            if (allFound) {
              //int remaining = MemoryTimer.of(context).remainingTime;
              //points += remaining;
              goToSummary(context);
            }
          }
        });
      });
    }
  }

  void resetBoard() {
    debugPrint('resetBoard');
    int difficulty = widget.gameData.difficulty;
    debugPrint('difficulty: ' + difficulty.toString());
    if (difficulty == 1) {
      rows = 3;
      cols = 2;
      levelTimer = MemoryTimer(seconds: 30);
    } else if (difficulty == 2) {
      rows = 4;
      cols = 3;
      levelTimer = MemoryTimer(seconds: 90);
    } else if (difficulty == 3) {
      rows = 6;
      cols = 4;
      levelTimer = MemoryTimer(seconds: 180);
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
    double differentNumbers = (rows * cols) / 2;

    int counter = 0;
    int number = 1;
    shuffeledNumbers = new List<int>.generate(widget.gameData.maxCardsOfType(), (i) => i + 1);
    List<int> numbers;
    numbers = new List<int>.generate(fields, (entry) {
      if (counter > 0 && counter % 2 == 0) {
        number++;
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
        index = (row + col) + ((cols - 1) * row);
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
    GameController.of(context).goToSummary(stars, moves, points);
  }

  void goToFailSummary(BuildContext context) {
    debugPrint('goToFailSummary');
    GameController.of(context).goToFailSummary(0, moves, points);
  }

  int determineStars() {
    double cards = (rows * cols) / 2;
    double diff = (100 / cards) * (moves - cards);
    debugPrint('diff for stars: ' + diff.toString());
    if (widget.gameData.difficulty < 3) {
      if (diff >= 0 && diff < 81) {
        return 3;
      } else if (diff >= 81 && diff < 150) {
        return 2;
      } else if (diff >= 150 && diff < 250) {
        return 1;
      } else {
        return 0;
      }
    } else {
      if (diff >= 0 && diff < 95) {
        return 3;
      } else if (diff >= 95 && diff < 200) {
        return 2;
      } else if (diff >= 200 && diff < 320) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
