import '/exercisewidgets/breathe/breathe_widget.dart';
import '/exercisewidgets/concentrate/concentrate_widget.dart';
import '/exercisewidgets/nbac/nbac_widget.dart';
import '/exercisewidgets/pomodoro/pomodoro_widget.dart';
import '/exercisewidgets/study_mode/study_mode_widget.dart';
import '/exercisewidgets/visual_searc/visual_searc_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'exercises_widget.dart' show ExercisesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExercisesModel extends FlutterFlowModel<ExercisesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Breathe component.
  late BreatheModel breatheModel;
  // Model for Pomodoro component.
  late PomodoroModel pomodoroModel;
  // Model for concentrate component.
  late ConcentrateModel concentrateModel;
  // Model for StudyMode component.
  late StudyModeModel studyModeModel;
  // Model for Nbac.
  late NbacModel nbacModel;
  // Model for VisualSearc component.
  late VisualSearcModel visualSearcModel;

  @override
  void initState(BuildContext context) {
    breatheModel = createModel(context, () => BreatheModel());
    pomodoroModel = createModel(context, () => PomodoroModel());
    concentrateModel = createModel(context, () => ConcentrateModel());
    studyModeModel = createModel(context, () => StudyModeModel());
    nbacModel = createModel(context, () => NbacModel());
    visualSearcModel = createModel(context, () => VisualSearcModel());
  }

  @override
  void dispose() {
    breatheModel.dispose();
    pomodoroModel.dispose();
    concentrateModel.dispose();
    studyModeModel.dispose();
    nbacModel.dispose();
    visualSearcModel.dispose();
  }
}
