// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datatable/modal/appuser.dart';
import 'package:flutter_datatable/constant/constant.dart';
import 'package:flutter_datatable/manager/currentuser.dart';

import '../constant/userlisttype.dart';

class UserListPageController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<AppUser> listUsers = [];
  final TextEditingController teacherNameToFilterController =
      TextEditingController();

  final _uid = CurrentUser().uid;
  final _role = CurrentUser().role;
  List<AppUser> _filteredUsers = [];
  List<AppUser> get filteredUsers => _filteredUsers;
  List<String> fieldsToDelete = ["role", "teid", "tena", "mapo", "chepo"];

  final UserListType type;

  UserListPageController(this.type) {
    getListUser(type);
    _filteredUsers = listUsers;
  }

  Future<void> getListUser(UserListType type) async {
    Query query = db.collection("appusers");
    if (type == UserListType.studentsofteacher) {
      query = query.where("teid", isEqualTo: _uid);
    } else if (type == UserListType.teachers) {
      query = query.where("role", isEqualTo: "Teacher");
    } else if (type == UserListType.allstudents) {
      query = query.where("role", isEqualTo: "Student");
    }

    query.get().then((snapshot) {
      listUsers.clear();
      for (var docUser in snapshot.docs) {
        AppUser appUser;
        if (type == UserListType.allstudents) {
          appUser = AppUser(
            id: docUser.id,
            teacherID: docUser.get("teid"),
            teacherName: docUser.get("tena"),
            role: docUser.get("role"),
            uid: docUser.get("uid"),
            email: docUser.get("email"),
            name: docUser.get("na"),
            chemistpoint: docUser.get("chepo"),
            mathpoint: docUser.get("mapo"),
          );
        } else {
          appUser = AppUser(
            id: docUser.id,
            role: docUser.get("role"),
            uid: docUser.get("uid"),
            email: docUser.get("email"),
            name: docUser.get("na"),
          );
        }

        listUsers.add(appUser);
      }
      print("getListUser");
      notifyListeners();
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Error completing: $error"));
  }

  Future<void> addAppUser(BuildContext context, {required String email}) async {
    Map<String, dynamic> updateData = {};

    QuerySnapshot snapshot =
        await db.collection('appusers').where('email', isEqualTo: email).get();
    for (var doc in snapshot.docs) {
      switch (_role) {
        case Constant.ROLE_PRINCIPLE:
          updateData = {"role": Constant.ROLE_TEACHER};
          break;
        case Constant.ROLE_TEACHER:
          updateData = {
            "role": Constant.ROLE_STUDENT,
            "teid": _uid,
            "tena": CurrentUser().name,
            "mapo": "",
            "chepo": "",
          };
          break;
      }
      await doc.reference.update(updateData);

      listUsers.add(AppUser(
        id: doc.id,
        email: email,
        teacherID: _uid,
        teacherName: CurrentUser().name,
        role: updateData["role"],
        uid: doc.get("uid"),
        name: doc.get("na"),
        mathpoint: updateData["mapo"],
        chemistpoint: updateData["chepo"],
      ));
    }
    notifyListeners();
  }

  Future<void> editAppUser(
      {required String id,
      required String role,
      required String name,
      String? mapo,
      String? chepo}) async {
    Map<String, dynamic> dataUpdate = {"na": name};
    if (role == Constant.ROLE_STUDENT) {
      dataUpdate['mapo'] = mapo;
      dataUpdate['chepo'] = chepo;
    }
    if (role == Constant.ROLE_TEACHER) {
      DocumentSnapshot snapshot = await db.collection('appusers').doc(id).get();
      String teachername = snapshot.get('na');

      db
          .collection("appusers")
          .where('teid', isEqualTo: "Student")
          
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({
            "tena": name,
          });
        }
      });
    }
    await db.collection("appusers").doc(id).update(dataUpdate);

    for (var user in listUsers) {
      if (user.id == id) {
        user.name = name;
        if (role == Constant.ROLE_STUDENT) {
          user.mathpoint = mapo;
          user.chemistpoint = chepo;
        }
      }
    }

    notifyListeners();
  }

  Future<void> deleteAppUser({
    required String id,
    required String role,
  }) async {
    deleteFields(id, fieldsToDelete);
    if (role == Constant.ROLE_TEACHER) {
      DocumentSnapshot snapshot = await db.collection('appusers').doc(id).get();
      String teacherName = snapshot.get('na');
      db
          .collection("appusers")
          .where("role", isEqualTo: Constant.ROLE_STUDENT)
          .where("tena", isEqualTo: teacherName)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          deleteFields(doc.id, fieldsToDelete);
        }
      });
    }
    listUsers.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  // void filterByTeacherName({required String teacherNameToFilter}) {
  //   _filteredUsers = listUsers
  //       .where((user) =>
  //           user.techerName!.toLowerCase().contains(teacherNameToFilter.toLowerCase()))
  //       .toList();
  //   notifyListeners();
  // }

  void filterByTeacherName(String teName) {
    _filteredUsers = listUsers
        .where((user) =>
            user.teacherName!.toLowerCase().contains(teName.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> deleteFields(String docId, List<String> fieldsToDelete) async {
    Map<String, dynamic> updates = {
      for (var field in fieldsToDelete) field: FieldValue.delete()
    };
    await FirebaseFirestore.instance
        .collection("appusers")
        .doc(docId)
        .update(updates);
  }
}
