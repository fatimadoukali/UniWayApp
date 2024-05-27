import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uniwayapp/colors/colors.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> roles = [
    "Vice_Rectorat Service Externe",
    "Administrator",
    "Commission president"
  ];
  String selectedRole = "";

  void _navigateToScreen(String role) {
    switch (role) {
      case "Vice_Rectorat Service Externe":
        Navigator.pushNamed(context, 'LoginVice');
        break;
      case "Administrator":
        Navigator.pushNamed(context, 'LoginAdmin');
        break;
      case "Commission president":
        Navigator.pushNamed(context, 'LoginPresident');
        break;
      default:
        // Handle any other cases
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SvgPicture.asset(
              'asset/image/shipe.svg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(
                          color: grey1,
                          fontSize: 60,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'UniWay',
                        style: TextStyle(
                          color: primary,
                          fontSize: 60,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'To get started, please select your role from the options below:',
                  style: TextStyle(
                    color: grey1,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Dropdown(
                  width: MediaQuery.of(context).size.width * 0.35,
                  options: roles,
                  selected: selectedRole,
                  onChanged: (String? value) {
                    setState(() {
                      selectedRole = value ?? "";
                    });
                    if (value != null) {
                      _navigateToScreen(value);
                    }
                  },
                  validator: (value) {
                    return null;
                  },
                  label: 'Select your role',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                const Text(
                  'University -Belhadj Bouchaib- ',
                  style: TextStyle(
                      color: grey, fontSize: 16.0, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
