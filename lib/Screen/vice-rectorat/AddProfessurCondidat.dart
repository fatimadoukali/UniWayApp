import 'package:flutter/material.dart';
import 'package:uniwayapp/utils/helpersfunction.dart';
import 'package:uniwayapp/widget/MenuVice.dart';
import 'package:uniwayapp/widget/ProfessorManagment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfessorCondidatView extends StatelessWidget {
  const ProfessorCondidatView({super.key});

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

                      case 'sign_out':
                        await FirebaseAuth.instance.signOut(); // Déconnexion
                        navigateTo(context,
                            "LoginVice"); // Naviguer vers l'écran de connexion
                        break;
                      default:
                        print("Invalid menu item: $menuItem");
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              flex: 10,
              child: ProfessorManagement(), // Afficher le contenu approprié
            ),
          ],
        ),
      ),
    );
  }
}
