import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuser.dart';
// import 'package:flutter_datatable/appuserpagecontroller.dart';

 class StudentDataSource extends DataTableSource {

final List<AppUser> lists;
  StudentDataSource(this.lists);
// final AppUserPageController controller;
//   StudentDataSource(this.controller);

@override
  DataRow? getRow(int index) {
    if (index >= lists.length) return null;
    final st = lists[index];

    return DataRow(
      // color: WidgetStateProperty.all(Colors.black),
      cells: [
      DataCell(Text(st.name, style: TextStyle(color: Colors.black ),)),
      DataCell(Text(st.email, style: TextStyle(color: Colors.black ),)),
      DataCell(Text(st.mapo.toString(), style: TextStyle(color: Colors.black ),)),
      DataCell(Text(st.chepo.toString(), style: TextStyle(color: Colors.black ),)),
      DataCell(Text(st.techerName.toString(), style: TextStyle(color: Colors.black ),)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => lists.length;
  

  @override
  int get selectedRowCount => 0;

  // List<AppUser> filterByTeacherName(String teacherName)
  //  => lists.where((user) => user.name.toLowerCase().contains(teacherName.toLowerCase())).toList();
}