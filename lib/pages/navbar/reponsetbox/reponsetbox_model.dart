import '/backend/gemini/gemini.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'reponsetbox_widget.dart' show ReponsetboxWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReponsetboxModel extends FlutterFlowModel<ReponsetboxWidget> {
  ///  Local state fields for this component.

  dynamic t3;

  ///  State fields for stateful widgets in this component.

  // State field(s) for RealField widget.
  FocusNode? realFieldFocusNode;
  TextEditingController? realFieldTextController;
  String? Function(BuildContext, String?)? realFieldTextControllerValidator;
  // Stores action output result for [Gemini - Generate Text] action in Button widget.
  String? realResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    realFieldFocusNode?.dispose();
    realFieldTextController?.dispose();
  }
}
