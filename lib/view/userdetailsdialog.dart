import 'package:flutter/material.dart';
import 'package:flutter_datatable/manager/currentuser.dart';
import 'package:flutter_datatable/controller/userlistpagecontroller.dart';


// ignore: must_be_immutable
class UserDetailsDialog extends StatelessWidget {
  String? id;
  String? role;  
  String name;  
  String mapo;
  String chepo;
  // String? roleOfCurrentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mapoController = TextEditingController();
  final TextEditingController chepoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final UserListPageController controller;

  UserDetailsDialog(
      {super.key,
      this.id,
      this.role,      
      this.name = "",
      this.mapo = "",
      this.chepo = "",
      // this.roleOfCurrentUser,
      required this.controller}) {
    nameController.text = name;
    mapoController.text = mapo;
    chepoController.text = chepo;
        
  }
  @override
  Widget build(BuildContext context) {
    return role == null ? addUser(context) : editUser(context);
  }

  AlertDialog addUser(context) {
    return AlertDialog(
      title: CurrentUser().role == "Principal" 
      ? Text(
        'Thêm giáo viên',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),)
      : Text(
        'Thêm sinh viên',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),          
          const SizedBox(
            height: 15,
          ),
          Container(
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(8)),
              child: 
              IconButton(
                      onPressed: (){
                        controller.addAppUser(
                          context,
                          email: emailController.text);
                        Navigator.pop(context);
                      },
                      icon: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ],
                      ))
                  )
        ],
      ),
    );
  }

  AlertDialog editUser(context) {
    return AlertDialog(
      title: role == "Student"
      ? Text('Chỉnh sửa sinh viên',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
      : Text('Chỉnh sửa giáo viên',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Tên',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          if (role == "Student")
            TextField(
              controller: mapoController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Điểm Toán',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
          if (role == "Student")
            TextField(
              controller: chepoController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Điểm Hóa',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          Container(
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(8)),
              child: role == "Student" 
              ? IconButton(
                      onPressed: () {
                        controller.editAppUser(
                            id: id.toString(),
                            role : role.toString(),
                            name: nameController.text,
                            mapo: mapoController.text,
                            chepo: chepoController.text);
                        
                          Navigator.pop(context);
                        
                      },
                      icon: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.white,
                          )
                        ],
                      ))
              : IconButton(
                      onPressed: () {
                        controller.editAppUser(
                            id: id.toString(),
                            role : role.toString(),
                            name: nameController.text,
                            );
                        
                          Navigator.pop(context);
                        
                      },
                      icon: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.white,
                          )
                        ],
                      ))      
                      )
        ],
      ),
    );
  }
}
