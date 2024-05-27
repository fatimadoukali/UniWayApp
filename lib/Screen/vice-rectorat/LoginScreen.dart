import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniwayapp/colors/colors.dart';
import 'package:uniwayapp/utils/helpersfunction.dart';
import 'package:uniwayapp/utils/validator.dart';
import 'package:uniwayapp/widget/TextFiled.dart';
import 'package:uniwayapp/widget/buttonLogin.dart';

class LoginVice extends StatefulWidget {
  const LoginVice({super.key});

  @override
  State<LoginVice> createState() => _LoginViceState();
}

class _LoginViceState extends State<LoginVice> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = false;
  bool _showPassword = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


 Future<void> _login() async {
  if (!formKey.currentState!.validate() || _loading) {
    return;
  }
  setState(() {
    _loading = true; // Show loading indicator
  });
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    QuerySnapshot querySnapshot = await _firestore
        .collection('employees')
        .where('job', isEqualTo: 'Vice_Rectorat Service Externe')
        .get();

    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No employees with this title were found."),
          backgroundColor: Colors.red,
        ),
      );
      await _auth.signOut(); // Sign out the user
      return;
    }
    var employeeDoc = querySnapshot.docs.first;
    var employeeData = employeeDoc.data() as Map<String, dynamic>;

    if (employeeData['email'] != _emailController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This employee is not the Admin"),
          backgroundColor: Colors.red,
        ),
      );
      await _auth.signOut(); // Sign out the user
      return;
    }

    await _firestore.collection('vice').doc(userCredential.user!.uid).set({
      'email': _emailController.text,
      'last_login': DateTime.now(),
    });

    Navigator.pushNamed(context, 'Scholarship management');
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for this email';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Incorrect password';
    } else {
      errorMessage = 'An error occurred while connecting';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An Unexpected error occurred'),
        backgroundColor: Colors.red,
      ),
    );
    print('Erreur inattendue: $e');
  } finally {
    setState(() {
      _loading = false; // Hide loading indicator
    });
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: primary,
                        fontSize: 60,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcom to ',
                            style: TextStyle(
                              color: Color(0xFFA8A8A8),
                              fontSize: 34,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'UniWay',
                            style: TextStyle(
                              color: primary,
                              fontSize: 34,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Login to your account',
                      style: TextStyle(
                        color: Color(0xFFA8A8A8),
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 70),
                    CustumTextField(
                      width: 500,
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'your-email@example.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                      icons: const Icon(Icons.email),
                    ),
                    const SizedBox(height: 20),
                    CustumTextField(
                      width: 500,
                      obscureText: !_showPassword,
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Password',
                      validator: passwordValidator,
                      icons: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        navigateTo(context, "forgetpassword");
                        // Fonctionnalité "Mot de passe oublié"
                      },
                      child: const Text('Forgot password?'),
                    ),
                    const SizedBox(height: 20),
                    CustomButtonLogin(
                      onPressed: _loading ? null : _login,
                      option: 'Login',
                      color: primary,
                    ),
                    const SizedBox(height: 200),
                    const Text(
                      'Université -Belhadj Bouchaib- ',
                      style: TextStyle(
                        color: grey,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
