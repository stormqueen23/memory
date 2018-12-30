import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(new Memory());

class Memory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Memory',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: new HomeScreen(),
    );
  }
}
