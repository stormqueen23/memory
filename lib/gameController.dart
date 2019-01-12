import 'package:flutter/material.dart';

import 'board.dart';
import 'home.dart';
import 'summary.dart';

enum ScreenType { game, highscore }
enum MemoryType { first, second, third }

class GameController extends StatefulWidget {

  final int difficulty;

  GameController(this.difficulty, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GameState(difficulty);
  }

  static GameState of(BuildContext context) {
    final GameState navigator = context.ancestorStateOfType(
        const TypeMatcher<GameState>());

    assert(() {
      if (navigator == null) {
        throw new FlutterError(
            'Operation requested with a context that does '
                'not include a GameState.');
      }
      return true;
    }());

    return navigator;
  }
}

class GameState extends State<GameController> {
  ScreenType currentScreen = ScreenType.game;
  MemoryType currentMemoryType = MemoryType.first;

  int difficulty;

  int lastStars;
  int lastMoves;

  GameState(this.difficulty);

  @override
  Widget build(BuildContext context) {
    debugPrint('buildGameController' + currentScreen.toString());
    if (ScreenType.game == currentScreen) {
      return new Board(difficulty, currentMemoryType);
    } else {
      return new Summary(lastStars, lastMoves, getNextMemoryType() == null);
    }
  }

  void goToHomeScreen() {
    debugPrint('goToHomeScreen');
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => new HomeScreen()
        )
    );
  }

  void goToSummary(int stars, int moves) {
    debugPrint('goToSummary');
    lastStars = stars;
    lastMoves = moves;
    setState(() {
      currentScreen = ScreenType.highscore;
    });
  }

  void goToCurrentLevel() {
    setState(() {
      currentScreen = ScreenType.game;
    });
  }

  void goToNextLevel() {
    setState(() {
      currentScreen = ScreenType.game;
      currentMemoryType = getNextMemoryType();
    });
  }

  MemoryType getNextMemoryType() {
    if (currentMemoryType == MemoryType.first) {
      return MemoryType.second;
    } else if (currentMemoryType == MemoryType.second) {
      return MemoryType.third;
    }
    return null;
  }

}