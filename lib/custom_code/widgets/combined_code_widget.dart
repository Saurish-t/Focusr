import 'package:flutter/material.dart';
import 'package:focus_r/server/parthiv_test/parthiv_test_widget.dart';
import 'package:focus_r/diagnostic/find_circle/find_circle_widget.dart';

class CombinedProgramWidget extends StatefulWidget {
  @override
  _CombinedProgramWidgetState createState() => _CombinedProgramWidgetState();
}

class _CombinedProgramWidgetState extends State<CombinedProgramWidget> {
  bool isCalibrated = false;
  double gazeX = 0.0;
  double gazeY = 0.0;

  void onCalibrationComplete() {
    setState(() {
      isCalibrated = true;
    });
  }

  void updateGazeValues(double x, double y) {
    setState(() {
      gazeX = x;
      gazeY = y;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ParthivTestWidget(
          onCalibrationComplete: onCalibrationComplete,
          onGazeValuesUpdated: updateGazeValues,
        ),
        if (isCalibrated)
          FindCircleWidget(
            gazeX: gazeX,
            gazeY: gazeY,
            onGazeValuesUpdated: updateGazeValues,
          ),
      ],
    );
  }
}
