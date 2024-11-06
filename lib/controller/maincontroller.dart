import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/manager/currentuser.dart';

class MainController extends ChangeNotifier {
  bool isLoggedIn = false;

  MainController() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('appusers')
            .where('uid', isEqualTo: user.uid)
            .get();
        CurrentUser().role = snapshot.docs.first.get('role');
        CurrentUser().uid = user.uid;
      }
      print("MainController");
      notifyListeners();
    });
  }
}
