import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniwayapp/utils/helpersfunction.dart';
import 'package:uniwayapp/widget/MenuVice.dart';
import 'package:uniwayapp/widget/ScholarshipManagment.dart';

class ScholarshipView extends StatelessWidget {
  const ScholarshipView({super.key});

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
                child: MenuVice(
                  onMenuItemSelected: (menuItem) async {
                    switch (menuItem) {
                      case 'Students_management':
                        navigateTo(context,
                            "Students management"); // Replace with actual route
                        break;
                      case 'Professors_management':
                        navigateTo(context,
                            "Professors management"); // Replace with actual route
                        break;
                      case 'Administrators_management':
                        navigateTo(context,
                            "Administrators management"); // Replace with actual route
                        break;
                      case 'Scholarship_management':
                        navigateTo(context,
                            "Scholarship management"); // Replace with actual route
                        break;

                      case 'sign_out':
                        // Handle sign out logic (potentially navigate to login page)
                        await FirebaseAuth.instance.signOut(); // Déconnexion
                        navigateTo(context, "LoginVice");
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
            Expanded(
              flex: 10,
              child: ScholarshipManagment(),
            ),
          ],
        ),
      ),
    );
  }
}
