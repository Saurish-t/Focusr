import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'visual_search_widget.dart' show VisualSearchWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VisualSearchModel extends FlutterFlowModel<VisualSearchWidget> {
  ///  Local state fields for this page.

  List<String> vsImages = [
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/focus-sense-cdr12f/assets/dpsf127hxu79/vs3.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/focus-sense-cdr12f/assets/j749hhz2xgq0/vs2.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/focus-sense-cdr12f/assets/iv4ayrexx7g6/vs1.png'
  ];
  void addToVsImages(String item) => vsImages.add(item);
  void removeFromVsImages(String item) => vsImages.remove(item);
  void removeAtIndexFromVsImages(int index) => vsImages.removeAt(index);
  void insertAtIndexInVsImages(int index, String item) =>
      vsImages.insert(index, item);
  void updateVsImagesAtIndex(int index, Function(String) updateFn) =>
      vsImages[index] = updateFn(vsImages[index]);

  int? curIndex = 0;

  int? guess;

  bool notDone = true;

  int? indexOfAnswer = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
