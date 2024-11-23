import 'package:flutter/material.dart';
import 'package:flutter_datatable/constant/constant.dart';
import 'package:flutter_datatable/constant/isstatuspage.dart';
import 'package:flutter_datatable/manager/currentuser.dart';
import 'package:flutter_datatable/view/userdetailsdialog.dart';
import 'package:flutter_datatable/controller/userlistpagecontroller.dart';
import 'package:flutter_datatable/constant/userlisttype.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatelessWidget {
  UserListType type;  
  late UserListPageController controller;
  UserListPage({super.key, required this.type}) {
    controller = UserListPageController(type: type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == UserListType.teachers
              ? "Danh sách giáo viên"
              : "Danh sách sinh viên")),
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
                      Consumer<UserListPageController>(
                        builder: (context, controller, child) => Column(
                          children: [
                            // neu user dang nhap co role la Principal va xem studentpage
                            //thi co them filter theo ten giao vien
                            if ((CurrentUser().role == Constant.ROLE_PRINCIPLE) &&
                                (type == UserListType.allstudents))
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: TextField(
                                      controller: controller
                                          .filteredTeacherNameController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          labelText: 'Nhập tên giáo viên',
                                          labelStyle:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        controller.getListUser(
                                            userlisttype:
                                                UserListType.allstudents,
                                            filteredTeacherName: controller
                                                .filteredTeacherNameController
                                                .text);
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
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
                                //  truong hop Studentpage
                                if (type != UserListType.teachers) ...[
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
                                // truong hop role user dang nhap la Teacher
                                // hoac truong hop role user dang nhap la Principle va Teacherpage 
                                if ((CurrentUser().role == Constant.ROLE_TEACHER) ||
                                    ((type == UserListType.teachers) &&
                                        (CurrentUser().role == Constant.ROLE_PRINCIPLE)))
                                  DataColumn(
                                      label: Text(
                                    '',
                                    style: TextStyle(color: Colors.white),
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
                                        if (type != UserListType.teachers) ...[
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
                                        // truong hop role user dang nhap la Teacher co button edit va delete
                                        if (CurrentUser().role == Constant.ROLE_TEACHER)
                                          buildEditAndDeleteIcon(
                                              context,
                                              controller,
                                              index,
                                              UserDetailsDialog(
                                                controller: controller,
                                                role: controller
                                                    .listUsers[index].role,
                                                id: controller
                                                    .listUsers[index].id,
                                                name: controller
                                                    .listUsers[index].name,
                                                mapo: controller
                                                    .listUsers[index].mathpoint
                                                    .toString(),
                                                chepo: controller
                                                    .listUsers[index]
                                                    .chemistpoint
                                                    .toString(),
                                              )),
                                        // truong hop role user dang nhap la Principle va Teacherpage
                                        // chi co button delete
                                        if ((type == UserListType.teachers) &&
                                            (CurrentUser().role == Constant.ROLE_PRINCIPLE))
                                          buildEditAndDeleteIcon(
                                              context,
                                              controller,
                                              index,
                                              UserDetailsDialog(
                                                controller: controller,
                                                role: controller
                                                    .listUsers[index].role,
                                                id: controller
                                                    .listUsers[index].id,
                                                name: controller
                                                    .listUsers[index].name,                                                
                                              ))
                                      ])),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildElevatedButton(Constant.PAGE_FIRST,
                                    IsStatusPage.firstpage),
                                SizedBox(width: 10),
                                buildElevatedButton(Constant.PAGE_PREVIOUS,
                                    IsStatusPage.previouspage),
                                SizedBox(width: 10),
                                buildElevatedButton(
                                    Constant.PAGE_NEXT, IsStatusPage.nextpage),
                                SizedBox(width: 10),
                                buildElevatedButton(
                                    Constant.PAGE_LAST, IsStatusPage.lastpage),
                              ],
                            ),
                            // truong hop role user dang nhap la Teacher
                            // hoac truong hop teacherpage va role user dang nhap la Principle 
                            // thi co button them moi nguoi dung
                            if ((CurrentUser().role == Constant.ROLE_TEACHER) ||
                                ((type == UserListType.teachers) &&
                                    (CurrentUser().role == Constant.ROLE_PRINCIPLE)))
                              Builder(
                                builder: (context) => Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  UserDetailsDialog(
                                                    controller: controller,
                                                  ));
                                        },
                                        //  tooltip: 'Thêm nhân viên mới',
                                        icon: const Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Thêm người dùng mới',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

  DataCell buildEditAndDeleteIcon(BuildContext context,
      UserListPageController controller, int index, Widget widget) {
    return DataCell(Row(
      children: [
        // neu role user dang nhap la Teacher thi co button edit
        if (CurrentUser().role == Constant.ROLE_TEACHER)
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => widget);
              },
              icon: const Icon(Icons.edit, color: Colors.white)),
        const SizedBox(
          width: 8,
        ),
        IconButton(
            onPressed: () {
              controller.deleteAppUser(
                  id: controller.listUsers[index].id,
                  role: controller.listUsers[index].role.toString());
            },
            icon: const Icon(Icons.delete, color: Colors.red)),
      ],
    ));
  }

  ElevatedButton buildElevatedButton(String title, IsStatusPage statusPage) {
    return ElevatedButton(
      onPressed: () {
        type == UserListType.allstudents
            ? controller.goToPage(
                type: UserListType.allstudents,
                isStatusPage: statusPage,
                filteredTeacherName:
                    controller.filteredTeacherNameController.text)
            : type == UserListType.studentsofteacher
                ? controller.goToPage(
                    type: UserListType.studentsofteacher,
                    isStatusPage: statusPage)
                : controller.goToPage(
                    type: UserListType.teachers, isStatusPage: statusPage);
      },
      child: Text(title),
    );
  }
}
