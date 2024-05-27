import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:uniwayapp/Model/adminstatoemodel.dart'; // Model
import 'package:uniwayapp/utils/validator.dart';
import 'package:uniwayapp/widget/DropdownButton.dart'; // Custom Dropdown
import 'package:uniwayapp/widget/TextFiled.dart'; // Custom Text Field

class AddAdminDialog extends StatefulWidget {
  final Function(AdminstratorsModele)? onAdd;
  final Function(AdminstratorsModele)? onEdit;
  final AdminstratorsModele? administrator; // Administrator to edit

  const AddAdminDialog({
    super.key,
    this.onAdd,
    this.onEdit,
    this.administrator,
  });

  @override
  _AddAdminDialogState createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _yearOfStartController = TextEditingController();

  late String job;
  late String selectedSituation;
  late String selectedSpecialty;
  late String selectedSex;

  final List<String> uniqueOptions = [
    "Dean",
    "Department Chair",
    "Academic Advisor",
    "Registrar",
    "Financial Aid Officer",
    "Student Affairs Coordinator",
    "Admissions Officer",
    "Human Resources Manager",
    "Facilities Manager",
    "IT Support Specialist"
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
    if (widget.administrator != null) {
      final admin = widget.administrator!;
      _firstNameController.text = admin.firstname;
      _lastNameController.text = admin.lastname;
      _emailController.text = admin.email;
      _phoneController.text = admin.nmbofphone;
      _ageController.text = admin.age;
      _yearOfStartController.text = admin.yearofstart;

      job = admin.job;
      selectedSituation = admin.situation;
      selectedSpecialty = admin.specialty;
      selectedSex = admin.sex;
    } else {
      job = uniqueOptions.first; // Default job
      selectedSituation = situations.first; // Default situation
      selectedSpecialty = specialties.first; // Default specialty
      selectedSex = sexes.first; // Default sex
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.administrator == null
          ? "Add New Administrator"
          : "Edit Administrator"),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Dropdown(
                  selected: job,
                  options: uniqueOptions,
                  label: 'Select a Job',
                  onChanged: (String? value) {
                    setState(() {
                      job = value ?? uniqueOptions.first;
                    });
                  },
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? "Please select a job"
                        : null;
                  },
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
                  labelText: 'Email',
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
                    setState(() {
                      selectedSituation = value ?? situations.first;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select a situation" : null,
                  options: situations,
                  label: 'Select a Situation',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selectedSpecialty,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSpecialty = value ?? specialties.first;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select a specialty" : null,
                  options: specialties,
                  label: 'Select a Specialty',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Dropdown(
                  selected: selectedSex,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSex = value ?? sexes.first;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select a sex" : null,
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
          onPressed: () => Navigator.pop(context), // Close the dialog
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text(widget.administrator == null ? "Add" : "Edit"),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    try {
      if (widget.administrator == null) {
        // Adding a new administrator
        await _firestore.collection('administrators').add({
          'firstname': _firstNameController.text,
          'lastname': _lastNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'age': _ageController.text,
          'job': job,
          'situation': selectedSituation,
          'specialty': selectedSpecialty,
          'sex': selectedSex,
          'yearOfStart': _yearOfStartController.text,
        });

        // Also add to the 'employees' collection
        await _firestore.collection('employees').add({
          'email': _emailController.text,
          'name': '${_firstNameController.text} ${_lastNameController.text}',
          'job': job,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Administrator added successfully"),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm(); // Reset form on success
      } else {
        // Editing an existing administrator
        var querySnapshot = await _firestore
            .collection('administrators')
            .where('email', isEqualTo: _emailController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var docId = querySnapshot.docs.first.id; // Firestore document ID

          await _firestore.collection('administrators').doc(docId).update({
            'firstname': _firstNameController.text,
            'lastname': _lastNameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'age': _ageController.text,
            'job': job,
            'situation': selectedSituation,
            'specialty': selectedSpecialty,
            'sex': selectedSex,
            'yearOfStart': _yearOfStartController.text,
          });

          // Update the corresponding entry in the 'employees' collection
          var employeeQuerySnapshot = await _firestore
              .collection('employees')
              .where('email', isEqualTo: _emailController.text)
              .get();

          if (employeeQuerySnapshot.docs.isNotEmpty) {
            var employeeDocId = employeeQuerySnapshot.docs.first.id; // Firestore document ID

            await _firestore.collection('employees').doc(employeeDocId).update({
              'email': _emailController.text,
              'name': '${_firstNameController.text} ${_lastNameController.text}',
              'job': job,
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Administrator updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // If not found in 'employees', add a new entry
            await _firestore.collection('employees').add({
              'email': _emailController.text,
              'name': '${_firstNameController.text} ${_lastNameController.text}',
              'job': job,
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Administrator updated successfully in both collections"),
                backgroundColor: Colors.green,
              ),
            );
          }

          _resetForm(); // Reset the form
        } else {
          throw Exception("Administrator with the provided email not found");
        }
      }

      Navigator.pop(context); // Close the dialog after a successful operation
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error processing administrator: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  void _resetForm() {
    _formKey.currentState?.reset(); // Reset the form state
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _ageController.clear();
    _yearOfStartController.clear();

    job = '';
    selectedSituation = '';
    selectedSpecialty = '';
    selectedSex = '';
  }
}
