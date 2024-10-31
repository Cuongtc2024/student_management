import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuserpage.dart';
// import 'package:flutter_datatable/principalpage.dart';
// import 'package:flutter_datatable/studentpage.dart';
// import 'package:flutter_datatable/teacherpage.dart';

class LoginUserPageController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // String? errorMessage;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Lấy vai trò của người dùng từ Firestore với doc ID cụ thể
        // DocumentSnapshot snapshot = await FirebaseFirestore.instance
        //     .collection('newusers')
        //     .doc(user.uid)
        //     .get();
        QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appusers')
          .where('uid', isEqualTo: user.uid)
          .get();
        String role = snapshot.docs.first.get('role');
        // String email = snapshot.docs.first.get('email');
        // String userId = snapshot.docs.first.id;
        // Điều hướng tới màn hình tương ứng với vai trò
        // if (role == 'Student') {
          // DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          //   .collection('students')
          //   .doc(userId)
          //   .get();
            // String name = studentDoc['na'];
            // String point = studentDoc['po'];
            // String teacherId = studentDoc['teid'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppUserPage(role: role)),
          );
        // } else if (role == 'Teacher') {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => AppUserPage(role: role)),
        //   );
        // } else if (role == 'Principal') {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => PrincipalPage(user: user,)),
        //   );
        // }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đăng nhập thất bại: $e')),
    );
      // print("Login failed: $e");
    }
  }
}