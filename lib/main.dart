import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniwayapp/Screen/WelcomScreen.dart';
import 'package:uniwayapp/Screen/admine/employee.dart';
import 'package:uniwayapp/Screen/admine/login.dart';
import 'package:uniwayapp/Screen/consiel%20scientifique/AdminstratorValid.dart';
import 'package:uniwayapp/Screen/consiel%20scientifique/ProfessorValidat.dart';
import 'package:uniwayapp/Screen/consiel%20scientifique/StudentValid.dart';
import 'package:uniwayapp/Screen/consiel%20scientifique/loginconsiel.dart';
import 'package:uniwayapp/Screen/forgetpassword.dart';
import 'package:uniwayapp/Screen/vice-rectorat/AddAdministratorCondidat.dart';
import 'package:uniwayapp/Screen/vice-rectorat/AddProfessurCondidat.dart';
import 'package:uniwayapp/Screen/vice-rectorat/AddScholarship.dart';
import 'package:uniwayapp/Screen/vice-rectorat/AddStudentCondidat.dart';
import 'package:uniwayapp/Screen/vice-rectorat/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uniwayapp/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDOvW7jJ-ue5sQjbfLR2r7dkkoPIIzZB6U",
          appId: "1:844227751696:android:a0169380c9e69e63c2bf95",
          messagingSenderId: "844227751696",
          projectId: "signin-69a74"));
  runApp(const UniWayApp());
  DepandencyInjiction.init();
}

class UniWayApp extends StatelessWidget {
  const UniWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uniway',
      home: //const StudentCondidatView(),
          const WelcomeScreen(),
      //const WelcomeScreen(),
      routes: {
        "LoginAdmin": (context) => const LoginAdmin(),
        "LoginVice": (context) => const LoginVice(),
        "LoginPresident": (context) => const LoginConsiel(),
        "employee_management": (context) => const EmployeeView(),
        "Students management": (context) => const StudentCondidatView(),
        "Professors management": (context) => const ProfessorCondidatView(),
        "Administrators management": (context) => const AdmineCondidatView(),
        "Scholarship management": (context) => const ScholarshipView(),
        "Students Validat": (context) => const StudentValidiView(),
        "Professors Validat": (context) => const ProfessorValidiView(),
        "Administrators Validat": (context) => const AdminsValidiView(),
        "forgetpassword": (context) => const ForgotPasswordPage(),
      },
    );
  }
}
