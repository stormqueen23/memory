import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:memory/widgets/preferences.dart';
import 'package:memory/widgets/home.dart';
import 'bloc/preferencesService.dart';

enum DialogType { ok }

enum DisplayType { home, prefs }

class HomeScreen extends StatefulWidget {
  State<HomeScreen> createState() {
    return HomeScreenState();
  }

  static HomeScreenState of(BuildContext context) {
    final HomeScreenState navigator =
        context.ancestorStateOfType(const TypeMatcher<HomeScreenState>());

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

class HomeScreenState extends State<HomeScreen> {
  PreferencesService prefService;
  DisplayType display;
  MemoryType selectedType = MemoryType.monster;

  @override
  void initState() {
    super.initState();
    prefService = PreferencesService();
    display = DisplayType.home;
  }

  setDisplayTypeHome() {
    setState(() {
      display = DisplayType.home;
    });
  }

  setDisplayTypePrefs() {
    setState(() {
      display = DisplayType.prefs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage(GameData.getBackgroundImageOfType(selectedType)),
                    fit: BoxFit.fitHeight)),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    display == DisplayType.prefs
                        ? PreferencesWidget(prefService)
                        : HomeWidget(prefService),
                  ]),
            )));
  }
}
