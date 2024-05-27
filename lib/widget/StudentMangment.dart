import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniwayapp/Model/Studentmodel.dart';
import 'package:uniwayapp/service/auth_service.dart';
import 'package:uniwayapp/widget/Buttom.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart';
import 'package:uniwayapp/widget/AddStudentDialog.dart';
import '../colors/colors.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  _StudentManagementState createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  String searchText = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Authservice _print = Authservice();
  String selectscholarship = '';
  List<String> listsholarship = ['Erasmus', 'Insubrie'];

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddStudentDialog(
          onAdd: (Studentmodel newStudent) {
            _firestore.collection('students').add({
              'firstname': newStudent.firstname,
              'lastname': newStudent.lastname,
              'level': newStudent.level,
              'email': newStudent.email,
              'phone': newStudent.nmbofphone,
              'age': newStudent.age,
              'situation': newStudent.situation,
              'specialty': newStudent.specialty,
              'sex': newStudent.sex,
              'yearOfStart': newStudent.yearofstart,
            });
          },
        );
      },
    );
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
            _firestore.collection('students').add({
              'firstname': row[0]?.toString() ?? '',
              'lastname': row[1]?.toString() ?? '',
              'level': row[2]?.toString() ?? '',
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
        title: const Text("Student Management"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          var studentDocs = snapshot.data?.docs ?? [];
          var filteredDocs = studentDocs.where((doc) {
            var student = Studentmodel(
              firstname: doc['firstname'] ?? '',
              lastname: doc['lastname'] ?? '',
              level: doc['level'] ?? '',
              email: doc['email'] ?? '',
              nmbofphone: doc['phone'] ?? '',
              age: doc['age'] ?? '',
              situation: doc['situation'] ?? '',
              specialty: doc['specialty'] ?? '',
              sex: doc['sex'] ?? '',
              yearofstart: doc['yearOfStart'] ?? '',
            );

            bool matchesScholarship = true;
            if (selectscholarship == 'Erasmus') {
              matchesScholarship = student.firstname == 'Iman' || student.firstname == 'Ahmed' ||student.firstname == 'fatima';
            }
            else  if (selectscholarship == 'Insubrie') {
              matchesScholarship = student.firstname == 'amina' ;
            }
            return student.matchesSearch(searchText) && matchesScholarship;
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CustumTextField(
                          width: 300,
                          labelText: 'Search Student',
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
                        //select scholarship for add student
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
                              return "Please select a scholarship type";
                            }
                            return null;
                          },
                          label: 'Select Scholarship',
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
                            _print.generateAndPrintPdf(selectscholarship);
                          },
                          color: primary,
                          option: 'Print List ',
                          icons: Icons.print,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildDataTable(filteredDocs),
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

  Widget _buildDataTable(List<DocumentSnapshot> studentDocs) {
    return DataTable(
      columns: const [
        DataColumn(label: Text("First Name")),
        DataColumn(label: Text("Last Name")),
        DataColumn(label: Text("Level")),
        DataColumn(label: Text("Email")),
        DataColumn(label: Text("Phone")),
        DataColumn(label: Text("Age")),
        DataColumn(label: Text("Situation")),
        DataColumn(label: Text("Specialty")),
        DataColumn(label: Text("Sex")),
        DataColumn(label: Text("Year of Start")),
        DataColumn(label: Text("Action")),
      ],
      rows: studentDocs.map((doc) {
        var student = Studentmodel(
          firstname: doc['firstname'] ?? '',
          lastname: doc['lastname'] ?? '',
          level: doc['level'] ?? '',
          email: doc['email'] ?? '',
          nmbofphone: doc['phone'] ?? '',
          age: doc['age'] ?? '',
          situation: doc['situation'] ?? '',
          specialty: doc['specialty'] ?? '',
          sex: doc['sex'] ?? '',
          yearofstart: doc['yearOfStart'] ?? '',
        );
        return _buildDataRow(student);
      }).toList(),
    );
  }

  DataRow _buildDataRow(Studentmodel student) {
    return DataRow(
      cells: [
        DataCell(Text(student.firstname)),
        DataCell(Text(student.lastname)),
        DataCell(Text(student.level)),
        DataCell(Text(student.email)),
        DataCell(Text(student.nmbofphone)),
        DataCell(Text(student.age)),
        DataCell(Text(student.situation)),
        DataCell(Text(student.specialty)),
        DataCell(Text(student.sex)),
        DataCell(Text(student.yearofstart)),
        DataCell(
          Row(
            children: [
              IconButton(
                color: primary,
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editStudent(student);
                },
              ),
              IconButton(
                color: primary,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteStudent(student, student.email);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editStudent(Studentmodel student) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AddStudentDialog(
        student: student,
        onAdd: (editedStudent) async {
          try {
            if (editedStudent == null) {
              throw Exception("Edited student data is null");
            }

            // Fetch the document corresponding to the student's email
            var querySnapshot = await _firestore
                .collection('students')
                .where('email', isEqualTo: student.email)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              var docId = querySnapshot.docs.first.id; // Obtain the document ID

              if (docId.isNotEmpty) {
                // Update the student document
                await _firestore.collection('students').doc(docId).update({
                  'firstname': editedStudent.firstname,
                  'lastname': editedStudent.lastname,
                  'level': editedStudent.level,
                  'email': editedStudent.email,
                  'phone': editedStudent.nmbofphone,
                  'age': editedStudent.age,
                  'situation': editedStudent.situation,
                  'specialty': editedStudent.specialty,
                  'sex': editedStudent.sex,
                  'yearOfStart': editedStudent.yearofstart,
                });

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text("Student updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                throw Exception("Document ID is empty");
              }
            } else {
              throw Exception("Document not found");
            }
          } catch (error) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text("Error updating student: $error"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _deleteStudent(Studentmodel student, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Student"),
        content: Text("Are you sure you want to delete ${student.firstname}?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Supprimer l'étudiant de Firestore
              // Récupérer le document qui correspond à l'e-mail donné
              var querySnapshot = await _firestore
                  .collection('students')
                  .where("email", isEqualTo: email)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                // Obtenir le premier document correspondant à l'e-mail
                var doc = querySnapshot.docs.first;

                // Supprimer le document avec l'identifiant récupéré
                await _firestore.collection('students').doc(doc.id).delete();

                print("Student with email $email deleted.");
              } else {
                print("No student found with email $email.");
              }
              Navigator.pop(context); // Ferme la boîte de dialogue
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
