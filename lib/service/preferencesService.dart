import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MemoryType { dino, monster, sea }
const int maxDinoCards = 15;
const int maxMonsterCards = 12;
const int maxSeaCards = 15;

class GameData {
  final int difficulty;
  final int maxGames;
  final bool showTimer;
  final MemoryType selectedType;

  GameData(this.difficulty, this.maxGames, this.showTimer, this.selectedType);

  String getBackgroundImage() {
   return getBackgroundImageOfType(selectedType);
  }

  static String getBackgroundImageOfType(MemoryType type) {
    if (MemoryType.dino == type) {
      return 'assets/pics/jungle.jpg';
    } else if (MemoryType.monster == type) {
      return 'assets/pics/space-1.png';
    } else if (MemoryType.sea == type) {
      return 'assets/pics/water.png';
    }
    //default
    return 'assets/pics/jungle.jpg';
  }

  String getCardPrefix() {
    if (MemoryType.dino == selectedType) {
      return 'assets/pics/dino-';
    } else if (MemoryType.monster == selectedType) {
      return 'assets/pics/monster-';
    } else if (MemoryType.sea == selectedType) {
      return 'assets/pics/sea-';
    }
    return 'assets/pics/dino-';
  }

  Color getAppBarColor() {
    if (MemoryType.dino == selectedType) {
      return Colors.green[400];
    } else if (MemoryType.monster == selectedType) {
      return Colors.orangeAccent;
    } else if (MemoryType.sea == selectedType) {
      return Colors.blueAccent;
    }
    return Colors.green;
  }

  Color getCardColor() {
    if (MemoryType.dino == selectedType) {
      return Colors.green[700];
    } else if (MemoryType.monster == selectedType) {
      return Colors.orange[700];
    } else if (MemoryType.sea == selectedType) {
      return Colors.blue[900];
    }
    return Colors.green[300];
  }

  int maxCardsOfType() {
    if (MemoryType.dino == selectedType) {
      return maxDinoCards;
    } else if (MemoryType.monster == selectedType) {
      return maxMonsterCards;
    } else if (MemoryType.sea == selectedType) {
      return maxSeaCards;
    }
    //default
    return 15;
  }
}

class PreferencesService {
  static const MAX_GAMES = 'MAX_GAMES';
  static const SHOW_TIMER = 'SHOW_TIMER';
  static const MEMORY_TYPE = 'MEMORY_TYPE';

  static const DEFAULT_GAMES = 3;
  static const DEFAULT_TIMER = false;
  static const DEFAULT_SOUND = false;
  static const DEFAULT_MEMORY_TYPE = 1;

  int _maxGames = 3;
  int get maxGames => _maxGames;

  bool _timerOn = true;
  bool get timerOn => _timerOn;

  MemoryType type;

  PreferencesService() {
    load();
  }

  void switchTimer() {
    _timerOn = !timerOn;
    debugPrint('set show timer to: ' + _timerOn.toString());
    save();
  }

  void increaseMaxGames() {
    debugPrint('increase');
    if (maxGames < 100) {
      _maxGames = _maxGames + 1;
      save();
    }
  }

  void decreaseMaxGames() {
    debugPrint('decrease');
    if (_maxGames > 2) {
      _maxGames = _maxGames - 1;
      save();
    }
  }

  void setMaxGames(String value) {
    debugPrint('setMaxGames to ' + value);
    _maxGames = int.tryParse(value) ?? _maxGames;
    save();
  }

  void changeSkin(bool rightWay) {
    // Monster, Dino, Sea
    debugPrint('change skin from ' + type.toString());
    if (rightWay) {
      if (type == MemoryType.monster) {
        type = MemoryType.dino;
      } else if (type == MemoryType.dino) {
        type = MemoryType.sea;
      } else if (type == MemoryType.sea) {
        type = MemoryType.monster;
      }
    } else {
      if (type == MemoryType.monster) {
        type = MemoryType.sea;
      } else if (type == MemoryType.sea) {
        type = MemoryType.dino;
      } else if (type == MemoryType.dino) {
        type = MemoryType.monster;
      }
    }
    debugPrint('to ' + type.toString());
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(MAX_GAMES, _maxGames);
    prefs.setBool(SHOW_TIMER, _timerOn);
    int typeInt = getMemoryTypeAsInt(type);
    prefs.setInt(MEMORY_TYPE, typeInt);
  }

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _maxGames = prefs.getInt(MAX_GAMES) ?? DEFAULT_GAMES;
    _timerOn = prefs.getBool(SHOW_TIMER) ?? DEFAULT_TIMER;
    int _typeInt = prefs.getInt(MEMORY_TYPE) ?? DEFAULT_MEMORY_TYPE;
    type = getIntAsMemoryType(_typeInt);
  }

  int getMemoryTypeAsInt(MemoryType type) {
    int result = 1;
    if (type == MemoryType.monster) {
      result = 1;
    } else if (type == MemoryType.dino) {
      result = 2;
    } else if (type == MemoryType.sea) {
      result = 3;
    }
    return result;
  }

  MemoryType getIntAsMemoryType(int value) {
    MemoryType result = MemoryType.monster;
    if (value == 1) {
      result = MemoryType.monster;
    } else if (value == 2) {
      result = MemoryType.dino;
    } else if (value == 3) {
      result = MemoryType.sea;
    }
    return result;
  }

}
