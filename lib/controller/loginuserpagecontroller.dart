import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/manager/currentuser.dart';

class LoginUserPageController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String> login(BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot snapshot =
            await db.collection('appusers').doc(user.uid).get();
        CurrentUser().uid = user.uid;
        CurrentUser().name = snapshot.get('na');
        CurrentUser().role = snapshot.get('role');

        print('role1' + CurrentUser().role!);
      }
      // if (user != null) {
      //   QuerySnapshot snapshot = await FirebaseFirestore.instance
      //       .collection('appusers')
      //       .where('uid', isEqualTo: user.uid)
      //       .get();
      //   CurrentUser().uid = user.uid;
      //   CurrentUser().role = snapshot.docs.first.get('role');
      //   CurrentUser().name = snapshot.docs.first.get('na');
      //   print('role1' +  CurrentUser().role!);
      // }
      return "";
    } catch (e) {
      if (e is FirebaseAuthException) {
        return "Loi dang nhap";
      } else {
        return "Ko truy xuat dc database";
      }
    }
  }
}
