import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MainController extends ChangeNotifier {
  bool _isloggedIn = false;
  String? _roleOfCurrentUser;
  bool get isLoggedIn => _isloggedIn;
  String? get roleOfCurrentUser => _roleOfCurrentUser;
     
  MainController(){    
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) async {
    if (user == null) {
      _isloggedIn = false;
      _roleOfCurrentUser = null;
    } else {      
      _isloggedIn = true;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appusers')
          .where('uid', isEqualTo: user.uid)
          .get();
        _roleOfCurrentUser = snapshot.docs.first.get('role');        
    }
    notifyListeners();
  });  
  }
}
