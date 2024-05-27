import 'package:flutter/material.dart';
import 'package:uniwayapp/utils/helpersfunction.dart';
import 'package:uniwayapp/widget/AdministratorManagment.dart';
import 'package:uniwayapp/widget/MenuVice.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdmineCondidatView extends StatelessWidget {
  const AdmineCondidatView({super.key});

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
                        navigateTo(context, "Students management");
                        break;
                      case 'Professors_management':
                        navigateTo(context, "Professors management");
                        break;
                      case 'Administrators_management':
                        navigateTo(context, "Administrators management");
                        break;
                      case 'Scholarship_management':
                        navigateTo(context, "Scholarship management");
                        break;
                      case 'profile':
                        navigateTo(context, "profile");
                        break;
                      case 'settings':
                        navigateTo(context, "settings");
                        break;
                      case 'sign_out':
                        await FirebaseAuth.instance.signOut(); // Déconnexion
                        navigateTo(context, "login"); // Retour à l'écran de connexion
                        break;
                      default:
                        print("Invalid menu item: $menuItem");
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 10,
              child: AdminstratorManagement(),
            ),
          ],
        ),
      ),
    );
  }
}
