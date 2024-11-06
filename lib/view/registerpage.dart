import 'package:flutter/material.dart';
import 'package:flutter_datatable/controller/registerpagecontroller.dart';


// ignore: must_be_immutable
class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  RegisterPageController controller = RegisterPageController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: controller.passwordController,
              //obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: controller.nameController,                
              decoration: InputDecoration(labelText: 'Name'),
            ),            
            ElevatedButton(
              onPressed: () => controller.register(context),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
