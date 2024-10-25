import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _apiKey = prefs.getString('ff_apiKey') ?? _apiKey;
    });
    _safeInit(() {
      _isDarkMode = prefs.getBool('ff_isDarkMode') ?? _isDarkMode;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _diet = '';
  String get diet => _diet;
  set diet(String value) {
    _diet = value;
  }

  String _allergens = '';
  String get allergens => _allergens;
  set allergens(String value) {
    _allergens = value;
  }

  String _ingredientdislikes = '';
  String get ingredientdislikes => _ingredientdislikes;
  set ingredientdislikes(String value) {
    _ingredientdislikes = value;
  }

  int _numCorrectMultipleChoice = 0;
  int get numCorrectMultipleChoice => _numCorrectMultipleChoice;
  set numCorrectMultipleChoice(int value) {
    _numCorrectMultipleChoice = value;
  }

  List<int> _vsCorrectAnswer = [0, 0, 1];
  List<int> get vsCorrectAnswer => _vsCorrectAnswer;
  set vsCorrectAnswer(List<int> value) {
    _vsCorrectAnswer = value;
  }

  void addToVsCorrectAnswer(int value) {
    vsCorrectAnswer.add(value);
  }

  void removeFromVsCorrectAnswer(int value) {
    vsCorrectAnswer.remove(value);
  }

  void removeAtIndexFromVsCorrectAnswer(int index) {
    vsCorrectAnswer.removeAt(index);
  }

  void updateVsCorrectAnswerAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    vsCorrectAnswer[index] = updateFn(_vsCorrectAnswer[index]);
  }

  void insertAtIndexInVsCorrectAnswer(int index, int value) {
    vsCorrectAnswer.insert(index, value);
  }

  List<double> _times = [];
  List<double> get times => _times;
  set times(List<double> value) {
    _times = value;
  }

  void addToTimes(double value) {
    times.add(value);
  }

  void removeFromTimes(double value) {
    times.remove(value);
  }

  void removeAtIndexFromTimes(int index) {
    times.removeAt(index);
  }

  void updateTimesAtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    times[index] = updateFn(_times[index]);
  }

  void insertAtIndexInTimes(int index, double value) {
    times.insert(index, value);
  }

  String _score = '';
  String get score => _score;
  set score(String value) {
    _score = value;
  }

  String _speed = '';
  String get speed => _speed;
  set speed(String value) {
    _speed = value;
  }

  String _accuracy = '';
  String get accuracy => _accuracy;
  set accuracy(String value) {
    _accuracy = value;
  }

  List<String> _userRes = [];
  List<String> get userRes => _userRes;
  set userRes(List<String> value) {
    _userRes = value;
  }

  void addToUserRes(String value) {
    userRes.add(value);
  }

  void removeFromUserRes(String value) {
    userRes.remove(value);
  }

  void removeAtIndexFromUserRes(int index) {
    userRes.removeAt(index);
  }

  void updateUserResAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    userRes[index] = updateFn(_userRes[index]);
  }

  void insertAtIndexInUserRes(int index, String value) {
    userRes.insert(index, value);
  }

  List<String> _AIRes = [];
  List<String> get AIRes => _AIRes;
  set AIRes(List<String> value) {
    _AIRes = value;
  }

  void addToAIRes(String value) {
    AIRes.add(value);
  }

  void removeFromAIRes(String value) {
    AIRes.remove(value);
  }

  void removeAtIndexFromAIRes(int index) {
    AIRes.removeAt(index);
  }

  void updateAIResAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    AIRes[index] = updateFn(_AIRes[index]);
  }

  void insertAtIndexInAIRes(int index, String value) {
    AIRes.insert(index, value);
  }

  String _apiKey = 'AIzaSyDggEwyqUy8JwBTnfLtugZ9qI53dzxjx1Q';
  String get apiKey => _apiKey;
  set apiKey(String value) {
    _apiKey = value;
    prefs.setString('ff_apiKey', value);
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool value) {
    _isDarkMode = value;
    prefs.setBool('ff_isDarkMode', value);
  }

  List<dynamic> _currentConversation = [];
  List<dynamic> get currentConversation => _currentConversation;
  set currentConversation(List<dynamic> value) {
    _currentConversation = value;
  }

  void addToCurrentConversation(dynamic value) {
    currentConversation.add(value);
  }

  void removeFromCurrentConversation(dynamic value) {
    currentConversation.remove(value);
  }

  void removeAtIndexFromCurrentConversation(int index) {
    currentConversation.removeAt(index);
  }

  void updateCurrentConversationAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    currentConversation[index] = updateFn(_currentConversation[index]);
  }

  void insertAtIndexInCurrentConversation(int index, dynamic value) {
    currentConversation.insert(index, value);
  }

  dynamic _temp = jsonDecode('{\"role\":\"AI\",\"content\":\"Hello\"}');
  dynamic get temp => _temp;
  set temp(dynamic value) {
    _temp = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
