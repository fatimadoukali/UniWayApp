import 'package:flutter/material.dart';
import 'package:uniwayapp/colors/colors.dart';

class MenuVice extends StatelessWidget {
  final Function(String) onMenuItemSelected;
  const MenuVice({super.key, required this.onMenuItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 20.0,
            width: 30.0,
          ),
          const Text(
            'Uniway',
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: const Icon(
              Icons.school,
              color: Colors.white,
            ), // Add icon for employee management
            title: const Text(
              'Scholarship Management',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => onMenuItemSelected('Scholarship_management'),
          ),
          ListTile(
            leading: const Icon(
              Icons.school,
              color: Colors.white,
            ), // Add icon for employee management
            title: const Text(
              'Students Management',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => onMenuItemSelected('Students_management'),
          ),
          ListTile(
            leading: const Icon(
              Icons.groups_2,
              color: Colors.white,
            ), // Add icon for employee management
            title: const Text(
              'Professors Management',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => onMenuItemSelected('Professors_management'),
          ),
          ListTile(
            leading: const Icon(
              Icons.group,
              color: Colors.white,
            ), // Add icon for employee management
            title: const Text(
              'Administrators Management',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => onMenuItemSelected('Administrators_management'),
          ),
          ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ), // Add icon for sign out
              title: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                onMenuItemSelected('sign_out');
              }),
        ],
      ),
    );
  }
}
