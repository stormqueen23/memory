import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../bloc/preferencesService.dart';
import '../homeController.dart';

class PreferencesWidget extends StatefulWidget {
  final PreferencesService prefService;

  PreferencesWidget(this.prefService);

  @override
  _PreferencesWidgetState createState() => _PreferencesWidgetState();
}

class _PreferencesWidgetState extends State<PreferencesWidget> {
  void showHome(BuildContext context) {
    HomeScreen.of(context).setDisplayTypeHome();
  }

  Padding getInfoRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 70.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              iconSize: 30.0,
              color: Colors.brown,
              onPressed: () {
                showHome(context);
              }),
        ],
      ),
    );
  }

  Widget getPrefContainer(BuildContext context) {

    int _maxGames = widget.prefService.maxGames;
    bool _showTimer = widget.prefService.timerOn;

    double getContainerWidth() {
      double width = MediaQuery.of(context).size.width;
      return width * 0.85;
    }

    double getContainerHeight() {
      double height = MediaQuery.of(context).size.height;
      return height * 0.3;
    }

    double getTextScale() {
      return 1.5;
    }

    return Center(
      child: Container(
        width: getContainerWidth(),
        height: getContainerHeight(),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: Colors.brown, width: 5.0),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
              child: Text(
                'Einstellungen',
                textScaleFactor: 2.0,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8, 0, 0),
                      child: Container(
                          constraints: BoxConstraints(minWidth: 150),
                          child: Text(
                            'Spiele pro Runde:',
                            textScaleFactor: 1.5,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                          constraints: BoxConstraints(minWidth: 150),
                          child: Text(
                            'Timer anzeigen',
                            textScaleFactor: 1.5,
                          )),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                widget.prefService.decreaseMaxGames();
                              });
                            }),
                        Text(
                          _maxGames.toString(),
                          textScaleFactor: getTextScale(),
                        ),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                widget.prefService.increaseMaxGames();
                              });
                            }),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Checkbox(
                              value: _showTimer,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              onChanged: (bool newValue) {
                                setState(() {
                                  widget.prefService.switchTimer();
                                });
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build preferencesPage');
    return Column(children: <Widget>[
      getInfoRow(context),
      getPrefContainer(context),
    ]);
  }
}
