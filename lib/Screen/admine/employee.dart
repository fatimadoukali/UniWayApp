import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniwayapp/utils/helpersfunction.dart';
import 'package:uniwayapp/widget/EmployeeManagment.dart';

import 'package:uniwayapp/widget/menuadmine.dart';

class EmployeeView extends StatelessWidget {
  const EmployeeView({super.key});

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
                child: AdminMenu(
                  onMenuItemSelected: (menuItem) async {
                    switch (menuItem) {
                      case 'employee_management':
                        navigateTo(context,
                            "employee_management"); // Replace with actual route
                        break;
                      // Replace with actual route

                      case 'sign_out':
                        // Handle sign out logic (potentially navigate to login page)
                        await FirebaseAuth.instance.signOut(); // Déconnexion
                        navigateTo(context, "LoginAdmin");
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
              child: EmployeeManagementPage(),
            ), // Display LeaveManagementPage when 'employee_management' is selected
            // Placeholder for other content ,
          ],
        ),
      ),
    );
  }
}
