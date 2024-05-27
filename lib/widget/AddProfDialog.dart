import 'package:flutter/material.dart';
import 'package:uniwayapp/utils/validator.dart';
import 'package:uniwayapp/widget/DropdownButton.dart'; // Assuming this is a custom widget
import 'package:uniwayapp/widget/TextFiled.dart'; // Custom TextField
// Firestore package
import 'package:uniwayapp/Model/professormodel.dart'; // Professor model

class AddProfessorDialog extends StatefulWidget {
  final Function(ProfessorModel)? onAdd;
  final ProfessorModel? professor;

  const AddProfessorDialog({Key? key, this.onAdd, this.professor})
      : super(key: key);

  @override
  _AddProfessorDialogState createState() => _AddProfessorDialogState();
}

class _AddProfessorDialogState extends State<AddProfessorDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _yearOfStartController = TextEditingController();

  String selectedGrade = '';
  String selectedSituation = '';
  String selectedSpecialty = '';
  String selectedSex = '';

  final List<String> uniqueOptions = [
    "Professor",
    "Senior Lecturer",
    "Lecturer",
    "Assistant Professor"
  ];
  final List<String> situations = ["Married", "Single", "Divorced"];
  final List<String> sexes = ["Man", "Woman"];
  final List<String> specialties = [
    "Computer Science",
    "Electronics",
    "Civil Engineering",
    "Mechanical Engineering",
    "Electrical Engineering",
    "Applied Mathematics"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.professor != null) {
      final professor = widget.professor!;
      _firstNameController.text = professor.firstname;
      _lastNameController.text = professor.lastname;
      _emailController.text = professor.email;
      _phoneController.text = professor.nmbofphone;
      _ageController.text = professor.age;
      _yearOfStartController.text = professor.yearofstart;

      // Ensure the selected values exist in their respective lists
      selectedGrade =
          uniqueOptions.contains(professor.grade) ? professor.grade : '';
      selectedSituation =
          situations.contains(professor.situation) ? professor.situation : '';
      selectedSpecialty =
          specialties.contains(professor.specialty) ? professor.specialty : '';
      selectedSex = sexes.contains(professor.sex) ? professor.sex : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.professor == null ? "Add Professor" : "Edite Professor"),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Dropdown(
                  selected: selectedGrade,
                  onChanged: (String? value) {
                    setState(() {
                      selectedGrade = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a grade";
                    }
                    return null;
                  },
                  options: uniqueOptions,
                  label: 'Select a Grade',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  validator: nameValidator,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                  validator: nameValidator,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  controller: _emailController,
                  labelText: "Email",
                  validator: emailValidator,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  validator: numbervalidator,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  controller: _ageController,
                  labelText: 'Age',
                  validator: ageValidator,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selectedSituation,
                  onChanged: (String? value) {
                    selectedSituation = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a situation";
                    }
                    return null;
                  },
                  options: situations,
                  label: 'Select a Situation',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selectedSpecialty,
                  onChanged: (String? value) {
                    selectedSpecialty = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a specialty";
                    }
                    return null;
                  },
                  options: specialties,
                  label: 'Select a Specialty',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selectedSex,
                  onChanged: (String? value) {
                    selectedSex = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a sex";
                    }
                    return null;
                  },
                  options: sexes,
                  label: 'Select a Sex',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  controller: _yearOfStartController,
                  labelText: 'Year of Start',
                  validator: yearsValidator,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            _resetForm(); // Reset the form when closing
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text(widget.professor == null ? "Add" : "Edit"),
        ),
      ],
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset(); // Reset the form state
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _ageController.clear();
    _yearOfStartController.clear();

    selectedGrade = '';
    selectedSituation = '';
    selectedSpecialty = '';
    selectedSex = '';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final newProfessor = ProfessorModel(
          firstname: _firstNameController.text,
          lastname: _lastNameController.text,
          email: _emailController.text,
          nmbofphone: _phoneController.text,
          age: _ageController.text,
          grade: selectedGrade,
          situation: selectedSituation,
          specialty: selectedSpecialty,
          sex: selectedSex,
          yearofstart: _yearOfStartController.text,
        );

        widget.onAdd
            ?.call(newProfessor); // Call the callback with the updated data
        _resetForm(); // Reset the form upon success
        Navigator.pop(context); // Close the dialog
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating professor: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
