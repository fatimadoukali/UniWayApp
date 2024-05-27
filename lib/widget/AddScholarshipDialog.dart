import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniwayapp/Model/ScholarshipModel.dart';
import 'package:uniwayapp/utils/validator.dart';
import 'package:uniwayapp/widget/TextFiled.dart';

class AddScholarshipDialog extends StatefulWidget {
  final Function(ScholarshipModel)? onAdd;
  final ScholarshipModel?
      scholarship; // Modèle de bourse existante (peut être null)

  const AddScholarshipDialog({
    super.key,
    this.onAdd,
    this.scholarship, // Argument facultatif pour passer un modèle de bourse existante
  });

  @override
  _AddScholarshipDialogState createState() => _AddScholarshipDialogState();
}

class _AddScholarshipDialogState extends State<AddScholarshipDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String scholarshipName;
  late String scholarshipDeadlines;
  late String scholarshipType;
  late String scholarshipDescription;
  late String scholarshipAmount;
  late String scholarshipDocuments;
  late String universityName;
  late String academicLanguage;
  late String pays;
  late String years;

  @override
  void initState() {
    super.initState();

    // Si le modèle de bourse existe, remplissez les valeurs avec ses données
    if (widget.scholarship != null) {
      final scholarship = widget.scholarship!;
      scholarshipName = scholarship.ScholarshipName;
      scholarshipDeadlines = scholarship.ScholarshipDeadlines;
      scholarshipType = scholarship.ScholarshipType;
      scholarshipAmount = scholarship.SchoalrshipAmount;
      scholarshipDocuments = scholarship.ScholarshipDocuments;
      universityName = scholarship.UniversityName;
      academicLanguage = scholarship.AcdimicLanguage;
      pays = scholarship.pays;
      years = scholarship.years;
    } else {
      // Sinon, utilisez des valeurs vides ou par défaut
      scholarshipName = '';
      scholarshipDeadlines = '';
      scholarshipType = '';
      scholarshipDescription = '';
      scholarshipAmount = '';
      scholarshipDocuments = '';
      universityName = '';
      academicLanguage = '';
      pays = '';
      years = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.scholarship == null ? "Add Scholarship" : "Edit Scholarship"),
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
                CustumTextField(
                  labelText: 'Scholarship Name',
                  initialValue: scholarshipName,
                  validator: nameValidator,
                  onSaved: (newValue) => scholarshipName = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Scholarship Type',
                  initialValue: scholarshipType,
                  onSaved: (newValue) => scholarshipType = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Years',
                  initialValue: years,
                  validator: yearsValidator,
                  onSaved: (newValue) => years = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Scholarship Amount',
                  initialValue: scholarshipAmount,
                  validator: amountValidator,
                  onSaved: (newValue) => scholarshipAmount = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: "Scholarship Deadlines",
                  initialValue: scholarshipDeadlines,
                  validator: deadlineValidator,
                  onSaved: (newValue) => scholarshipDeadlines = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Academic Language',
                  initialValue: academicLanguage,
                  onSaved: (newValue) => academicLanguage = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'University Name',
                  initialValue: universityName,
                  validator: nameValidator,
                  onSaved: (newValue) => universityName = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Pays',
                  initialValue: pays,
                  onSaved: (newValue) => pays = newValue!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CustumTextField(
                  labelText: 'Scholarship Documents',
                  initialValue: scholarshipDocuments,
                  onSaved: (newValue) => scholarshipDocuments = newValue!,
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
            _resetForm(); // Réinitialiser le formulaire
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _submitForm, // Sauvegarder le formulaire
          child: Text(widget.scholarship == null ? "Add" : "Edit"),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        widget.onAdd?.call(ScholarshipModel(
          ScholarshipName: scholarshipName,
          ScholarshipType: scholarshipType,
          years: years,
          SchoalrshipAmount: scholarshipAmount,
          ScholarshipDeadlines: scholarshipDeadlines,
          AcdimicLanguage: academicLanguage,
          UniversityName: universityName,
          pays: pays,
          ScholarshipDocuments: scholarshipDocuments,
        ));

        Navigator.pop(context);
        _resetForm();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating scholarship: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    scholarshipName = '';
    scholarshipDeadlines = '';
    scholarshipType = '';
    years = '';
    scholarshipAmount = '';
    academicLanguage = '';
    universityName = '';
    pays = '';
    scholarshipDocuments = '';
  }
}
