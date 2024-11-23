import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/manager/currentuser.dart';

class MainController extends ChangeNotifier {
  bool isLoggedIn = false;

  final db = FirebaseFirestore.instance;

  MainController() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
        DocumentSnapshot snapshot =
            await db.collection('appusers').doc(user.uid).get();
        CurrentUser().uid = user.uid;
        CurrentUser().name = snapshot.get('na');
        CurrentUser().role = snapshot.get('role');
      }
      print("MainController");
      notifyListeners();
    });
  }
}
