import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuser.dart';
import 'package:flutter_datatable/userdetailsdialog.dart';
import 'package:flutter_datatable/userpagecontroller.dart';

class UserDataSource extends DataTableSource {
  String studentList = "Student List";
  String teacherList = "Teacher List";
  String student = "Student";
  String principal = "Principal";
  String teacher = "Teacher";
  final String listName;
  final List<AppUser> list;
  final BuildContext context;
  final UserPageController controller;
  UserDataSource(
      {required this.list,
      required this.controller,
      required this.context,
      required this.listName});

  @override
  DataRow? getRow(int index) {
    if (index >= list.length) return null;
    final st = list[index];

    return listName == studentList
        ? buildStudentData(st, index)
        : buildTeacherData(st, index);
  }

  DataRow buildStudentData(AppUser st, int index) {
    return DataRow(cells: [
      DataCell(Text(
        st.name,
        style: TextStyle(color: Colors.black),
      )),
      DataCell(Text(
        st.email,
        style: TextStyle(color: Colors.black),
      )),
      DataCell(Text(
        st.mathpoint.toString(),
        style: TextStyle(color: Colors.black),
      )),
      DataCell(Text(
        st.chemistpoint.toString(),
        style: TextStyle(color: Colors.black),
      )),
      DataCell(Text(
        st.techerName.toString(),
        style: TextStyle(color: Colors.black),
      )),
      if (controller.roleOfCurrentUser == teacher) callUserDetailsDialog(index)
    ]);
  }

  DataRow buildTeacherData(AppUser st, int index) {
    return DataRow(cells: [
      DataCell(Text(
        st.name,
        style: TextStyle(color: Colors.black),
      )),
      DataCell(Text(
        st.email,
        style: TextStyle(color: Colors.black),
      )),
      if (controller.roleOfCurrentUser == principal)
        callUserDetailsDialog(index)
    ]);
  }

  DataCell callUserDetailsDialog(int index) {
    return DataCell(Row(
      children: [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => UserDetailsDialog(
                        controller: controller,
                        role: controller.listUsers[index].role,
                        id: controller.listUsers[index].id,
                        name: controller.listUsers[index].name,
                        mapo: controller.listUsers[index].mathpoint.toString(),
                        chepo:
                            controller.listUsers[index].chemistpoint.toString(),
                      ));
            },
            icon: const Icon(Icons.edit, color: Colors.black)),
        const SizedBox(
          width: 8,
        ),
        IconButton(
            onPressed: () {
              controller.deleteAppUser(
                  id: controller.listUsers[index].id,
                  role: controller.listUsers[index].role);
            },
            icon: const Icon(Icons.delete, color: Colors.red)),
      ],
    ));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => list.length;

  @override
  int get selectedRowCount => 0;
}
