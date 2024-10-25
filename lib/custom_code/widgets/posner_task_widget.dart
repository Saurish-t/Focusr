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

import 'dart:math';

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
class PosnerTaskWidget extends StatefulWidget {
  const PosnerTaskWidget({Key? key}) : super(key: key);

  @override
  _PosnerTaskWidgetState createState() => _PosnerTaskWidgetState();
}

class _PosnerTaskWidgetState extends State<PosnerTaskWidget> {
  Offset _shapePosition = Offset(0, 0);
  Stopwatch _stopwatch = Stopwatch();
  List<double> _reactionTimes = [];
  String _currentShape = 'circle'; // Can be 'circle' or 'square'

  @override
  void initState() {
    super.initState();
    _spawnShape();
  }

  void _spawnShape() {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      _shapePosition = Offset(
        random.nextDouble() * (screenWidth - 50),
        random.nextDouble() * (screenHeight - 200),
      );
      _currentShape = random.nextBool() ? 'circle' : 'square';
    });

    _stopwatch.reset();
    _stopwatch.start();
  }

  void _onButtonPressed() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      final reactionTime = _stopwatch.elapsedMilliseconds.toDouble();
      setState(() {
        _reactionTimes.add(reactionTime);
      });
      _spawnShape();
    }
  }

  Widget _buildShape() {
    return Positioned(
      left: _shapePosition.dx,
      top: _shapePosition.dy,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape:
              _currentShape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }

  Widget _buildReactionTimeDisplay() {
    return Positioned(
      bottom: 100,
      left: 20,
      child: Text(
        _reactionTimes.isNotEmpty
            ? 'Reaction Time: ${_reactionTimes.last} ms'
            : 'Press the button as fast as you can when the shape appears!',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildPressButton() {
    return Positioned(
      bottom: 40,
      left: MediaQuery.of(context).size.width / 2 - 75,
      child: ElevatedButton(
        onPressed: _onButtonPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(fontSize: 18),
        ),
        child: Text('Press Me'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Shape
        _buildShape(),
        // Reaction Time Display
        _buildReactionTimeDisplay(),
        // Press Button
        _buildPressButton(),
      ],
    );
  }
}
