import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPageController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void register(BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('appusers')
            .doc(user.uid)
            .set({
          'na': nameController.text,
          'email': emailController.text,
          'uid': user.uid,
          'role': "",
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng kí thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng kí thất bại: $e')),
      );
    }
  }
}
