import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pom_model.dart';
export 'pom_model.dart';

class PomWidget extends StatefulWidget {
  const PomWidget({super.key});

  @override
  State<PomWidget> createState() => _PomWidgetState();
}

class _PomWidgetState extends State<PomWidget> {
  late PomModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PomModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Pom'});
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
        body: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4B39EF), Color(0xFF39D2C0)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 330.0, 0.0),
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                      child: FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 20.0,
                        buttonSize: 38.0,
                        fillColor: Color(0x33FFFFFF),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          logFirebaseEvent('POM_PAGE_arrow_back_ICN_ON_TAP');
                          logFirebaseEvent('IconButton_navigate_to');

                          context.pushNamed('Exercises');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Pomodoro',
                        style:
                            FlutterFlowTheme.of(context).displayLarge.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Container(
                        width: 300.0,
                        height: 300.0,
                        decoration: BoxDecoration(
                          color: Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(150.0),
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 24.0, 24.0, 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FlutterFlowTimer(
                                initialTime: _model.timerInitialTimeMs,
                                getDisplayTime: (value) =>
                                    StopWatchTimer.getDisplayTime(
                                  value,
                                  hours: false,
                                  milliSecond: false,
                                ),
                                controller: _model.timerController,
                                updateStateInterval:
                                    Duration(milliseconds: 1000),
                                onChanged: (value, displayTime, shouldUpdate) {
                                  _model.timerMilliseconds = value;
                                  _model.timerValue = displayTime;
                                  if (shouldUpdate) safeSetState(() {});
                                },
                                onEnded: () async {
                                  logFirebaseEvent(
                                      'POM_PAGE_Timer_nfkjly9p_ON_TIMER_END');
                                  logFirebaseEvent('Timer_update_page_state');
                                  _model.working = !_model.working;
                                  safeSetState(() {});
                                  if (_model.working) {
                                    logFirebaseEvent('Timer_timer');
                                    _model.timerController.timer.setPresetTime(
                                      mSec: (_model.workTime!).toInt() * 60000,
                                      add: false,
                                    );
                                    _model.timerController.onResetTimer();
                                  } else {
                                    logFirebaseEvent('Timer_timer');
                                    _model.timerController.timer.setPresetTime(
                                      mSec: (_model.breakTime!).toInt() * 60000,
                                      add: false,
                                    );
                                    _model.timerController.onResetTimer();
                                  }
                                },
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: 44.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                _model.working ? 'Working' : 'Break Time!',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'POM_PAGE_Icon_gux53q0l_ON_TAP');
                                logFirebaseEvent('Icon_update_page_state');
                                _model.started = true;
                                safeSetState(() {});
                                logFirebaseEvent('Icon_timer');
                                _model.timerController.onStartTimer();
                              },
                              child: Icon(
                                Icons.play_arrow,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 40.0,
                              ),
                            ),
                          ),
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'POM_PAGE_Icon_jy1yc0r6_ON_TAP');
                                logFirebaseEvent('Icon_timer');
                                _model.timerController.onStopTimer();
                              },
                              child: Icon(
                                Icons.pause,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 40.0,
                              ),
                            ),
                          ),
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'POM_PAGE_Icon_mcrrdljc_ON_TAP');
                                logFirebaseEvent('Icon_timer');
                                _model.timerController.onResetTimer();
                              },
                              child: Icon(
                                Icons.stop,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 24.0)),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        decoration: BoxDecoration(
                          color: Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 24.0, 24.0, 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Session Progress',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Work Time',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 300.0,
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Color(0x33FFFFFF),
                                  min: 0.0,
                                  max: 100.0,
                                  value: _model.sliderValue1 ??= 83.0,
                                  onChanged: (newValue) async {
                                    newValue = double.parse(
                                        newValue.toStringAsFixed(4));
                                    safeSetState(
                                        () => _model.sliderValue1 = newValue);
                                    logFirebaseEvent(
                                        'POM_Slider_aeb1upc6_ON_FORM_WIDGET_SELEC');
                                    logFirebaseEvent(
                                        'Slider_update_page_state');
                                    _model.workTime = _model.sliderValue1;
                                    safeSetState(() {});
                                    if (_model.working == true) {
                                      logFirebaseEvent('Slider_timer');
                                      _model.timerController.timer
                                          .setPresetTime(
                                        mSec:
                                            (_model.workTime!).toInt() * 60000,
                                        add: false,
                                      );
                                      _model.timerController.onResetTimer();
                                    }
                                  },
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Break Time',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 300.0,
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Color(0x33FFFFFF),
                                  min: 0.0,
                                  max: 100.0,
                                  value: _model.sliderValue2 ??= 100.0,
                                  onChanged: (newValue) async {
                                    newValue = double.parse(
                                        newValue.toStringAsFixed(4));
                                    safeSetState(
                                        () => _model.sliderValue2 = newValue);
                                    logFirebaseEvent(
                                        'POM_Slider_5s3kmbvc_ON_FORM_WIDGET_SELEC');
                                    logFirebaseEvent(
                                        'Slider_update_page_state');
                                    _model.breakTime = _model.sliderValue2;
                                    safeSetState(() {});
                                    if (_model.working != true) {
                                      logFirebaseEvent('Slider_timer');
                                      _model.timerController.timer
                                          .setPresetTime(
                                        mSec:
                                            (_model.breakTime!).toInt() * 60000,
                                        add: false,
                                      );
                                      _model.timerController.onResetTimer();
                                    }
                                  },
                                ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 32.0)),
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
