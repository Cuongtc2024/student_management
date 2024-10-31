import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPageController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void register(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      DocumentSnapshot counterSnapshot = await FirebaseFirestore.instance
          .collection('system')
          .doc('counter')
          .get();
      int currentCounter = counterSnapshot['value'];

      String newUid = 'U${currentCounter.toString().padLeft(6, '0')}';
      

      if (user != null) {
        
            await FirebaseFirestore.instance
                .collection('appusers')
                .doc(newUid)
                .set({
              'na': nameController.text,
              'email': emailController.text,
              'role': '',
              'uid': user.uid,
            });
            
        }
      

      // // Tăng counter lên 1
      await FirebaseFirestore.instance
          .collection('system')
          .doc('counter')
          .update({'value': currentCounter + 1});

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng kí thành công')),
      );
    } catch (e) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng kí thất bại: $e')),
      );
    }
  }

  
}
