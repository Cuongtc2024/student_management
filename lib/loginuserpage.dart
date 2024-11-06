// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_datatable/loginuserpagecontroller.dart';
import 'package:flutter_datatable/registerpage.dart';
import 'package:flutter_datatable/usermenupage.dart';

// ignore: must_be_immutable
class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
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
                          onPressed: () {
                            controller.login(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserMenuPage(
                                        role: controller.roleOfCurrentUser)),
                            );
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
      // body: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Column(
      //       children: [
      //         Container(
      //           padding: const EdgeInsets.all(5),
      //           color: Colors.black,
      //           child: SizedBox(
      //             height: 500,
      //             width: 1000,
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 const Row(
      //                   children: [
      //                     Icon(Icons.arrow_back, color: Colors.white),
      //                     SizedBox(
      //                       width: 8,
      //                     ),
      //                     Text(
      //                       'Nhân viên',
      //                       style: TextStyle(color: Colors.white),
      //                     )
      //                   ],
      //                 ),
      //                 const Text(
      //                   'Danh sách nhân viên',
      //                   style: TextStyle(color: Colors.white),
      //                 ),
      //                 Consumer<UserPageController>(builder: (context, controller, child) => DataTable(
      //                       columns: const [
      //                         DataColumn(
      //                             label: Text(
      //                           'Tên',
      //                           style: TextStyle(color: Colors.white),
      //                         )),
      //                         DataColumn(
      //                             label: Text(
      //                           'Vị trí',
      //                           style: TextStyle(color: Colors.white),
      //                         )),
      //                         DataColumn(
      //                             label: Text(
      //                           'Ngày sinh',
      //                           style: TextStyle(color: Colors.white),
      //                         )),
      //                         DataColumn(label: Text('')),
      //                       ],
      //                       rows: List<DataRow>.generate(
      //                           controller.listUsers.length,
      //                           (index) => DataRow(cells: [
      //                                 DataCell(Text(
      //                                     controller.listUsers[index].name,
      //                                     style: const TextStyle(color: Colors.white),)),
      //                                 DataCell(Text(
      //                                     controller.listUsers[index].role,
      //                                     style: const TextStyle(color: Colors.white),)),
      //                                 DataCell(Text(controller
      //                                     .listUsers[index].birthday,
      //                                     style: const TextStyle(color: Colors.white),)),
      //                                 DataCell(Row(
      //                                   children: [
      //                                     IconButton(
      //                                         onPressed: () {
      //                                           showDialog(
      //                                               context: context,
      //                                               builder: (BuildContext
      //                                                       context) =>
      //                                                   UserDetailsDialog(
      //                                                       id: controller.listUsers[index].id,
      //                                                       controller: controller,
      //                                                       birthday:
      //                                                           controller
      //                                                               .listUsers[index]
      //                                                               .birthday,
      //                                                       name: controller
      //                                                           .listUsers[index]
      //                                                           .name,
      //                                                       role: controller
      //                                                           .listUsers[index]
      //                                                           .role));
      //                                         },
      //                                         icon: const Icon(Icons.edit,
      //                                             color: Colors.white)),
      //                                     const SizedBox(
      //                                       width: 8,
      //                                     ),
      //                                     IconButton(
      //                                         onPressed: () {
      //                                           controller.deleteUser(controller
      //                                                           .listUsers[index].id);
      //                                         },
      //                                         icon: const Icon(Icons.delete,
      //                                             color: Colors.red)),
      //                                   ],
      //                                 ))
      //                               ]))),
      //                 ),
      //                 Container(
      //                   height: 35,
      //                   decoration: BoxDecoration(
      //                       color: Colors.lightBlue,
      //                       borderRadius: BorderRadius.circular(8)),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       IconButton(
      //                         onPressed: () {
      //                           showDialog(
      //                               context: context,
      //                               builder: (BuildContext context) =>
      //                                   UserDetailsDialog(
      //                                     controller: controller,
      //                                   ));
      //                         },
      //                         //  tooltip: 'Thêm nhân viên mới',
      //                         icon: const Row(
      //                           children: [
      //                             Icon(
      //                               Icons.add,
      //                               size: 20,
      //                               color: Colors.white,
      //                             ),
      //                             SizedBox(width: 8),
      //                             Text(
      //                               'Thêm nhân viên mới',
      //                               style: TextStyle(
      //                                   color: Colors.white, fontSize: 15),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     )
      //   ],
      // )
    );
  }
}