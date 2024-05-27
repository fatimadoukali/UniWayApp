import 'package:flutter/material.dart';
import 'package:uniwayapp/colors/colors.dart';
import 'package:uniwayapp/service/auth_service.dart';
import 'package:uniwayapp/utils/validator.dart';
import 'package:uniwayapp/widget/TextFiled.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Authservice auth = Authservice();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter email to send you password reset email'),
                const SizedBox(
                  height: 20,
                ),
                CustumTextField(
                  width: MediaQuery.of(context).size.width * 0.4,
                  labelText: 'Email',
                  hintText: 'Enter email',
                  controller: emailController,
                  validator: emailValidator,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await auth.resetPassword(emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Check your email, we\'ve sent you a reset password link')),
                        );
                      }
                    },
                    color: primary,
                    child: const Text(
                      'Send Reset Link',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
