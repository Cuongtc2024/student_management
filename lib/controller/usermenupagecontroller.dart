// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/manager/currentuser.dart';

class UserMenuPageController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> logout(BuildContext context) async {
    try {
      await auth.signOut();
      CurrentUser().uid = null;
      CurrentUser().role = null;
      return "";
    } catch (e) {
      return 'Đăng xuất thất bại: $e';
    }
  }
}
