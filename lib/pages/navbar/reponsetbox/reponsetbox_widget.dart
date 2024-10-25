import '/backend/gemini/gemini.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reponsetbox_model.dart';
export 'reponsetbox_model.dart';

class ReponsetboxWidget extends StatefulWidget {
  const ReponsetboxWidget({super.key});

  @override
  State<ReponsetboxWidget> createState() => _ReponsetboxWidgetState();
}

class _ReponsetboxWidgetState extends State<ReponsetboxWidget> {
  late ReponsetboxModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReponsetboxModel());

    _model.realFieldTextController ??= TextEditingController();
    _model.realFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 232.0,
          height: 65.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).accent4,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.75,
              child: TextFormField(
                controller: _model.realFieldTextController,
                focusNode: _model.realFieldFocusNode,
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 17.0,
                        letterSpacing: 0.0,
                      ),
                  hintText: 'Type your question here.',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 17.0,
                        letterSpacing: 0.0,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 17.0,
                      letterSpacing: 0.0,
                    ),
                cursorColor: FlutterFlowTheme.of(context).primaryText,
                validator: _model.realFieldTextControllerValidator
                    .asValidator(context),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(9.0, 0.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              logFirebaseEvent('REPONSETBOX_COMP_SEND_BTN_ON_TAP');
              if (_model.realFieldTextController.text != null &&
                  _model.realFieldTextController.text != '') {
                logFirebaseEvent('Button_update_app_state');
                FFAppState().currentConversation = functions
                    .prepareChatHistory(
                        FFAppState().currentConversation.toList(),
                        _model.realFieldTextController.text)
                    .toList()
                    .cast<dynamic>();
                safeSetState(() {});
                logFirebaseEvent('Button_gemini');
                await geminiGenerateText(
                  context,
                  _model.realFieldTextController.text,
                ).then((generatedText) {
                  safeSetState(() => _model.realResult = generatedText);
                });

                logFirebaseEvent('Button_update_app_state');
                FFAppState().addToCurrentConversation(
                    functions.convertToJSON(_model.realResult!));
                FFAppState().update(() {});
                logFirebaseEvent('Button_clear_text_fields_pin_codes');
                safeSetState(() {
                  _model.realFieldTextController?.clear();
                });
                logFirebaseEvent('Button_wait__delay');
                await Future.delayed(const Duration(milliseconds: 800));
              }

              safeSetState(() {});
            },
            text: 'Send',
            options: FFButtonOptions(
              height: 58.0,
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
      ],
    );
  }
}
