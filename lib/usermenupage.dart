// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/userlistpage.dart';
import 'package:flutter_datatable/loginuserpage.dart';
import 'package:flutter_datatable/userinfopage.dart';
import 'package:flutter_datatable/userpagecontroller.dart';

class UserMenuPage extends StatelessWidget {
  String studentList = "Student List";
  String teacherList = "Teacher List";
  String student = "Student";
  String principal = "Principal";
  String teacher = "Teacher";

  String? role;
  UserPageController controller = UserPageController();

  UserMenuPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang thông tin'),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu)),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white),
                )),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Thông tin người dùng'),
              onTap: () {
                Navigator.pop(context); // Đóng Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(role: role),
                  ),
                );
              },
            ),
            if ((role == teacher) || (role == principal))
              buildStudentPage(context),
            if (role == principal)
              buildTeacherPage(context),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              onTap: () async {
                Navigator.pop(context); // Đóng Drawer
                await controller.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginUserPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              color: Colors.black,
              child: SizedBox(
                height: 800,
                width: 800,
              ))
        ],
      ),
    );
  }

  ListTile buildTeacherPage(BuildContext context) {
    return ListTile(
              leading: Icon(Icons.info),
              title: Text("Danh sách giáo viên"),
              onTap: () {
                Navigator.pop(context); // Đóng Drawer
                controller.getNameOfUserList(teacherList);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListPage(
                      listName: teacherList,
                      controller: controller,
                    ),
                  ),
                );
              },
            );
  }

  ListTile buildStudentPage(BuildContext context) {
    return ListTile(
              leading: Icon(Icons.info),
              title: Text("Danh sách sinh viên"),
              onTap: () async {
                Navigator.pop(context); // Đóng Drawer
                controller.getNameOfUserList(studentList);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListPage(
                      listName: studentList,
                      controller: controller,
                    ),
                  ),
                );
              },
            );
  }
}