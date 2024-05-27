import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniwayapp/utils/helpersfunction.dart';
import 'package:uniwayapp/widget/MenuPresedent.dart';
import 'package:uniwayapp/widget/StudentValid.dart';

class StudentValidiView extends StatelessWidget {
  const StudentValidiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                child: MenuPresedent(
                  onMenuItemSelected: (menuItem) async {
                    switch (menuItem) {
                      case 'Students_Validat':
                        navigateTo(context,
                            "Students Validat"); // Replace with actual route
                        break;
                      case 'Professors_Validat':
                        navigateTo(context,
                            "Professors Validat"); // Replace with actual route
                        break;
                      case 'Administrators_Validat':
                        navigateTo(context,
                            "Administrators Validat"); // Replace with actual route
                        break;
                      // Replace with actual route

                      case 'sign_out':
                        // Handle sign out logic (potentially navigate to login page)
                        await FirebaseAuth.instance.signOut(); // Déconnexion
                        navigateTo(context, "LoginPresident");
                        break;
                      default:
                        print("Invalid menu item: $menuItem");
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
              flex: 10,
              child: StudentValid(),
            ),
          ],
        ),
      ),
    );
  }
}
