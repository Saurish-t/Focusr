import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'find_circle_model.dart';
export 'find_circle_model.dart';

class FindCircleWidget extends StatefulWidget {
  const FindCircleWidget({super.key});

  @override
  State<FindCircleWidget> createState() => _FindCircleWidgetState();
}

class _FindCircleWidgetState extends State<FindCircleWidget> {
  late FindCircleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FindCircleModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'findCircle'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, -0.02),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (!_model.gameStarted)
                                    FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'FIND_CIRCLE_PAGE_START_GAME_BTN_ON_TAP');
                                        logFirebaseEvent(
                                            'Button_update_page_state');
                                        _model.gameStarted = true;
                                        _model.circleVisible = true;
                                        _model.circleCount =
                                            _model.circleCount! + 1;
                                        _model.startTime = getCurrentTimestamp;
                                        _model.elapsedTimes = [];
                                        _model.circlePosX =
                                            (List<double> posX, int curIndex) {
                                          return posX[curIndex];
                                        }(_model.posListX.toList(),
                                                _model.curIndex!);
                                        _model.circlePosY =
                                            (List<double> posY, int curIndex) {
                                          return posY[curIndex];
                                        }(_model.posListY.toList(),
                                                _model.curIndex!);
                                        safeSetState(() {});
                                        logFirebaseEvent('Button_timer');
                                        _model.timerController.onStartTimer();
                                      },
                                      text: 'Start Game',
                                      options: FFButtonOptions(
                                        width: 200.0,
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 0.0,
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.06, -0.98),
                          child: FlutterFlowTimer(
                            initialTime: _model.timerInitialTimeMs,
                            getDisplayTime: (value) =>
                                StopWatchTimer.getDisplayTime(
                              value,
                              hours: false,
                              minute: false,
                            ),
                            controller: _model.timerController,
                            updateStateInterval: Duration(milliseconds: 1000),
                            onChanged: (value, displayTime, shouldUpdate) {
                              _model.timerMilliseconds = value;
                              _model.timerValue = displayTime;
                              if (shouldUpdate) safeSetState(() {});
                            },
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        if (_model.circleVisible)
                          Align(
                            alignment: AlignmentDirectional(
                                valueOrDefault<double>(
                                  _model.circlePosX,
                                  0.0,
                                ),
                                valueOrDefault<double>(
                                  _model.circlePosY,
                                  0.0,
                                )),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'FIND_CIRCLE_PAGE_Circle_ON_TAP');
                                logFirebaseEvent('Circle_update_page_state');
                                _model.circleVisible = false;
                                _model.circleCount = _model.circleCount! + 1;
                                safeSetState(() {});
                                if (_model.circleCount! < 10) {
                                  logFirebaseEvent('Circle_update_page_state');
                                  _model.circleVisible = true;
                                  _model.curIndex = ((_model.curIndex!) + 1) %
                                      _model.posListX.toList().length;
                                  _model.circlePosX = functions.randomNum();
                                  _model.circlePosY = functions.randomNum();
                                  _model.timePassed =
                                      functions.elapsedTime(_model.startTime);
                                  safeSetState(() {});
                                  logFirebaseEvent('Circle_update_app_state');
                                  FFAppState().addToTimes(_model.timePassed!);
                                  safeSetState(() {});
                                  logFirebaseEvent('Circle_timer');
                                  _model.timerController.onResetTimer();

                                  logFirebaseEvent('Circle_timer');
                                  _model.timerController.onStartTimer();
                                } else {
                                  logFirebaseEvent('Circle_timer');
                                  _model.timerController.onResetTimer();

                                  logFirebaseEvent('Circle_update_page_state');
                                  _model.gameStarted = false;
                                  _model.circleCount = 0;
                                  _model.timePassed = null;
                                  safeSetState(() {});
                                  logFirebaseEvent('Circle_navigate_to');

                                  context.pushNamed(
                                    'VisualSearch',
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        transitionType:
                                            PageTransitionType.rightToLeft,
                                        duration: Duration(milliseconds: 1000),
                                      ),
                                    },
                                  );
                                }
                              },
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
