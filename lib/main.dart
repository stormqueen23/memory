import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new Memory());
  });
}

class Memory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dino-Memory',
      theme: new ThemeData(
          primarySwatch: Colors.brown
      ),
      home: new HomeScreen(),
    );
  }
}
