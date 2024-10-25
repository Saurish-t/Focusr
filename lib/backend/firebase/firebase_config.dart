import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDjTXVHGykI2lcV5l_UK9bVrGrZCxq49po",
            authDomain: "focus-sense-cdr12f.firebaseapp.com",
            projectId: "focus-sense-cdr12f",
            storageBucket: "focus-sense-cdr12f.appspot.com",
            messagingSenderId: "275487224805",
            appId: "1:275487224805:web:109e4e2dd1e5bc7f20f50c"));
  } else {
    await Firebase.initializeApp();
  }
}
