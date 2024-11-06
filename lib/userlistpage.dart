import 'package:flutter/material.dart';
import 'package:flutter_datatable/currentuser.dart';
import 'package:flutter_datatable/userdatasource.dart';
import 'package:flutter_datatable/userdetailsdialog.dart';
import 'package:flutter_datatable/userlistpagecontroller.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatelessWidget {
  String studentList = "Student List";
  String teacherList = "Teacher List";
  String student = "Student";
  String principal = "Principal";
  String teacher = "Teacher";

  String listName;
  String? _role;
  UserListPageController controller = UserListPageController();
  UserListPage({super.key, required this.listName}) {
    _role = CurrentUser().role;
    controller.getListUser(listName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(listName == studentList
              ? "Danh sách sinh viên"
              : "Danh sách giáo viên")),
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
                        builder: (context, controller, child) =>
                            listName == studentList
                                ? buildStudentPage(context)
                                : buildTeacherPage(context),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Column buildStudentPage(BuildContext context) {
    return Column(
      children: [
        if (_role == principal)
          // Row(
          //   children: [
          //     TextField(
          //             style: TextStyle(color: Colors.white),
          //             decoration: InputDecoration(
          //                 labelText: 'Nhập tên giáo viên',
          //                 labelStyle: TextStyle(color: Colors.white)),
          //             controller: controller.teacherNameToFilterController,
          //             ),
          //     IconButton(
          //       onPressed: controller.,
          //       icon: Icon(Icons.search))
          //   ],
          // ),
          TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Nhập tên giáo viên',
                  labelStyle: TextStyle(color: Colors.white)),
              onChanged: (value) {
                controller.filterByTeacherName(value);
              }),
        PaginatedDataTable(
            columns: [
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Tên',
                style: TextStyle(color: Colors.black),
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Email',
                style: TextStyle(color: Colors.black),
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Điểm Toán',
                style: TextStyle(color: Colors.black),
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Điểm Hóa',
                style: TextStyle(color: Colors.black),
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Giáo viên',
                style: TextStyle(color: Colors.black),
              ))),
              if (_role == teacher)
                DataColumn(
                    label: Text(
                  '',
                  style: TextStyle(color: Colors.black),
                )),
            ],
            source: UserDataSource(
                listName: studentList,
                list: controller.filteredUsers,
                controller: controller,
                context: context),
            rowsPerPage: 2,
            showCheckboxColumn: true),
        if (_role == teacher) buildAddNewUserDialog(),
      ],
    );
  }

  Column buildTeacherPage(BuildContext context) {
    return Column(
      children: [
        PaginatedDataTable(
            columns: [
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Tên',
                style: TextStyle(color: Colors.black),
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Email',
                style: TextStyle(color: Colors.black),
              ))),
              if (_role == principal)
                DataColumn(
                    label: Text(
                  '',
                  style: TextStyle(color: Colors.black),
                )),
            ],
            source: UserDataSource(
                listName: teacherList,
                list: controller.listUsers,
                controller: controller,
                context: context),
            rowsPerPage: 2,
            showCheckboxColumn: true),
        if (_role == principal) buildAddNewUserDialog(),
      ],
    );
  }

  Builder buildAddNewUserDialog() {
    return Builder(
      builder: (context) => Container(
        height: 35,
        decoration: BoxDecoration(
            color: Colors.lightBlue, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => UserDetailsDialog(
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
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(listName == studentList
//               ? "Danh sách sinh viên"
//               : "Danh sách giáo viên")),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ChangeNotifierProvider.value(
//             value: controller,
//             child: Container(
//               color: Colors.black,
//               child: SizedBox(
//                   height: 800,
//                   width: 800,
//                   child: Column(
//                     children: [
//                       Consumer<UserPageController>(
//                         builder: (context, controller, child) => Column(
//                           children: [
//                             DataTable(
//                               columns: [
//                                 DataColumn(
//                                     label: Expanded(
//                                         child: Text(
//                                   'Tên',
//                                   style: TextStyle(color: Colors.white),
//                                 ))),
//                                 DataColumn(
//                                     label: Expanded(
//                                         child: Text(
//                                   'Email',
//                                   style: TextStyle(color: Colors.white),
//                                 ))),
//                                 if (listName == studentList) ...[
//                                   DataColumn(
//                                       label: Expanded(
//                                           child: Text(
//                                     'Điểm Toán',
//                                     style: TextStyle(color: Colors.white),
//                                   ))),
//                                   DataColumn(
//                                       label: Expanded(
//                                           child: Text(
//                                     'Điểm Hóa',
//                                     style: TextStyle(color: Colors.white),
//                                   ))),
//                                   DataColumn(
//                                       label: Expanded(
//                                           child: Text(
//                                     'Giáo viên',
//                                     style: TextStyle(color: Colors.white),
//                                   ))),
//                                 ],
//                                 if ((controller.roleOfCurrentUser == teacher &&
//                                         listName == studentList) ||
//                                     (controller.roleOfCurrentUser ==
//                                             principal &&
//                                         listName == teacherList))
//                                   DataColumn(
//                                       label: Text(
//                                     '',
//                                     style: TextStyle(color: Colors.white),
//                                   )),
//                               ],
//                               rows: List<DataRow>.generate(
//                                   controller.listUsers.length,
//                                   (index) => DataRow(cells: [
//                                         DataCell(Text(
//                                             controller.listUsers[index].name,
//                                             style: TextStyle(
//                                                 color: Colors.white))),
//                                         DataCell(Text(
//                                             controller.listUsers[index].email,
//                                             style: TextStyle(
//                                                 color: Colors.white))),
//                                         if (listName == studentList) ...[
//                                           DataCell(Text(
//                                               controller
//                                                   .listUsers[index].mathpoint
//                                                   .toString(),
//                                               style: TextStyle(
//                                                   color: Colors.white))),
//                                           DataCell(Text(
//                                               controller
//                                                   .listUsers[index].chemistpoint
//                                                   .toString(),
//                                               style: TextStyle(
//                                                   color: Colors.white))),
//                                           DataCell(Text(
//                                               controller
//                                                   .listUsers[index].techerName
//                                                   .toString(),
//                                               style: TextStyle(
//                                                   color: Colors.white))),
//                                         ],
//                                         if ((controller.roleOfCurrentUser ==
//                                                     teacher &&
//                                                 listName == studentList) ||
//                                             (controller.roleOfCurrentUser ==
//                                                     principal &&
//                                                 listName == teacherList))
//                                           DataCell(Row(
//                                             children: [
//                                               IconButton(
//                                                   onPressed: () {
//                                                     showDialog(
//                                                         context: context,
//                                                         builder: (BuildContext
//                                                                 context) =>
//                                                             UserDetailsDialog(
//                                                               controller:
//                                                                   controller,
//                                                               role: controller
//                                                                   .listUsers[
//                                                                       index]
//                                                                   .role,
//                                                               id: controller
//                                                                   .listUsers[
//                                                                       index]
//                                                                   .id,
//                                                               name: controller
//                                                                   .listUsers[
//                                                                       index]
//                                                                   .name,
//                                                               mapo: controller
//                                                                   .listUsers[
//                                                                       index]
//                                                                   .mathpoint
//                                                                   .toString(),
//                                                               chepo: controller
//                                                                   .listUsers[
//                                                                       index]
//                                                                   .chemistpoint
//                                                                   .toString(),
//                                                             ));
//                                                   },
//                                                   icon: const Icon(Icons.edit,
//                                                       color: Colors.white)),
//                                               const SizedBox(
//                                                 width: 8,
//                                               ),
//                                               IconButton(
//                                                   onPressed: () {
//                                                     controller.deleteAppUser(
//                                                         id: controller
//                                                             .listUsers[index]
//                                                             .id,
//                                                         role: controller
//                                                             .listUsers[index]
//                                                             .role);
//                                                   },
//                                                   icon: const Icon(Icons.delete,
//                                                       color: Colors.red)),
//                                             ],
//                                           ))
//                                       ])),
//                             ),
//                             if ((controller.roleOfCurrentUser ==
//                                                     teacher &&
//                                                 listName == studentList) ||
//                                             (controller.roleOfCurrentUser ==
//                                                     principal &&
//                                                 listName == teacherList))
//                             Builder(
//                               builder: (context) => Container(
//                                 height: 35,
//                                 decoration: BoxDecoration(
//                                     color: Colors.lightBlue,
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) =>
//                                                 UserDetailsDialog(
//                                                   roleOfCurrentUser: controller
//                                                       .roleOfCurrentUser,
//                                                   controller: controller,
//                                                 ));
//                                       },
//                                       //  tooltip: 'Thêm nhân viên mới',
//                                       icon: const Row(
//                                         children: [
//                                           Icon(
//                                             Icons.add,
//                                             size: 20,
//                                             color: Colors.white,
//                                           ),
//                                           SizedBox(width: 8),
//                                           Text(
//                                             'Thêm người dùng mới',
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 15),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   )),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
