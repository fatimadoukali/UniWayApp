import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniwayapp/Model/Studentmodel.dart';
import 'package:uniwayapp/utils/validator.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart';

class AddStudentDialog extends StatefulWidget {
  final Function(Studentmodel)? onAdd;
  final Studentmodel? student;

  const AddStudentDialog({super.key, this.onAdd, this.student});

  @override
  _AddStudentDialogState createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedLevel = '';
  String firstname = '';
  String lastname = '';
  String email = '';
  String nmbofphone = '';
  String age = '';
  String selectSituation = '';
  String selectSex = '';
  String selctspecialty = '';
  String yearofstart = '';

  final List<String> uniqueOptions = ["Bachelor's", "Master's", "Doctoral"];
  final List<String> situations = ["Married", "Single", "Divorced"];
  final List<String> sexs = ["Man", "Woman"];
  final List<String> specialties = [
    "Computer Science",
    "Electronics",
    "Civil Engineering",
    "Mechanical Engineering",
    "Electrical Engineering",
    "Applied Mathematics"
  ];
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    // Initialize fields with student's data if available
    if (widget.student != null) {
      final student = widget.student!;

      firstname = student.firstname;
      lastname = student.lastname;
      email = student.email;
      nmbofphone = student.nmbofphone;
      age = student.age;
      yearofstart = student.yearofstart;
      selectedLevel = student.level;
      selectSituation = student.situation;
      selctspecialty = student.specialty;
      selectSex = student.sex;
    } else {
      // Sinon, utilisez des valeurs vides ou par défaut
      firstname = '';
      lastname = '';
      email = '';
      nmbofphone = '';
      age = '';
      yearofstart = '';
      selectedLevel = '';
      selectSituation = '';
      selctspecialty = '';
      selectSex = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.student == null ? "Add New Student" : "Edit Student"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Dropdown(
                  selected: selectedLevel,
                  onChanged: (String? value) {
                    setState(() {
                      selectedLevel = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a level";
                    }
                    return null;
                  },
                  options: uniqueOptions,
                  label: 'Select a level',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'First Name',
                  initialValue: widget.student?.firstname,
                  onSaved: (newValue) => firstname = newValue!,
                  validator: nameValidator,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Last Name',
                  initialValue: widget.student?.lastname,
                  validator: nameValidator,
                  onSaved: (newValue) => lastname = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Email',
                  initialValue: widget.student?.email,
                  validator: emailValidator,
                  onSaved: (newValue) => email = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Phone Number',
                  initialValue: widget.student?.nmbofphone,
                  validator: numbervalidator,
                  onSaved: (newValue) => nmbofphone = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Age',
                  initialValue: widget.student?.age,
                  validator: ageValidator,
                  onSaved: (newValue) => age = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selectSituation,
                  onChanged: (String? value) {
                    setState(() {
                      selectSituation = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a situation";
                    }
                    return null;
                  },
                  options: situations,
                  label: 'Select a situation',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selctspecialty,
                  onChanged: (String? value) {
                    setState(() {
                      selctspecialty = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a sepecialty";
                    }
                    return null;
                  },
                  options: specialties,
                  label: 'Select a specialty',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selectSex,
                  onChanged: (String? value) {
                    setState(() {
                      selectSex = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a sex";
                    }
                    return null;
                  },
                  options: sexs,
                  label: 'Select a sex',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Year of Start',
                  initialValue: widget.student?.yearofstart,
                  validator: yearsValidator,
                  onSaved: (newValue) => yearofstart = newValue!,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _resetForm();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text(widget.student == null ? "Add" : "Edit"),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Sauvegarder les données du formulaire

      try {
        widget.onAdd?.call(Studentmodel(
          level: selectedLevel,
          firstname: firstname,
          lastname: lastname,
          email: email,
          nmbofphone: nmbofphone,
          age: age,
          situation: selectSituation,
          specialty: selctspecialty,
          sex: selectSex,
          yearofstart: yearofstart,
        ));

        Navigator.pop(context);
        _resetForm(); // Fermer la boîte de dialogue
      } catch (error) {
        // Gestion des erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error adding student: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      selectedLevel = '';
      firstname = '';
      lastname = '';
      email = '';
      nmbofphone = '';
      age = '';
      selectSituation = '';
      selctspecialty = '';
      selectSex = '';
      yearofstart = '';
    });

    _formKey.currentState?.reset(); // Réinitialiser le formulaire
  }
}
