import '/backend/gemini/gemini.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'chatbot_copy_widget.dart' show ChatbotCopyWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatbotCopyModel extends FlutterFlowModel<ChatbotCopyWidget> {
  ///  State fields for stateful widgets in this page.

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
