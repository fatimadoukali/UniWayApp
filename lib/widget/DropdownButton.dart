import 'package:flutter/material.dart';
import 'package:uniwayapp/colors/colors.dart';

class Dropdown extends StatefulWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator validator;
  final Color? colors;
  final String label;
  final double? width; // Add a variable for the label

  Dropdown({
    Key? key,
    this.width,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.validator,
    this.colors,
    required this.label, // Make label required
  }) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: grey1, style: BorderStyle.solid)),
          labelText: widget.label, // Use the label variable here
          labelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: grey2,
          ),
        ),
        value: widget.selected.isNotEmpty ? widget.selected : null,
        items: widget.options.map((String job) {
          return DropdownMenuItem<String>(
            value: job,
            child: Text(
              job,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: widget.colors ?? grey2,
              ),
            ),
          );
        }).toList(),
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}
