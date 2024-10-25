import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'find_circle_widget.dart' show FindCircleWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FindCircleModel extends FlutterFlowModel<FindCircleWidget> {
  ///  Local state fields for this page.

  bool gameStarted = false;

  bool circleVisible = false;

  int? circleCount = 0;

  DateTime? startTime;

  List<double> elapsedTimes = [];
  void addToElapsedTimes(double item) => elapsedTimes.add(item);
  void removeFromElapsedTimes(double item) => elapsedTimes.remove(item);
  void removeAtIndexFromElapsedTimes(int index) => elapsedTimes.removeAt(index);
  void insertAtIndexInElapsedTimes(int index, double item) =>
      elapsedTimes.insert(index, item);
  void updateElapsedTimesAtIndex(int index, Function(double) updateFn) =>
      elapsedTimes[index] = updateFn(elapsedTimes[index]);

  double? circlePosX = 0.0;

  double? circlePosY = 0.0;

  List<double> posListX = [0.0, 0.25, 0.5, -0.5];
  void addToPosListX(double item) => posListX.add(item);
  void removeFromPosListX(double item) => posListX.remove(item);
  void removeAtIndexFromPosListX(int index) => posListX.removeAt(index);
  void insertAtIndexInPosListX(int index, double item) =>
      posListX.insert(index, item);
  void updatePosListXAtIndex(int index, Function(double) updateFn) =>
      posListX[index] = updateFn(posListX[index]);

  List<double> posListY = [0.0, 0.5, 1.0, -0.75, -0.5];
  void addToPosListY(double item) => posListY.add(item);
  void removeFromPosListY(double item) => posListY.remove(item);
  void removeAtIndexFromPosListY(int index) => posListY.removeAt(index);
  void insertAtIndexInPosListY(int index, double item) =>
      posListY.insert(index, item);
  void updatePosListYAtIndex(int index, Function(double) updateFn) =>
      posListY[index] = updateFn(posListY[index]);

  int? curIndex = 0;

  double? timePassed;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Timer widget.
  final timerInitialTimeMs = 0;
  int timerMilliseconds = 0;
  String timerValue = StopWatchTimer.getDisplayTime(
    0,
    hours: false,
    minute: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countUp));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}
