// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuser.dart';

class AppUserPageController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final List<AppUser> listStudents = [];
  final List<AppUser> listStudentsOfTeacher = [];
  final List<AppUser> listTeachers = [];
  final List<AppUser> listUsers = [];
  List<AppUser> _filteredStudents = [];
  String? currentUid = FirebaseAuth.instance.currentUser?.uid;
  List<AppUser> get filteredStudents => _filteredStudents;

  AppUserPageController() {
    db
        .collection("appusers")
        .where('role', isEqualTo: 'Student')
        .snapshots()
        .listen((snapshot) {
      listStudents.clear();
      for (var docUser in snapshot.docs) {
        AppUser appUser = AppUser(
            id: docUser.id,
            techerId: docUser.get("teid"),
            techerName: docUser.get("tena"),
            role: docUser.get("role"),
            uid: docUser.get("uid"),
            email: docUser.get("email"),
            name: docUser.get("na"),
            chepo: docUser.get("chepo"),
            mapo: docUser.get("mapo"));
        listStudents.add(appUser);
      }
      notifyListeners();
    });

    _filteredStudents = listStudents;

    db
        .collection("appusers")
        .where('role', isEqualTo: 'Student')
        .snapshots()
        .listen((snapshot) {
      listStudentsOfTeacher.clear();
      for (var docUser in snapshot.docs) {
        if (currentUid == docUser.get("teid")) {
          AppUser appUser = AppUser(
              id: docUser.id,
              techerId: docUser.get("teid"),
              techerName: docUser.get("tena"),
              role: docUser.get("role"),
              uid: docUser.get("uid"),
              email: docUser.get("email"),
              name: docUser.get("na"),
              chepo: docUser.get("chepo"),
              mapo: docUser.get("mapo"));
          listStudentsOfTeacher.add(appUser);
        }
      }
      notifyListeners();
    });

    db
        .collection('appusers')
        .where('role', isEqualTo: 'Teacher')
        .snapshots()
        .listen((snapshot) {
      listTeachers.clear();
      for (var docUser in snapshot.docs) {
        AppUser appUser = AppUser(
          id: docUser.id,
          role: docUser.get("role"),
          uid: docUser.get("uid"),
          email: docUser.get("email"),
          name: docUser.get("na"),
        );
        listTeachers.add(appUser);
      }
      notifyListeners();
    });

    // Nếu dữ liệu thay đổi sau khi gọi get(), đoạn mã này sẽ không tự động nhận được những thay đổi đó.
    // Bạn phải gọi lại get() để lấy dữ liệu mới
    // db.collection("appusers").get().then(
    //   (snapshot) {
    //     listStudents.clear();
    //     listTeachers.clear();
    //     for (var docUser in snapshot.docs) {
    //       switch (docUser.get("role")) {
    //         case "Student":
    //           AppUser appUser = AppUser(
    //               id: docUser.id,
    //               techerId: docUser.get("teid"),
    //               role: docUser.get("role"),
    //               uid: docUser.get("uid"),
    //               email: docUser.get("email"),
    //               name: docUser.get("na"),
    //               chepo: docUser.get("chepo"),
    //               mapo: docUser.get("mapo"));
    //           listStudents.add(appUser);
    //           break;
    //         case "Teacher":
    //           AppUser appUser = AppUser(
    //             id: docUser.id,
    //             role: docUser.get("role"),
    //             uid: docUser.get("uid"),
    //             email: docUser.get("email"),
    //             name: docUser.get("na"),
    //           );
    //           listTeachers.add(appUser);
    //           break;
    //       }
    //     }
    //     notifyListeners();
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );

    db.collection("appusers").where('uid', isEqualTo: currentUid).get().then(
      (snapshot) {
        listUsers.clear();
        for (var docUser in snapshot.docs) {
          if (docUser.get('role') == "Student") {
            AppUser appUser = AppUser(
                id: docUser.id,
                techerId: docUser.get("teid"),
                techerName: docUser.get("tena"),
                role: docUser.get("role"),
                uid: docUser.get("uid"),
                email: docUser.get("email"),
                name: docUser.get("na"),
                chepo: docUser.get("chepo"),
                mapo: docUser.get("mapo"));
            listUsers.add(appUser);
          } else {
            AppUser appUser = AppUser(
              id: docUser.id,
              role: docUser.get("role"),
              uid: docUser.get("uid"),
              email: docUser.get("email"),
              name: docUser.get("na"),
            );
            listUsers.add(appUser);
          }
        }
        notifyListeners();
      },
      onError: (e) => print("Error completing: $e"),
    );

    // FirebaseFirestore.instance.collection("appusers").get().then(
    //   (snapshot) {
    //     for (var docUser in snapshot.docs) {
    //     AppUser appUser = AppUser(
    //           id: docUser.id,
    //           techerId: docUser.get("teid"),
    //           role: docUser.get("role"),
    //           uid: docUser.get("uid"),
    //           name: docUser.get("na"),
    //           chepo: docUser.get("chepo"),
    //           mapo: docUser.get("mapo"));
    //       listStudents.add(appUser);
    //     }
    //     notifyListeners();
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
  }

  addAppUser(BuildContext context, {required String email}) async {
    QuerySnapshot snapshot = await db
        .collection('appusers')
        .where('uid', isEqualTo: currentUid)
        .get();
    String teachername = snapshot.docs.first.get('na');
    String currentUserRole = snapshot.docs.first.get('role');

    db
        .collection("appusers")
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        switch (currentUserRole) {
          case "Principal":
            doc.reference.update({
              "role": "Teacher",
            });
            break;
          case "Teacher":
            doc.reference.set({
              "role": "Student",
              "teid": currentUid,
              "tena": teachername,
              "mapo": "",
              "chepo": "",
            }, SetOptions(merge: true));

            break;
        }
      }
    });
  }

  editAppUser(
      {required String id,
      required String role,
      required String name,
      String? mapo,
      String? chepo}) async {
    Map<String, String> dataToUpdate = {"na": name};
    if (role == 'Student') {
      dataToUpdate['mapo'] = mapo!;
      dataToUpdate['chepo'] = chepo!;
    } 
    DocumentSnapshot snapshot = await db.collection('appusers').doc(id).get();
    String teachername = snapshot.get('na');
    db.collection("appusers").doc(id).update(dataToUpdate);
    db
        .collection("appusers")
        .where('role', isEqualTo: "Student")
        .where('tena', isEqualTo: teachername)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({"tena": name,});
      }
    });

    // switch (role) {
    //   case "Student":
    //     db
    //         .collection("appusers")
    //         .doc(id)
    //         .update({"mapo": mapo, "na": name, "chepo": chepo});
    //     break;
    //   case "Teacher":
    //     DocumentSnapshot snapshot =
    //         await db.collection('appusers').doc(id).get();
    //     String teachername = snapshot.get('na');
    //     db.collection("appusers").doc(id).update({
    //       "na": name,
    //     });
    //     db
    //         .collection("appusers")
    //         .where('role', isEqualTo: "Student")
    //         .where('tena', isEqualTo: teachername)
    //         .get()
    //         .then((querySnapshot) {
    //       for (var doc in querySnapshot.docs) {
    //         doc.reference.update({
    //           "tena": name,
    //         });
    //       }
    //     });
    //     break;
    // }
  }

  deleteAppUser({required String id, required String role}) async {
    Map<String, String> dataToUpdate = {"role": "",};    
      if (role == "Student") {
      dataToUpdate["teid"] = "";
      dataToUpdate["tena"] = "";
    } 
    db.collection("appusers").doc(id).update(dataToUpdate);
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
          "role": "",
          "teid": "",
          "tena": "",
        });
      }
    });

    // switch (role) {
    //   case "Student":
    //     db.collection("appusers").doc(id).update({
    //       "role": "",
    //       "teid": "",
    //       "tena": "",
    //     });
    //     break;
    //   case "Teacher":
    //     DocumentSnapshot snapshot =
    //         await db.collection('appusers').doc(id).get();
    //     String teachername = snapshot.get('na');
    //     db.collection("appusers").doc(id).update({
    //       "role": "",
    //     });
    //     db
    //         .collection("appusers")
    //         .where('role', isEqualTo: "Student")
    //         .where('tena', isEqualTo: teachername)
    //         .get()
    //         .then((querySnapshot) {
    //       for (var doc in querySnapshot.docs) {
    //         doc.reference.update({
    //           "role": "",
    //           "teid": "",
    //           "tena": "",
    //         });
    //       }
    //     });
    //     break;
    // }
  }

  void filterByTeacherName(String teName) {
    _filteredStudents = listStudents
        .where((user) =>
            user.techerName!.toLowerCase().contains(teName.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
