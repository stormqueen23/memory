import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homeController.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new Memory());
  });
}

class Memory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      home: HomeScreen(),
    );
  }
}
