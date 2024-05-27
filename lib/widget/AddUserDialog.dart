import 'package:flutter/material.dart';
import 'package:uniwayapp/Model/employeemodel.dart';
import 'package:uniwayapp/utils/validator.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart'; // Correction du nom du fichier

class AddUserDialog extends StatefulWidget {
  final EmployeeRequest? employee; // L'employé à éditer
  final Function(EmployeeRequest)?
      onAdd; // Fonction pour sauvegarder les modifications

  const AddUserDialog({
    super.key,
    this.onAdd, // Correction du paramètre requis
    this.employee,
  });

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';

  final bool _showPassword = false; // Correction de l'initialisation
  String selectedJob = ""; // Variable pour le poste sélectionné

  final List<String> jobOptions = [
    "Vice_Rectorat Service Externe",
    "Administrator",
    "Commission president"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      final employees = widget.employee!;
      name = employees.name;
      email = employees.email;
      password = employees.password;
      selectedJob = employees.job;
    } else {
      name = '';
      email = '';
      password = '';
      selectedJob = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.employee == null
          ? "Add new employee"
          : "Edit employee"), // Correction de la traduction
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                CustumTextField(
                  labelText: 'Name', // Correction du texte
                  validator: nameValidator,
                  onSaved: (newValue) => name = newValue!,
                  initialValue: widget.employee?.name,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustumTextField(
                  labelText: "Email", // Correction du texte
                  validator: emailValidator,
                  initialValue: widget.employee?.email,
                  onSaved: (newValue) => email = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustumTextField(
                  obscureText: !_showPassword, // Correction de l'obfuscation
                  labelText: 'Password', // Correction de la traduction
                  validator: passwordValidator,
                  onSaved: (newValue) => password = newValue!,
                  initialValue: widget.employee?.password,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Dropdown(
                  options: jobOptions,
                  selected: selectedJob,
                  label: 'Select a job',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a job";
                    }
                    return null;
                  },
                  onChanged: (String? value) {
                    setState(() {
                      selectedJob = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context), // Correction de l'action de fermeture
          child: const Text("Cancel"), // Correction de la traduction
        ),
        TextButton(
          onPressed: _submitForm, // Correction de l'action
          child: Text(widget.employee == null
              ? "Add"
              : "Edit"), // Correction de la traduction
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        widget.onAdd?.call(EmployeeRequest(
          name: name,
          email: email,
          password: password,
          job: selectedJob,
        )); // Appel de la fonction onSave pour mettre à jour
        Navigator.pop(context);
        _resetForm();
      } catch (error) {
        // Gestion des erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error adding student: $error"),
            backgroundColor: Colors.red,
          ),
        );
      } // Fermer le dialogue
    }
  }

  void _resetForm() {
    setState(() {
      name = '';
      email = '';
      password = '';
      selectedJob = '';
    });
    _formKey.currentState?.reset();
  }
}
