import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datatable/view/usermenupage.dart';
import 'package:flutter_datatable/firebase_options.dart';
import 'package:flutter_datatable/controller/maincontroller.dart';
import 'package:provider/provider.dart';
import 'view/loginuserpage.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  MainController controller = MainController();
  
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: controller,
      child: Consumer<MainController>(builder: (context, controller, child) {        
        return MaterialApp(
          title: 'Cuong App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
           home: controller.isLoggedIn ? UserMenuPage() : LoginUserPage(),
          
        );
      },
      ),
    );
  }
}
