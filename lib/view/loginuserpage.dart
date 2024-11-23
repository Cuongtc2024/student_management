// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_datatable/controller/loginuserpagecontroller.dart';
import 'package:flutter_datatable/view/registerpage.dart';
import 'package:flutter_datatable/view/usermenupage.dart';

// ignore: must_be_immutable
class LoginUserPage extends StatelessWidget {
  LoginUserPage({super.key});

  LoginUserPageController controller = LoginUserPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                color: Colors.black,
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          labelText: 'Tên đăng nhập',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            labelStyle: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                          onPressed: () async {
                            final result = await controller.login(context);
                            if (result.isEmpty) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserMenuPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)),
                              );
                            }
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(color: Colors.white),
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Registerpage()), // Chuyển sang trang đăng ký
                          );
                        },
                        child: Text('Chưa có tài khoản? Đăng ký ngay'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
