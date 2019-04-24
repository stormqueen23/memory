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
      return 'assets/jungle.jpg';
    } else if (MemoryType.monster == type) {
      return 'assets/space-1.png';
    } else if (MemoryType.sea == type) {
      return 'assets/water.png';
    }
    //default
    return 'assets/jungle.jpg';
  }

  String getCardPrefix() {
    if (MemoryType.dino == selectedType) {
      return 'assets/dino-';
    } else if (MemoryType.monster == selectedType) {
      return 'assets/monster-';
    } else if (MemoryType.sea == selectedType) {
      return 'assets/sea-';
    }
    return 'assets/dino-';
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
  static const SOUND_ON = 'SOUND_ON';

  static const DEFAULT_GAMES = 3;
  static const DEFAULT_TIMER = false;
  static const DEFAULT_SOUND = false;

  int _maxGames = 3;
  int get maxGames => _maxGames;

  bool _timerOn = true;
  bool get timerOn => _timerOn;

  MemoryType type = MemoryType.monster;

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

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(MAX_GAMES, _maxGames);
    prefs.setBool(SHOW_TIMER, _timerOn);
  }

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _maxGames = prefs.getInt(MAX_GAMES) ?? DEFAULT_GAMES;
    _timerOn = prefs.getBool(SHOW_TIMER) ?? DEFAULT_TIMER;
    //bool _soundOn = prefs.getBool(SHOW_TIMER) ?? DEFAULT_TIMER;
   // _currentPrefs.add(PrefData(_maxGames, _soundOn, _showTimer));
  }

}
