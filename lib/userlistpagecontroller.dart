// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuser.dart';
import 'package:flutter_datatable/currentuser.dart';

class UserListPageController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<AppUser> listUsers = [];
  final TextEditingController teacherNameToFilterController =
      TextEditingController();

  String? _uid;
  String? _role;
  List<AppUser> _filteredUsers = [];
  List<AppUser> get filteredUsers => _filteredUsers;
  List<String> fieldsToDelete = ["role", "teid", "tena", "mapo", "chepo"];

  String studentList = "Student List";
  String teacherList = "Teacher List";
  String student = "Student";
  String principal = "Principal";
  String teacher = "Teacher";
  

  UserListPageController() {
    _uid = CurrentUser().uid;
    _role = CurrentUser().role;
    print("role2$_role");
    _filteredUsers = listUsers;
  }

  Future<void> getListUser(String selectedNameOfUserList) async {
    db
        .collection("appusers")
        .where("role", whereIn: [student, teacher])
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

            // Kiểm tra điều kiện và thêm vào danh sách nếu phù hợp
            if ((_role == principal &&
                    selectedNameOfUserList == studentList &&
                    appUser.role == student) ||
                (_role == principal &&
                    selectedNameOfUserList == teacherList &&
                    appUser.role == teacher) ||
                (_role == teacher &&
                    appUser.role == student &&
                    appUser.techerId == _uid)) {
              listUsers.add(appUser);
            }
          }
          print("getListUser");
          notifyListeners();
        })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Error completing: $error"));
  }

  Future<void> addAppUser(BuildContext context, {required String email}) async {
    String? teacherName;
    Map<String, dynamic> updateData = {};

    if (_role == teacher) {
      QuerySnapshot snapshot = await db
          .collection('appusers')
          .where('uid', isEqualTo: _uid)
          .get();
      teacherName = snapshot.docs.first.get('na');
    }

    QuerySnapshot snapshot =
        await db.collection('appusers').where('email', isEqualTo: email).get();
    for (var doc in snapshot.docs) {
      switch (_role) {
        case "Principal":
          updateData = {"role": teacher};
          break;
        case "Teacher":
          updateData = {
            "role": student,
            "teid": _uid,
            "tena": teacherName,
            "mapo": "",
            "chepo": "",
          };
          break;
      }
      await doc.reference.set(updateData, SetOptions(merge: true));

      listUsers.add(AppUser(
        id: doc.id,
        email: email,
        techerId: _uid,
        techerName: teacherName,
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
    if (role == student) {
      dataUpdate['mapo'] = mapo;
      dataUpdate['chepo'] = chepo;
    }
    if (role == teacher) {
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
    await db.collection("appusers").doc(id).update(dataUpdate);

    for (var user in listUsers) {
      if (user.id == id) {
        user.name = name;
        if (role == student) {
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
    if (role == teacher) {
      DocumentSnapshot snapshot = await db.collection('appusers').doc(id).get();
      String teacherName = snapshot.get('na');
      db
          .collection("appusers")
          .where("role", isEqualTo: student)
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
            user.techerName!.toLowerCase().contains(teName.toLowerCase()))
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