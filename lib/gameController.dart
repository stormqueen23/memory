import 'package:flutter/material.dart';

import 'board.dart';
import 'home.dart';
import 'summary.dart';

enum ScreenType { game, highscore, failScore, allHighScore }
//enum MemoryType { first, second, third }

class GameController extends StatefulWidget {

  final int difficulty;

   GameController(this.difficulty, {Key key}) : super(key: key);

  @override
  State<GameController> createState() {
    return new GameState(difficulty, 3);
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
  final int difficulty;
  final int maxGames;

  ScreenType currentScreen = ScreenType.game;

  int gameCounter = 0;

  int pointSum = 0;
  int starSum = 0;
  int moveSum = 0;

  int lastStars = 0;
  int lastMoves = 0;
  int lastPoints = 0;

  GameState(this.difficulty, this.maxGames);

  @override
  Widget build(BuildContext context) {
    debugPrint('buildGameController' + currentScreen.toString());
    if (ScreenType.game == currentScreen) {
      return new Board(difficulty);
    } else if (ScreenType.failScore == currentScreen) {
      return new Summary(true, lastStars, lastMoves, lastPoints, isLastLevel(), false);
    } else if (ScreenType.allHighScore == currentScreen) {
      int tmpStars = (starSum / maxGames).round();
      return new Summary(false, tmpStars, moveSum, pointSum, true, true);
    } else {
      return new Summary(false, lastStars, lastMoves, lastPoints, isLastLevel(), false);
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

  void goToAllSummary() {
    debugPrint('goToAllSummary');
   setState(() {
      currentScreen = ScreenType.allHighScore;
    });
  }

  void goToSummary(int stars, int moves, int points) {
    debugPrint('goToSummary');
    lastStars = stars;
    lastMoves = moves;
    lastPoints = points;
    pointSum += points;
    moveSum += moves;
    starSum += stars;
    setState(() {
      currentScreen = ScreenType.highscore;
    });
  }

  void goToFailSummary(int stars, int moves, int points) {
    debugPrint('goToFailSummary');
    lastStars = stars;
    lastMoves = moves;
    lastPoints = points;
    pointSum += points;
    moveSum += moves;
    starSum += stars;
    setState(() {
      currentScreen = ScreenType.failScore;
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
      gameCounter++;
    });
  }

  bool isLastLevel() {
    return (gameCounter < (maxGames-1) ? false : true);
  }

}