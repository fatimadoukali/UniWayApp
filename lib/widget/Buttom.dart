import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, this.option, this.color, this.onPressed, this.icons})
      : super(key: key);

  final String? option;
  final Color? color;
  final VoidCallback? onPressed;
  final IconData? icons;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(200, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icons,
            color: Colors.white,
          ),
          Text(
            option ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
