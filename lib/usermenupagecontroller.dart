// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/currentuser.dart';

class UserMenuPageController extends ChangeNotifier {
  
  final FirebaseAuth auth = FirebaseAuth.instance;  

  Future<void> logout(BuildContext context) async {
    try {
      await auth.signOut();
      CurrentUser().uid = null;
      CurrentUser().role = null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng xuất thất bại: $e')),
      );
    }
  }

  
}
