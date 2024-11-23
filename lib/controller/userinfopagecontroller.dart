import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/constant/constant.dart';
import 'package:flutter_datatable/modal/appuser.dart';
import 'package:flutter_datatable/manager/currentuser.dart';

class UserInfoPageController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final List<AppUser> listUsers = [];

  UserInfoPageController() {
    db
        .collection(Constant.COLLECTION)
        .doc(CurrentUser().uid)
        .get()
        .then((snapshot) {
      listUsers.clear();
      if (CurrentUser().role == Constant.ROLE_STUDENT) {
        listUsers.add(AppUser(
          id: snapshot.id,
          teacherID: snapshot.get("teid"),
          teacherName: snapshot.get("tena"),
          uid: snapshot.get("uid"),
          email: snapshot.get("email"),
          name: snapshot.get("na"),
          chemistpoint: snapshot.get("chepo"),
          mathpoint: snapshot.get("mapo"),
        ));
      } else {
        listUsers.add(AppUser(
          id: snapshot.id,
          uid: snapshot.get("uid"),
          email: snapshot.get("email"),
          name: snapshot.get("na"),
        ));
      }
      
      print("UserInfoPageController");
      notifyListeners();
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Error completing: $error"));
  }

  void setNameForEditing(int index) {
    nameController.text = listUsers[index].name;
  }

  Future<void> editInfoUser({
    required String id,
    required String name,
  }) async {
    if (CurrentUser().role == Constant.ROLE_TEACHER) {
      db
          .collection(Constant.COLLECTION)
          .where('teid', isEqualTo: CurrentUser().uid)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({
            "tena": name,
          });
        }
      });
    }
    await db.collection(Constant.COLLECTION).doc(id).update({"na": name});
    CurrentUser().name = name;
    for (var user in listUsers) {
      user.name = name;
    }
    notifyListeners();
  }
}
