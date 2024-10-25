// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

class PosnerTask extends StatefulWidget {
  @override
  _PosnerTaskState createState() => _PosnerTaskState();
}

class _PosnerTaskState extends State<PosnerTask> {
  int _score = 0;
  bool _isCueLeft = true;
  bool _isTargetLeft = true;
  bool _showTarget = false;
  Timer? _timer;
  int _trialCount = 0;
  int _maxTrials = 10; // Adjust based on time

  @override
  void initState() {
    super.initState();
    _startTrial();
  }

  void _startTrial() {
    _isCueLeft = (DateTime.now().millisecondsSinceEpoch % 2 == 0);
    _isTargetLeft = (DateTime.now().millisecondsSinceEpoch % 2 == 0);

    setState(() {
      _showTarget = false;
    });

    _timer = Timer(Duration(seconds: 1), () {
      setState(() {
        _showTarget = true;
      });

      _timer = Timer(Duration(seconds: 1), () {
        _trialCount++;
        if (_trialCount < _maxTrials) {
          _startTrial();
        } else {
          _endTask();
        }
      });
    });
  }

  void _endTask() {
    // Handle end of task, like showing score or moving to next task
    Navigator.of(context).pop(_score);
  }

  void _recordResponse(bool isLeft) {
    if (_showTarget) {
      if (isLeft == _isTargetLeft) {
        _score++;
      }
      _startTrial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Score: $_score'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _isCueLeft
                  ? Icon(Icons.arrow_left, size: 100)
                  : Container(width: 100, height: 100),
              !_isCueLeft
                  ? Icon(Icons.arrow_right, size: 100)
                  : Container(width: 100, height: 100),
            ],
          ),
          Spacer(),
          if (_showTarget)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _recordResponse(true),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: _isTargetLeft ? Colors.green : Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: () => _recordResponse(false),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: !_isTargetLeft ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
