// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/constant/isstatuspage.dart';
import 'package:flutter_datatable/modal/appuser.dart';
import 'package:flutter_datatable/constant/constant.dart';
import 'package:flutter_datatable/manager/currentuser.dart';
import 'package:flutter_datatable/constant/userlisttype.dart';

class UserListPageController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<AppUser> listUsers = [];
  final int pageSize = 2;
  final UserListType type;
  TextEditingController filteredTeacherNameController = TextEditingController();

  DocumentSnapshot? firstDocInCurrentPage;
  DocumentSnapshot? lastDocInCurrentPage;
  IsStatusPage isStatusPage = IsStatusPage.firstpage;

  int numberOfCurrentPage = 1;
  int totalPages = 0;
  int totalDocs = 0;
  int docsInLastPage = 0;

  UserListPageController({
    required this.type,
  }) {
    getListUser(userlisttype: type);
  }

  Future<void> getListUser({
    required UserListType userlisttype,
    IsStatusPage? isStatusPage,
    String? filteredTeacherName,
    int? docsInLastPage,
  }) async {
    Query query = db.collection(Constant.COLLECTION);

    if (userlisttype == UserListType.studentsofteacher) {
      query = query.where("teid", isEqualTo: CurrentUser().uid);
    } else if (userlisttype == UserListType.teachers) {
      query = query.where("role", isEqualTo: "Teacher");
    } else if (userlisttype == UserListType.allstudents) {
      if (filteredTeacherName == "") {
        query = query.where("role", isEqualTo: "Student");
      } else {
        query = query.where("tena", isEqualTo: filteredTeacherName);
      }
    }

    if (isStatusPage == IsStatusPage.nextpage) {
      query = query
          .orderBy("uid")
          .startAfterDocument(lastDocInCurrentPage!)
          .limit(pageSize);
    } else if (isStatusPage == IsStatusPage.previouspage) {
      query = query
          .orderBy("uid", descending: true)
          .startAfterDocument(firstDocInCurrentPage!)
          .limit(pageSize);
    } else if (isStatusPage == IsStatusPage.lastpage) {
      query = query.orderBy("uid").limitToLast(docsInLastPage!);
    } else {
      query = query.orderBy("uid").limit(pageSize);
      numberOfCurrentPage = 1;
      firstDocInCurrentPage = null;
      lastDocInCurrentPage = null;
    }

    query.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        if (isStatusPage == IsStatusPage.previouspage) {
          firstDocInCurrentPage = snapshot.docs.last;
          lastDocInCurrentPage = snapshot.docs.first;
        } else {
          firstDocInCurrentPage = snapshot.docs.first;
          lastDocInCurrentPage = snapshot.docs.last;
        }

        listUsers.clear();
        for (var docUser in snapshot.docs) {
          AppUser appUser;
          if (userlisttype == UserListType.teachers) {
            appUser = AppUser(
              id: docUser.id,
              role: docUser.get("role"),
              uid: docUser.get("uid"),
              email: docUser.get("email"),
              name: docUser.get("na"),
            );
          } else {
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
          }

          if (isStatusPage == IsStatusPage.previouspage) {
            listUsers.insert(0, appUser);
          } else {
            listUsers.add(appUser);
          }
        }
        print("getListUser");
        notifyListeners();
      }
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print("Error completing: $error"));
  }

  Future<void> calculateTotalPages(
      {required UserListType type, String? filteredTeacherName}) async {
    Query query = db.collection("appusers");
    if (type == UserListType.studentsofteacher) {
      query = query.where("teid", isEqualTo: CurrentUser().uid);
    } else if (type == UserListType.teachers) {
      query = query.where("role", isEqualTo: "Teacher");
    } else if (type == UserListType.allstudents) {
      if (filteredTeacherName == "") {
        query = query.where("role", isEqualTo: "Student");
      } else {
        query = query.where("tena", isEqualTo: filteredTeacherName);
      }
    }

    AggregateQuerySnapshot countSnapshot = await query.count().get();
    totalDocs = countSnapshot.count!;
    if (totalDocs > 0) {
      totalPages = (totalDocs / pageSize).ceil();
      docsInLastPage = totalDocs - (totalPages - 1) * pageSize;
    }
  }

  Future<void> goToPage(
      {required UserListType type,
      IsStatusPage? isStatusPage,
      String? filteredTeacherName}) async {
    if (isStatusPage == IsStatusPage.lastpage) {
      await calculateTotalPages(
          type: type, filteredTeacherName: filteredTeacherName);
      numberOfCurrentPage = totalPages;
      await getListUser(
        userlisttype: type,
        isStatusPage: isStatusPage,
        docsInLastPage: docsInLastPage,
        filteredTeacherName: filteredTeacherName,
      );
    } else if (isStatusPage == IsStatusPage.previouspage) {
      if (numberOfCurrentPage > 1) {
        numberOfCurrentPage--;
        await getListUser(
          userlisttype: type,
          isStatusPage: isStatusPage,
          filteredTeacherName: filteredTeacherName,
        );
      }
    } else if (isStatusPage == IsStatusPage.nextpage) {
      if (lastDocInCurrentPage != null) {
        numberOfCurrentPage++;
        await getListUser(
          userlisttype: type,
          isStatusPage: isStatusPage,
          filteredTeacherName: filteredTeacherName,
        );
      }
    } else {
      await getListUser(
        userlisttype: type,
        filteredTeacherName: filteredTeacherName,
      );
    }
  }

  Future<void> addAppUser(BuildContext context, {required String email}) async {
    Map<String, dynamic> updateData = {};

    QuerySnapshot snapshot = await db
        .collection('appusers')
        .where('role', isEqualTo: "")
        .where('email', isEqualTo: email)
        .get();
    for (var doc in snapshot.docs) {
      if (CurrentUser().role == Constant.ROLE_PRINCIPLE) {
        updateData = {"role": Constant.ROLE_TEACHER};
      } else if (CurrentUser().role == Constant.ROLE_TEACHER) {
        updateData = {
          "role": Constant.ROLE_STUDENT,
          "teid": CurrentUser().uid,
          "tena": CurrentUser().name,
          "mapo": "",
          "chepo": "",
        };
      }
      await doc.reference.update(updateData);
      listUsers.add(AppUser(
        id: doc.id,
        email: email,
        teacherID: CurrentUser().uid,
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
      String? teacherID,
      String? mapo,
      String? chepo}) async {
    WriteBatch batch = db.batch();

    Map<String, dynamic> dataUpdate = {
      "mapo": mapo,
      "chepo": chepo,
    };

    DocumentReference userDocRef = db.collection(Constant.COLLECTION).doc(id);
    batch.update(userDocRef, dataUpdate);

    try {
      await batch.commit();
    } catch (e) {
      print("Error in batch update: $e");
    }

    for (var user in listUsers) {
      if (user.id == id) {
        user.mathpoint = mapo;
        user.chemistpoint = chepo;
      }
    }
    notifyListeners();
  }

  Future<void> deleteAppUser({
    required String id,
    required String role,
  }) async {
    WriteBatch batch = db.batch();
    Map<String, dynamic> dataUpdate = {
      "role": "",
      "teid": FieldValue.delete(),
      "tena": FieldValue.delete(),
      "mapo": FieldValue.delete(),
      "chepo": FieldValue.delete(),
    };

    DocumentReference userDocRef = db.collection(Constant.COLLECTION).doc(id);
    batch.update(userDocRef, dataUpdate);

    if (role == Constant.ROLE_TEACHER) {
      QuerySnapshot querySnapshot = await db
          .collection(Constant.COLLECTION)
          .where('teid', isEqualTo: id)
          .get();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, dataUpdate);
      }
    }

    try {
      await batch.commit();
    } catch (e) {
      print("Error in batch update: $e");
    }

    listUsers.removeWhere((user) => user.id == id);
    notifyListeners();
  }
}
