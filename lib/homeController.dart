import 'package:flutter/material.dart';

import 'package:memory/widgets/preferences.dart';
import 'package:memory/widgets/home.dart';
import 'bloc/preferencesService.dart';

enum DialogType { ok }

enum DisplayType { home, prefs }

class HomeScreen extends StatefulWidget {

  final PreferencesService prefService;

  const HomeScreen({Key key, @required this.prefService}) : super(key: key);

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
  DisplayType display;

  @override
  void initState() {
    super.initState();
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
    Widget child = display == DisplayType.prefs
        ? PreferencesWidget(widget.prefService)
        : HomeWidget(widget.prefService);
    return MemoryScaffold(child: child, memoryType: widget.prefService.type);
  }
}

class MemoryScaffold extends StatelessWidget {
  final Widget child;
  final MemoryType memoryType;

  MemoryScaffold({@required this.child, @required this.memoryType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image:
                    AssetImage(GameData.getBackgroundImageOfType(memoryType)),
                fit: BoxFit.fitHeight)),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[child]),
        ),
      ),
    );
  }
}
