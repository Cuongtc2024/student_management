import 'package:flutter/material.dart';
import 'package:flutter_datatable/constant/constant.dart';
import 'package:flutter_datatable/controller/userinfopagecontroller.dart';
import 'package:flutter_datatable/manager/currentuser.dart';


import 'package:provider/provider.dart';

class UserInfoPage extends StatelessWidget {
  final _role = CurrentUser().role;
  UserInfoPageController controller = UserInfoPageController();
  UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông tin người dùng')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChangeNotifierProvider.value(
            value: controller,
            child: Container(
              color: Colors.black,
              child: SizedBox(
                  height: 800,
                  width: 800,
                  child: Column(
                    children: [
                      Consumer<UserInfoPageController>(
                        builder: (context, controller, child) => Column(
                          children: [
                            DataTable(
                              columns: [
                                DataColumn(
                                    label: Expanded(
                                        child: Text(
                                  'Tên',
                                  style: TextStyle(color: Colors.white),
                                ))),
                                DataColumn(
                                    label: Expanded(
                                        child: Text(
                                  'Email',
                                  style: TextStyle(color: Colors.white),
                                ))),
                                if (_role == Constant.ROLE_STUDENT) ...[
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    'Điểm Toán',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    'Điểm Hóa',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    'Giáo viên',
                                    style: TextStyle(color: Colors.white),
                                  ))),
                                ],
                                DataColumn(
                                    label: Text(
                                  '',
                                  style: TextStyle(color: Colors.black),
                                )),
                              ],
                              rows: List<DataRow>.generate(
                                  controller.listUsers.length,
                                  (index) => DataRow(cells: [
                                        DataCell(Text(
                                            controller.listUsers[index].name,
                                            style: TextStyle(
                                                color: Colors.white))),
                                        DataCell(Text(
                                            controller.listUsers[index].email,
                                            style: TextStyle(
                                                color: Colors.white))),
                                        if (_role == Constant.ROLE_STUDENT) ...[
                                          DataCell(Text(
                                              controller
                                                  .listUsers[index].mathpoint
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(
                                              controller
                                                  .listUsers[index].chemistpoint
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(Text(
                                              controller
                                                  .listUsers[index].teacherName
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white))),
                                        ],
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  controller.setNameForEditing(index);
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            title: Text(
                                                                'Nhập thông tin'),
                                                            content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  TextField(
                                                                    controller:
                                                                        controller.nameController,
                                                                    decoration: InputDecoration(
                                                                        labelText:
                                                                            'Name'),
                                                                  ),                                                                  
                                                                  ElevatedButton(
                                                                    onPressed: () =>
                                                                        controller
                                                                            .editInfoUser(id: controller.listUsers[index].id,
                                                                            name: controller.nameController.text),
                                                                    child: Text(
                                                                        'Save'),
                                                                  ),
                                                                ]));
                                                      });
                                                },
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.white)),
                                          ],
                                        ))
                                      ])),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
