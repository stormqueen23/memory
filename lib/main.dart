import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:memory/service/preferencesService.dart';
import 'homeController.dart';

void main() {
  PreferencesService prefService = PreferencesService();
  prefService.load().then((_) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(new Memory(prefService));
    });
  }

  );

}

class Memory extends StatelessWidget {
  final PreferencesService prefService;

  Memory(this.prefService);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/jungle.jpg'), context);
    precacheImage(AssetImage('assets/space-1.png'), context);
    precacheImage(AssetImage('assets/water.png'), context);
    return MaterialApp(
      title: 'Memory',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Coiny',
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.brown[800],
          )
        ),
        primaryTextTheme: TextTheme(
          body2: TextStyle(
            color: Colors.yellow,
          ),
          body1: TextStyle(
            color: Colors.brown[800],
          )
        )
      ),
      home: HomeScreen(prefService: prefService),
    );
  }
}
