import '/exercisewidgets/breathe/breathe_widget.dart';
import '/exercisewidgets/concentrate/concentrate_widget.dart';
import '/exercisewidgets/nbac/nbac_widget.dart';
import '/exercisewidgets/pomodoro/pomodoro_widget.dart';
import '/exercisewidgets/study_mode/study_mode_widget.dart';
import '/exercisewidgets/visual_searc/visual_searc_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'exercises_model.dart';
export 'exercises_model.dart';

class ExercisesWidget extends StatefulWidget {
  const ExercisesWidget({super.key});

  @override
  State<ExercisesWidget> createState() => _ExercisesWidgetState();
}

class _ExercisesWidgetState extends State<ExercisesWidget> {
  late ExercisesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExercisesModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Exercises'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('EXERCISES_PAGE_Exercises_ON_INIT_STATE');
      logFirebaseEvent('Exercises_haptic_feedback');
      HapticFeedback.mediumImpact();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attention Improving Exercises',
                        style:
                            FlutterFlowTheme.of(context).displaySmall.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                        child: Text(
                          'Made to help improve your attention span over time.',
                          style:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: 464.0,
                    height: 577.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'EXERCISES_PAGE_Container_3row59eb_ON_TAP');
                                logFirebaseEvent('Breathe_navigate_to');

                                context.pushNamed('BreathingExercise');
                              },
                              child: wrapWithModel(
                                model: _model.breatheModel,
                                updateCallback: () => safeSetState(() {}),
                                child: BreatheWidget(),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'EXERCISES_PAGE_Container_clt6yarq_ON_TAP');
                                logFirebaseEvent('Pomodoro_navigate_to');

                                context.pushNamed('Pom');
                              },
                              child: wrapWithModel(
                                model: _model.pomodoroModel,
                                updateCallback: () => safeSetState(() {}),
                                child: PomodoroWidget(),
                              ),
                            ),
                            wrapWithModel(
                              model: _model.concentrateModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ConcentrateWidget(),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'EXERCISES_PAGE_Container_dzul5zpz_ON_TAP');
                                logFirebaseEvent('StudyMode_navigate_to');

                                context.pushNamed('study');
                              },
                              child: wrapWithModel(
                                model: _model.studyModeModel,
                                updateCallback: () => safeSetState(() {}),
                                child: StudyModeWidget(),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent('EXERCISES_PAGE_Nbac_ON_TAP');
                                logFirebaseEvent('Nbac_navigate_to');

                                context.pushNamed('findCircle');
                              },
                              child: wrapWithModel(
                                model: _model.nbacModel,
                                updateCallback: () => safeSetState(() {}),
                                child: NbacWidget(),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'EXERCISES_PAGE_Container_es4q8u8h_ON_TAP');
                                logFirebaseEvent('VisualSearc_navigate_to');

                                context.pushNamed('VisualSearch');
                              },
                              child: wrapWithModel(
                                model: _model.visualSearcModel,
                                updateCallback: () => safeSetState(() {}),
                                child: VisualSearcWidget(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
