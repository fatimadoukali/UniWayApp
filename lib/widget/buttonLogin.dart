import 'package:flutter/material.dart';

class CustomButtonLogin extends StatelessWidget {
  const CustomButtonLogin({
    super.key,
    this.option,
    this.color,
    this.onPressed,
    this.loading = false,
  });

  final String? option;
  final Color? color;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(256, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              option ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
