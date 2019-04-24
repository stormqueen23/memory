import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:memory/board.dart';
import 'dart:async';

class MemoryTimer extends StatefulWidget {
  final int seconds;

  MemoryTimer({this.seconds});

  @override
  MemoryTimerState createState() {
    return new MemoryTimerState(seconds);
  }
}

class MemoryTimerState extends State<MemoryTimer> {
  final int seconds;
  int remainingTime;
  Timer timer;
  Stopwatch sw;
  int timerSeconds;

  MemoryTimerState(this.seconds);

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(milliseconds: 50), callback);
    sw = new Stopwatch();
    sw.start();
    remainingTime = seconds;
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void callback(Timer timer) {
    if (timer.isActive) {
      remainingTime = (seconds - sw.elapsed.inSeconds);
      if (remainingTime < 0) {
        remainingTime = 0;
        timer.cancel();
        //end game here
        Board.of(context).goToFailSummary(context);
      }

      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    double percent = remainingTime / seconds;


    return Row(
      children: <Widget>[

        Padding(
            padding: EdgeInsets.all(1.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 110,
              lineHeight: 15.0,
              animationDuration: 2500,
              percent: percent,
              center: Text(remainingTime.toString()),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: percent < 0.2 ? Colors.redAccent : percent < 0.4 ? Colors.amber : Colors.white,
            ))
      ],
    );
  }
}
