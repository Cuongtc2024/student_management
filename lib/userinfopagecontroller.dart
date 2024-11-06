import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuser.dart';

class UserInfoPageController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  String? currentUid = FirebaseAuth.instance.currentUser?.uid;
  final List<AppUser> listUsers = [];

  UserInfoPageController() {
    db
        .collection("appusers")
        .where("uid", isEqualTo: currentUid)
        .get()
        .then((snapshot) {
      listUsers.clear();
      for (var docUser in snapshot.docs) {
        AppUser appUser = AppUser(
          id: docUser.id,
          techerId: docUser.data()["teid"],
          techerName: docUser.data()["tena"],
          role: docUser.data()["role"],
          uid: docUser.data()["uid"],
          email: docUser.data()["email"],
          name: docUser.data()["na"],
          chemistpoint: docUser.data()["chepo"],
          mathpoint: docUser.data()["mapo"],
        );
        listUsers.add(appUser);
      }
      notifyListeners();
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Error completing: $error"));
  }
}
