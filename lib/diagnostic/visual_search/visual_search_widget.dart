import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'visual_search_model.dart';
export 'visual_search_model.dart';

class VisualSearchWidget extends StatefulWidget {
  const VisualSearchWidget({super.key});

  @override
  State<VisualSearchWidget> createState() => _VisualSearchWidgetState();
}

class _VisualSearchWidgetState extends State<VisualSearchWidget> {
  late VisualSearchModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VisualSearchModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'VisualSearch'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: MediaQuery.sizeOf(context).height * 0.6,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  Image.network(
                    _model.vsImages[_model.curIndex!],
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Color(0x00000080)],
                          stops: [0.0, 1.0],
                          begin: AlignmentDirectional(0.0, 1.0),
                          end: AlignmentDirectional(0, -1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
              ),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.4,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Is a RED TRIANGLE present in this image?',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              logFirebaseEvent(
                                  'VISUAL_SEARCH_PAGE_NO_BTN_ON_TAP');
                              logFirebaseEvent('Button_update_page_state');
                              _model.notDone = _model.curIndex != 2;
                              safeSetState(() {});
                              logFirebaseEvent('Button_update_page_state');
                              _model.curIndex = _model.curIndex! +
                                  (_model.notDone == false ? 0 : 1);
                              safeSetState(() {});
                              if ((_model.curIndex == 2) &&
                                  (_model.notDone == false)) {
                                logFirebaseEvent('Button_navigate_to');

                                context.pushNamed(
                                  'nBack',
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType:
                                          PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  },
                                );
                              } else {
                                logFirebaseEvent('Button_update_page_state');
                                _model.guess = FFAppState()
                                    .vsCorrectAnswer[_model.indexOfAnswer!];
                                _model.indexOfAnswer =
                                    _model.indexOfAnswer! + 1;
                                safeSetState(() {});
                                logFirebaseEvent('Button_update_app_state');
                                FFAppState().numCorrectMultipleChoice =
                                    FFAppState().numCorrectMultipleChoice +
                                        (_model.guess == 0 ? 1 : 0);
                                safeSetState(() {});
                              }
                            },
                            text: 'No',
                            options: FFButtonOptions(
                              width: 120.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).error,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              logFirebaseEvent(
                                  'VISUAL_SEARCH_PAGE_YES_BTN_ON_TAP');
                              logFirebaseEvent('Button_update_page_state');
                              _model.notDone = _model.curIndex != 2;
                              safeSetState(() {});
                              logFirebaseEvent('Button_update_page_state');
                              _model.curIndex = _model.curIndex! +
                                  (_model.notDone == false ? 0 : 1);
                              safeSetState(() {});
                              if ((_model.curIndex == 2) && !_model.notDone) {
                                logFirebaseEvent('Button_update_page_state');
                                _model.guess = FFAppState()
                                    .vsCorrectAnswer[_model.indexOfAnswer!];
                                safeSetState(() {});
                                logFirebaseEvent('Button_update_app_state');
                                FFAppState().numCorrectMultipleChoice =
                                    FFAppState().numCorrectMultipleChoice +
                                        (_model.guess == 1 ? 1 : 0);
                                safeSetState(() {});
                                logFirebaseEvent('Button_update_page_state');
                                _model.indexOfAnswer =
                                    _model.indexOfAnswer! + 1;
                                safeSetState(() {});
                                logFirebaseEvent('Button_navigate_to');

                                context.pushNamed(
                                  'nBack',
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType:
                                          PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  },
                                );
                              } else {
                                logFirebaseEvent('Button_update_page_state');
                                _model.guess = FFAppState()
                                    .vsCorrectAnswer[_model.indexOfAnswer!];
                                safeSetState(() {});
                                logFirebaseEvent('Button_update_app_state');
                                FFAppState().numCorrectMultipleChoice =
                                    FFAppState().numCorrectMultipleChoice +
                                        (_model.guess == 1 ? 1 : 0);
                                safeSetState(() {});
                                logFirebaseEvent('Button_update_page_state');
                                _model.indexOfAnswer =
                                    _model.indexOfAnswer! + 1;
                                safeSetState(() {});
                              }
                            },
                            text: 'Yes',
                            options: FFButtonOptions(
                              width: 120.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).success,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ].divide(SizedBox(width: 20.0)),
                      ),
                      Text(
                        'Tap a button to see the next image',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
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
    );
  }
}
