// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/constant/constant.dart';
import 'package:flutter_datatable/manager/currentuser.dart';
import 'package:flutter_datatable/view/userlistpage.dart';
import 'package:flutter_datatable/view/loginuserpage.dart';
import 'package:flutter_datatable/view/userinfopage.dart';
import 'package:flutter_datatable/constant/userlisttype.dart';
import 'package:flutter_datatable/controller/usermenupagecontroller.dart';

class UserMenuPage extends StatelessWidget {
  UserMenuPageController controller = UserMenuPageController();
  UserMenuPage({
    super.key,
  });
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
            buildListTile(context, "Thong tin nguoi dung", UserInfoPage()),
            if ((CurrentUser().role == Constant.ROLE_TEACHER) ||
                (CurrentUser().role == Constant.ROLE_PRINCIPLE))
              buildListTile(
                  context,
                  "Danh sach sinh vien",
                  UserListPage(
                    type: CurrentUser().role == Constant.ROLE_TEACHER
                        ? UserListType.studentsofteacher
                        : UserListType.allstudents,
                  )),
            if (CurrentUser().role == Constant.ROLE_PRINCIPLE)
              buildListTile(context, "Danh sach giao vien",
                  UserListPage(type: UserListType.teachers)),
            buildListTile(context, "Dang xuat", LoginUserPage())
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

  ListTile buildListTile(BuildContext context, String title, Widget widget) {
    return ListTile(
      leading: Icon(Icons.info),
      title: Text(title),
      onTap: () async {
        Navigator.pop(context);
        if (title == "Dang xuat") {
          await controller.logout(context);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget,
          ),
        );
      },
    );
  }
}
