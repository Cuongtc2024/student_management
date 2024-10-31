// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/appuserpagecontroller.dart';
import 'package:flutter_datatable/userdatasource.dart';
import 'package:flutter_datatable/userdetailsdialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AppUserPage extends StatelessWidget {
  String role;
  String? newValue;
  AppUserPageController controller = AppUserPageController();

  AppUserPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trang thông tin người dùng')),
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
                child: role == "Student"
                    ? buildStudentInfo()
                    : role == "Teacher"
                        ? buildTeacherInfo()
                        : role == "Principal"
                            ? buildPrincipalInfo()
                            : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  Column buildStudentInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExpansionTile(
          title: Text(
            'Thông tin người dùng',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            Consumer<AppUserPageController>(
              builder: (context, controller, child) => DataTable(
                  // columnSpacing: 150,
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
                  rows: List<DataRow>.generate(
                      controller.listUsers.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(controller.listUsers[index].name,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(controller.listUsers[index].email,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(
                                controller.listUsers[index].mapo.toString(),
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(
                                controller.listUsers[index].chepo.toString(),
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(
                                controller.listUsers[index].techerName
                                    .toString(),
                                style: TextStyle(color: Colors.white))),
                          ]))),
            )
          ],
        ),
      ],
    );
  }

  Column buildTeacherInfo() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExpansionTile(
          title: Text(
            'Thông tin người dùng',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            Consumer<AppUserPageController>(
              builder: (context, controller, child) => DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      'Tên',
                      style: TextStyle(color: Colors.white),
                      selectionColor: Colors.green,
                    )),
                    DataColumn(
                        label: Text(
                      'Email',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                  rows: List<DataRow>.generate(
                      controller.listUsers.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(controller.listUsers[index].name,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(controller.listUsers[index].email,
                                style: TextStyle(color: Colors.white))),
                          ]))),
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            'Danh sách sinh viên',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            Consumer<AppUserPageController>(
              builder: (context, controller, child) => DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      'Tên',
                      style: TextStyle(color: Colors.white),
                      selectionColor: Colors.green,
                    )),
                    DataColumn(
                        label: Text(
                      'Email',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      'Điểm Toán',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      'Điểm Hóa',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      '',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                  rows: List<DataRow>.generate(
                      controller.listStudentsOfTeacher.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(
                                controller.listStudentsOfTeacher[index].name,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(
                                controller.listStudentsOfTeacher[index].email,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(
                                controller.listStudentsOfTeacher[index].mapo
                                    .toString(),
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(
                                controller.listStudentsOfTeacher[index].chepo
                                    .toString(),
                                style: TextStyle(color: Colors.white))),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              UserDetailsDialog(
                                                controller: controller,
                                                role: controller
                                                    .listStudentsOfTeacher[
                                                        index]
                                                    .role,
                                                id: controller
                                                    .listStudentsOfTeacher[
                                                        index]
                                                    .id,
                                                name: controller
                                                    .listStudentsOfTeacher[
                                                        index]
                                                    .name,
                                                mapo: controller
                                                    .listStudentsOfTeacher[
                                                        index]
                                                    .mapo
                                                    .toString(),
                                                chepo: controller
                                                    .listStudentsOfTeacher[
                                                        index]
                                                    .chepo
                                                    .toString(),
                                              ));
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white)),
                                const SizedBox(
                                  width: 8,
                                ),
                                IconButton(
                                    onPressed: () {
                                      controller.deleteAppUser(
                                          id: controller
                                              .listStudentsOfTeacher[index].id,
                                          role: controller
                                              .listStudentsOfTeacher[index]
                                              .role);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red)),
                              ],
                            ))
                          ]))),

              // DataTable(
              //     columns: [
              //       DataColumn(
              //           label: Text(
              //         'Tên',
              //         style: TextStyle(color: Colors.white),
              //         selectionColor: Colors.green,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         'Email',
              //         style: TextStyle(color: Colors.white),
              //       )),
              //       DataColumn(
              //           label: Text(
              //         'Điểm Toán',
              //         style: TextStyle(color: Colors.white),
              //       )),
              //       DataColumn(
              //           label: Text(
              //         'Điểm Hóa',
              //         style: TextStyle(color: Colors.white),
              //       )),
              //       DataColumn(
              //           label: Text(
              //         '',
              //         style: TextStyle(color: Colors.white),
              //       )),
              //     ],
              //     rows: List<DataRow>.generate(
              //         controller.listStudentsOfTeacher.length,
              //         (index) => DataRow(cells: [
              //               DataCell(Text(controller.listStudentsOfTeacher[index].name,
              //                   style: TextStyle(color: Colors.white))),
              //               DataCell(Text(controller.listStudentsOfTeacher[index].email,
              //                   style: TextStyle(color: Colors.white))),
              //               DataCell(Text(
              //                   controller.listStudentsOfTeacher[index].mapo.toString(),
              //                   style: TextStyle(color: Colors.white))),
              //               DataCell(Text(
              //                   controller.listStudentsOfTeacher[index].chepo.toString(),
              //                   style: TextStyle(color: Colors.white))),
              //               DataCell(Row(
              //                 children: [
              //                   IconButton(
              //                       onPressed: () {
              //                         showDialog(
              //                             context: context,
              //                             builder: (BuildContext context) =>
              //                                 UserDetailsDialog(
              //                                   controller: controller,
              //                                   role: controller
              //                                       .listStudentsOfTeacher[index].role,
              //                                   id: controller
              //                                       .listStudentsOfTeacher[index].id,
              //                                   teid: controller
              //                                       .listStudentsOfTeacher[index].techerId,
              //                                   name: controller
              //                                       .listStudentsOfTeacher[index].name,
              //                                   mapo: controller
              //                                       .listStudentsOfTeacher[index].mapo
              //                                       .toString(),
              //                                   chepo: controller
              //                                       .listStudentsOfTeacher[index].chepo
              //                                       .toString(),
              //                                 ));
              //                       },
              //                       icon: const Icon(Icons.edit,
              //                           color: Colors.white)),
              //                   const SizedBox(
              //                     width: 8,
              //                   ),
              //                   IconButton(
              //                       onPressed: () {
              //                         controller.deleteUser(
              //                             controller.listStudentsOfTeacher[index].id);
              //                       },
              //                       icon: const Icon(Icons.delete,
              //                           color: Colors.red)),
              //                 ],
              //               ))
              //             ]))),
            ),
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
                                  currentUserRole: role,
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
                            'Thêm sinh viên mới',
                            style: TextStyle(color: Colors.white, fontSize: 15),
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
      ],
    );
  }

  Column buildPrincipalInfo() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExpansionTile(
          title: Text(
            'Thông tin người dùng',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            Consumer<AppUserPageController>(
              builder: (context, controller, child) => DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      'Tên',
                      style: TextStyle(color: Colors.white),
                      selectionColor: Colors.green,
                    )),
                    DataColumn(
                        label: Text(
                      'Email',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                  rows: List<DataRow>.generate(
                      controller.listUsers.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(controller.listUsers[index].name,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(controller.listUsers[index].email,
                                style: TextStyle(color: Colors.white))),
                          ]))),
            )
          ],
        ),
        ExpansionTile(
          title: Text(
            'Danh sách sinh viên',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Nhập tên để lọc',
                    labelStyle: TextStyle(color: Colors.white)),
                onChanged: (value) {
                  controller.filterByTeacherName(value);
                }),
            Consumer<AppUserPageController>(
              builder: (context, controller, child) => PaginatedDataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      'Tên',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'Email',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'Điểm Toán',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'Điểm Hóa',
                      style: TextStyle(color: Colors.black),
                    )),
                    DataColumn(
                        label: Text(
                      'Giáo viên',
                      style: TextStyle(color: Colors.black),
                    )),
                  ],
                  source: StudentDataSource(controller.filteredStudents),
                  rowsPerPage: 2,
                  showCheckboxColumn: true),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            'Danh sách giáo viên',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            Consumer<AppUserPageController>(
              builder: (context, controller, child) => DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      'Tên',
                      style: TextStyle(color: Colors.white),
                      selectionColor: Colors.green,
                    )),
                    DataColumn(
                        label: Text(
                      'Email',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      '',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                  rows: List<DataRow>.generate(
                      controller.listTeachers.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(controller.listTeachers[index].name,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text(controller.listTeachers[index].email,
                                style: TextStyle(color: Colors.white))),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              UserDetailsDialog(
                                                controller: controller,
                                                role: controller
                                                    .listTeachers[index].role,
                                                id: controller
                                                    .listTeachers[index].id,
                                                name: controller
                                                    .listTeachers[index].name,
                                              ));
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white)),
                                const SizedBox(
                                  width: 8,
                                ),
                                IconButton(
                                    onPressed: () {
                                      controller.deleteAppUser(
                                        id: controller.listTeachers[index].id,
                                        role: controller.listTeachers[index].role);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red)),
                              ],
                            ))
                          ]))),
            ),
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
                                  currentUserRole: role,
                                  controller: controller,
                                ));
                      },
                      icon: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Thêm giáo viên mới',
                            style: TextStyle(color: Colors.white, fontSize: 15),
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
      ],
    );
  }
}
