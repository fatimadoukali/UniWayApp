import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:uniwayapp/Model/adminstatoemodel.dart';
import 'package:uniwayapp/service/auth_service.dart';
import 'package:uniwayapp/widget/AddAdminDialog.dart';
import 'package:uniwayapp/widget/Buttom.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart';
import 'package:uniwayapp/colors/colors.dart';

class AdminstratorManagement extends StatefulWidget {
  const AdminstratorManagement({super.key});

  @override
  _AdminstratorManagementState createState() => _AdminstratorManagementState();
}

class _AdminstratorManagementState extends State<AdminstratorManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Authservice _print = Authservice();
  String searchText = ""; // To filter administrators
  List<AdminstratorsModele> adminList = []; // Local cache for administrators
  String selectscholarship = '';
  List<String> listsholarship = ['Erasmus', 'Insubrie'];

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
            _firestore.collection('administrators').add({
              'firstname': row[0]?.toString() ?? '',
              'lastname': row[1]?.toString() ?? '',
              'job': row[2]?.toString() ?? '',
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
        title: const Text("Administrator Management"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('administrators').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error loading administrators: ${snapshot.error}"));
          }

          var adminDocs = snapshot.data?.docs ?? [];
          adminList = adminDocs.map((doc) {
            return AdminstratorsModele(
              firstname: doc['firstname'] ?? '',
              lastname: doc['lastname'] ?? '',
              job: doc['job'] ?? '',
              email: doc['email'] ?? '',
              nmbofphone: doc['phone'] ?? '',
              age: doc['age'] ?? '',
              situation: doc['situation'] ?? '',
              specialty: doc['specialty'] ?? '',
              sex: doc['sex'] ?? '',
              yearofstart: doc['yearOfStart'] ?? '',
            );
          }).toList();

          // Apply search filter
          var filteredAdmins = adminList.where((admin) {
            bool matchesScholarship = true;
            if (selectscholarship == 'Erasmus') {
              matchesScholarship = admin.firstname == 'fatima';
            } else if (selectscholarship == 'Insubrie') {
              matchesScholarship = admin.firstname== 'homis';
            }

            return matchesScholarship && (admin.firstname.toLowerCase().contains(searchText.toLowerCase()) || admin.lastname.toLowerCase().contains(searchText.toLowerCase()));
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
                          labelText: 'Search Administrator',
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
                          label: 'Select Scholarship',
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        CustomButton(
                          onPressed: _importExcel,
                          color: primary,
                          option: 'Upload File',
                          icons: Icons.upload_file,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        CustomButton(
                          onPressed: () {
                            _print.generateAndPrintPdfAdmin(selectscholarship);
                          },
                          color: primary,
                          option: 'Print List',
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
                            DataColumn(label: Text("Job")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Phone")),
                            DataColumn(label: Text("Age")),
                            DataColumn(label: Text("Situation")),
                            DataColumn(label: Text("Specialty")),
                            DataColumn(label: Text("Sex")),
                            DataColumn(label: Text("Year of Start")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: filteredAdmins.map((admin) {
                            return DataRow(
                              cells: [
                                DataCell(Text(admin.firstname)),
                                DataCell(Text(admin.lastname)),
                                DataCell(Text(admin.job)),
                                DataCell(Text(admin.email)),
                                DataCell(Text(admin.nmbofphone)),
                                DataCell(Text(admin.age)),
                                DataCell(Text(admin.situation)),
                                DataCell(Text(admin.specialty)),
                                DataCell(Text(admin.sex)),
                                DataCell(Text(admin.yearofstart)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: primary,
                                        ),
                                        onPressed: () => _editAdmin(admin),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: primary,
                                        ),
                                        onPressed: () => _deleteAdmin(admin),
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
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAdminDialog(
          onAdd: (newAdmin) async {
            try {
              await _firestore.collection('administrators').add({
                'firstname': newAdmin.firstname,
                'lastname': newAdmin.lastname,
                'job': newAdmin.job,
                'email': newAdmin.email,
                'phone': newAdmin.nmbofphone,
                'age': newAdmin.age,
                'situation': newAdmin.situation,
                'specialty': newAdmin.specialty,
                'sex': newAdmin.sex,
                'yearOfStart': newAdmin.yearofstart,
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Administrator added successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error adding administrator: $error"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _editAdmin(AdminstratorsModele admin) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAdminDialog(
          administrator: admin, // Pass the existing admin for editing
          onEdit: (editedAdmin) async {
            try {
              var querySnapshot = await _firestore
                  .collection('administrators')
                  .where('email', isEqualTo: admin.email)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                var docId = querySnapshot.docs.first.id;

                if (docId.isEmpty) {
                  throw Exception("Document ID is empty. Cannot update.");
                }

                await _firestore.collection('administrators').doc(docId).update({
                  'firstname': editedAdmin.firstname,
                  'lastname': editedAdmin.lastname,
                  'email': editedAdmin.email,
                  'phone': editedAdmin.nmbofphone,
                  'age': editedAdmin.age,
                  'job': editedAdmin.job,
                  'situation': editedAdmin.situation,
                  'specialty': editedAdmin.specialty,
                  'sex': editedAdmin.sex,
                  'yearOfStart': editedAdmin.yearofstart,
                });

                // Update local list to reflect changes
                setState(() {
                  final index = adminList.indexWhere((a) => a.email == admin.email);
                  if (index != -1) {
                    adminList[index] = editedAdmin;
                  }
                });

                Navigator.pop(context); // Close the dialog on success

                // Show success message
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text("Administrator updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                // Show not found message
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text("Administrator not found"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } catch (error) {
              // Show error message
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text("Error editing administrator: $error"),
                  backgroundColor: Colors.red,
                ),
              );
              debugPrint("Error updating admin: $error");
            }
          },
        );
      },
    );
  }

  void _deleteAdmin(AdminstratorsModele admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Administrator"),
        content: Text("Are you sure you want to delete ${admin.firstname}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                var querySnapshot = await _firestore
                    .collection('administrators')
                    .where('email', isEqualTo: admin.email)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  var docId = querySnapshot.docs.first.id;
                  await _firestore.collection('administrators').doc(docId).delete();

                  setState(() => adminList.removeWhere((a) => a.email == admin.email));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Administrator deleted successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error deleting administrator: $error"),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
