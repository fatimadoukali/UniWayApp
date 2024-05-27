import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:flutter/widgets.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:uniwayapp/Model/professormodel.dart';
import 'package:uniwayapp/service/auth_service.dart';
import 'package:uniwayapp/widget/AddProfDialog.dart';
import 'package:uniwayapp/widget/Buttom.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart'; // Custom Text Field
import '../colors/colors.dart'; // Custom colors

class ProfessorManagement extends StatefulWidget {
  const ProfessorManagement({super.key});

  @override
  _ProfessorManagementState createState() => _ProfessorManagementState();
}

class _ProfessorManagementState extends State<ProfessorManagement> {
  String searchText = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Authservice _print = Authservice();
  String selectscholarship = '';
  List<String> listsholarship = [];
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddProfessorDialog(
          onAdd: (ProfessorModel newProfessor) {
            _firestore.collection('professors').add({
              'firstname': newProfessor.firstname,
              'lastname': newProfessor.lastname,
              'grade': newProfessor.grade,
              'email': newProfessor.email,
              'phone': newProfessor.nmbofphone,
              'age': newProfessor.age,
              'situation': newProfessor.situation,
              'specialty': newProfessor.specialty,
              'sex': newProfessor.sex,
              'yearOfStart': newProfessor.yearofstart,
            });
          },
        );
      },
    );
  }

  void _editProfessor(ProfessorModel professor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddProfessorDialog(
          professor: professor,
          onAdd: (editedProfessor) async {
            try {
              // Retrieve the document ID
              var querySnapshot = await _firestore
                  .collection('professors')
                  .where('email', isEqualTo: professor.email)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                var docId = querySnapshot.docs.first.id; // Document ID

                if (docId.isEmpty) {
                  throw Exception("Invalid document ID");
                }

                var documentReference =
                    _firestore.collection('professors').doc(docId);

                // Ensure the document exists before updating
                var documentSnapshot = await documentReference.get();
                if (!documentSnapshot.exists) {
                  throw Exception("Document not found");
                }

                // Update the document
                await documentReference.update({
                  'firstname': editedProfessor.firstname,
                  'lastname': editedProfessor.lastname,
                  'grade': editedProfessor.grade,
                  'email': editedProfessor.email,
                  'phone': editedProfessor.nmbofphone,
                  'age': editedProfessor.age,
                  'situation': editedProfessor.situation,
                  'specialty': editedProfessor.specialty,
                  'sex': editedProfessor.sex,
                  'yearOfStart': editedProfessor.yearofstart,
                });

                Navigator.pop(context); // Close the dialog on success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Professeur change it successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                throw Exception("Document not found");
              }
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error updating professor: $error"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _deleteProfessor(ProfessorModel professor) async {
    try {
      var querySnapshot = await _firestore
          .collection('professors')
          .where('email', isEqualTo: professor.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id; // Get the document ID
        await _firestore.collection('professors').doc(docId).delete();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting professor: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _importExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        var decoder = SpreadsheetDecoder.decodeBytes(fileBytes);
        var table = decoder.tables['Sheet1'];
        if (table != null) {
          for (var row in table.rows.skip(1)) {
            _firestore.collection('professors').add({
              'firstname': row[0]?.toString() ?? '',
              'lastname': row[1]?.toString() ?? '',
              'grade': row[2]?.toString() ?? '',
              'email': row[3]?.toString() ?? '',
              'phone': row[4]?.toString() ?? '',
              'age': row[5]?.toString() ?? '',
              'situation': row[6]?.toString() ?? '',
              'specialty': row[7]?.toString() ?? '',
              'sex': row[8]?.toString() ?? '',
              'yearOfStart': row[9]?.toString() ?? '',
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Professor Management"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('professors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          var professorDocs = snapshot.data?.docs ?? [];
          var filteredDocs = professorDocs.where((doc) {
            var professor = ProfessorModel(
              firstname: doc['firstname'] ?? '',
              lastname: doc['lastname'] ?? '',
              grade: doc['grade'] ?? '',
              email: doc['email'] ?? '',
              nmbofphone: doc['phone'] ?? '',
              age: doc['age'] ?? '',
              situation: doc['situation'] ?? '',
              specialty: doc['specialty'] ?? '',
              sex: doc['sex'] ?? '',
              yearofstart: doc['yearOfStart'] ?? '',
            );
            return professor.matchesSearch(searchText);
          }).toList();

          return Stack(
            children: [
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustumTextField(
                          width: 300,
                          labelText: 'Search Professor',
                          icons: const Icon(Icons.search),
                          onChanged: (text) {
                            setState(() {
                              searchText = text;
                            });
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                        Dropdown(
                          width: 200,
                          options: listsholarship,
                          selected: selectscholarship,
                          onChanged: (String? value) {
                            setState(() {
                              selectscholarship = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a level";
                            }
                            return null;
                          },
                          label: 'select scholarship',
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        CustomButton(
                          onPressed: _importExcel,
                          color: primary,
                          option: 'Upload File ',
                          icons: Icons.upload_file,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        CustomButton(
                          onPressed: () {
                            _print.generateAndPrintPdfProf(selectscholarship);
                          },
                          color: primary,
                          option: 'Print List ',
                          icons: Icons.print,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("First Name")),
                            DataColumn(label: Text("Last Name")),
                            DataColumn(label: Text("Grade")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Phone Number")),
                            DataColumn(label: Text("Age")),
                            DataColumn(label: Text("Situation")),
                            DataColumn(label: Text("Specialty")),
                            DataColumn(label: Text("Sex")),
                            DataColumn(label: Text("Year of Start")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows: filteredDocs.map((doc) {
                            var professor = ProfessorModel(
                              firstname: doc['firstname'] ?? '',
                              lastname: doc['lastname'] ?? '',
                              grade: doc['grade'] ?? '',
                              email: doc['email'] ?? '',
                              nmbofphone: doc['phone'] ?? '',
                              age: doc['age'] ?? '',
                              situation: doc['situation'] ?? '',
                              specialty: doc['specialty'] ?? '',
                              sex: doc['sex'] ?? '',
                              yearofstart: doc['yearOfStart'] ?? '',
                            );
                            return DataRow(
                              cells: [
                                DataCell(Text(professor.firstname)),
                                DataCell(Text(professor.lastname)),
                                DataCell(Text(professor.grade)),
                                DataCell(Text(professor.email)),
                                DataCell(Text(professor.nmbofphone)),
                                DataCell(Text(professor.age)),
                                DataCell(Text(professor.situation)),
                                DataCell(Text(professor.specialty)),
                                DataCell(Text(professor.sex)),
                                DataCell(Text(professor.yearofstart)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        color: primary,
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _editProfessor(professor);
                                        },
                                      ),
                                      IconButton(
                                        color: primary,
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteProfessor(professor);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20.0,
                right: 20.0,
                child: FloatingActionButton(
                  backgroundColor: primary,
                  onPressed: _showAddDialog,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
