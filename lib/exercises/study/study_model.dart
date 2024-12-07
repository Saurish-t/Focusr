import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'study_widget.dart' show StudyWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class StudyModel extends FlutterFlowModel<StudyWidget> {
  ///  Local state fields for this page.

  bool playingSound = false;

  ///  State fields for stateful widgets in this page.

  AudioPlayer? soundPlayer1;
  // State field(s) for Slider widget.
  double? sliderValue1;
  AudioPlayer? soundPlayer2;
  // State field(s) for Slider widget.
  double? sliderValue2;
  // State field(s) for Slider widget.
  double? sliderValue3;
  // State field(s) for Slider widget.
  double? sliderValue4;
  // State field(s) for Slider widget.
  double? sliderValue5;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
