import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String returnProfileGreeting(DateTime timestamp) {
  // return "morning" if it is morning, "afternoon" if afternoon and "night" if it is night
  var hour = timestamp.hour;
  if (hour >= 0 && hour < 12) {
    return "Good morning,";
  } else if (hour >= 12 && hour < 17) {
    return "Good afternoon,";
  } else {
    return "Goodnight,";
  }
}

double? randomNum() {
  return (math.Random().nextDouble() * 2) - 1;
}

double? elapsedTime(DateTime? otherDateTime) {
  // Find the difference between two datetimes one now and the other as a parameter. return a double of the milliseconds that have passed
  if (otherDateTime == null) {
    return null;
  }

  DateTime now = DateTime.now();
  Duration difference = now.difference(otherDateTime);
  return difference.inMilliseconds.toDouble();
}

String determineSc(
  List<double> arr,
  int num,
  int type,
) {
  // function that returns an integer
  double sum = 0.0;
  int largest = 1500;
  for (int i = 0; i < arr.length; i++) {
    sum += arr[i];
    if (i > 0) {
      sum -= arr[i - 1];
    }
  }
  double avgTime = sum / arr.length;
  double accuracy = (num / 6) * 50;
  double speed = (1 - (avgTime / largest)) * 50;
  if (type == 0) {
    int score = (accuracy + speed).abs().toInt();
    return score.toString();
  }
  if (type == 1) {
    return (speed.toInt() * 2).abs().toString();
  } else {
    return (accuracy.toInt() * 2).abs().toString();
  }
}

String? getSpeed(
  List<double> arr,
  int num,
) {
  // function that returns an integer
  double sum = 0.0;
  int largest = 1500;
  for (int i = 0; i < arr.length; i++) {
    sum += arr[i];
  }
  double avgTime = sum / arr.length;
  double accuracy = (num / 6) * 50;
  int speed = ((1 - (avgTime / largest)) * 50).toInt();
  return speed.toString() + "%";
}

DateTime returnDateTime() {
  // function that returns the datetime currently
  return DateTime.now();
}

List<dynamic> prepareChatHistory(
  List<dynamic> chatHistory,
  String newChat,
) {
  chatHistory.add({"role": "user", "contentuser": newChat.trim()});
  return chatHistory;
}

List<dynamic> refreshChatHistory(
  List<dynamic> chatHistory,
  dynamic chatResponse,
) {
  chatHistory.add(chatResponse);
  return chatHistory;
}

dynamic convertToJSON(String prompt) {
  return json.decode('{"role": "AI", "content": "$prompt"}');
}

List<dynamic> prepareChatAI(
  String newChat,
  List<dynamic> chatHistory,
) {
  if (newChat != null && newChat.isNotEmpty) {
    chatHistory.add({"role": "AI", "contentAI": newChat.trim()});
  }
  return chatHistory;
}

bool getContentAI(dynamic json) {
  return json["role"] == "AI" &&
      json["contentAI"] != null &&
      json["contentAI"].isNotEmpty;
}
