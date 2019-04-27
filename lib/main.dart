import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'service/preferencesService.dart';
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
    precacheImage(AssetImage('assets/pics/jungle.jpg'), context);
    precacheImage(AssetImage('assets/pics/space-1.png'), context);
    precacheImage(AssetImage('assets/pics/water.png'), context);
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
      localizationsDelegates: [
        FlutterI18nDelegate(
            useCountryCode: false, fallbackFile: 'en', path: 'assets/i18n'),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
