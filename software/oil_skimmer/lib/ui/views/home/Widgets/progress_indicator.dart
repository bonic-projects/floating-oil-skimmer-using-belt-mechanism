import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';

class ProgressBarcircular extends StatelessWidget {
  double value;
   ProgressBarcircular({super.key,required this.value});

  @override
  Widget build(BuildContext context) {
    return CircularSeekBar(
      interactive: false,
      width: double.infinity,
      progress: value,
      height: 250,
      barWidth: 8,
      startAngle: 45,
      sweepAngle: 270,
      strokeCap: StrokeCap.round,
      progressGradientColors: const [Colors.blue, Colors.indigo, Colors.purple],
      dashWidth: 80,
      dashGap: 15,
      animation: true,
      child:  Center(child: Text(value.toString()),),
       );
  }
}