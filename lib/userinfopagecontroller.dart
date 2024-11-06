import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuser.dart';
import 'package:flutter_datatable/currentuser.dart';

class UserInfoPageController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();  
  final db = FirebaseFirestore.instance;
  final List<AppUser> listUsers = [];

  UserInfoPageController() {
    db
        .collection("appusers")
        .where("uid", isEqualTo: CurrentUser().uid)
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

  Future<void> editInfoUser({
    required String id,
    required String name,}) async {
    if (CurrentUser().role == "Teacher") {
      DocumentSnapshot snapshot = await db.collection('appusers').doc(id).get();
      String teachername = snapshot.get('na');

      db
          .collection("appusers")
          .where('role', isEqualTo: "Student")
          .where('tena', isEqualTo: teachername)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({
            "tena": name,
          });
        }
      });
    }

    await db.collection("appusers").doc(id).update({"na": name});

    for (var user in listUsers) {
      user.name = name;
    }

    notifyListeners();
  }
}
