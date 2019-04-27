import 'package:flutter/material.dart';

import 'package:memory/service/preferencesService.dart';
import 'board.dart';
import 'homeController.dart';
import 'summary.dart';

enum ScreenType { game, highscore, failScore, allHighScore }


class GameController extends StatefulWidget {

  final GameData gameData;
  final PreferencesService prefService;

   GameController({this.gameData, this.prefService});

  @override
  State<GameController> createState() {
    return new GameState();
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

  int gameCounter = 0;

  int pointSum = 0;
  int starSum = 0;
  int moveSum = 0;

  int lastStars = 0;
  int lastMoves = 0;
  int lastPoints = 0;

  GameState();

  @override
  void initState() {
    super.initState();
    debugPrint("initState");
    debugPrint("maxGames = " + widget.gameData.maxGames.toString());
    debugPrint("difficulty = " + widget.gameData.difficulty.toString());
    debugPrint("showTimer = " + widget.gameData.showTimer.toString());
  }



  @override
  Widget build(BuildContext context) {
    debugPrint('buildGameController' + currentScreen.toString());
    int maxGames = widget.gameData.maxGames;

    if (ScreenType.game == currentScreen) {
      return new Board(gameCounter, widget.gameData);
    } else if (ScreenType.failScore == currentScreen) {
      return new Summary(true, lastStars, lastMoves, lastPoints, isLastLevel(), false, widget.gameData.getBackgroundImage(), widget.gameData.getAppBarColor());
    } else if (ScreenType.allHighScore == currentScreen) {
      int tmpStars = (starSum / maxGames).round();
      return new Summary(false, tmpStars, moveSum, pointSum, true, true, widget.gameData.getBackgroundImage(), widget.gameData.getAppBarColor());
    } else {
      return new Summary(false, lastStars, lastMoves, lastPoints, isLastLevel(), false, widget.gameData.getBackgroundImage(), widget.gameData.getAppBarColor());
    }
  }



  void goToHomeScreen() {
    debugPrint('goToHomeScreen');
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => new HomeScreen(prefService: widget.prefService,))
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
    return (gameCounter < (widget.gameData.maxGames - 1) ? false : true);
  }

}