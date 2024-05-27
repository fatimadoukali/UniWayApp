import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniwayapp/widget/TextFiled.dart';
import 'package:uniwayapp/widget/AddScholarshipDialog.dart';
import 'package:uniwayapp/Model/ScholarshipModel.dart';
import '../colors/colors.dart';

class ScholarshipManagment extends StatefulWidget {
  const ScholarshipManagment({super.key});

  @override
  _ScholarshipManagementState createState() => _ScholarshipManagementState();
}

class _ScholarshipManagementState extends State<ScholarshipManagment> {
  String searchText = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddScholarshipDialog(
          onAdd: (ScholarshipModel newScholarship) {
            _firestore.collection('scholarships').add({
              'scholarshipName': newScholarship.ScholarshipName,
              'scholarshipType': newScholarship.ScholarshipType,
              'years': newScholarship.years,
              'scholarshipAmount': newScholarship.SchoalrshipAmount,
              'scholarshipDeadlines': newScholarship.ScholarshipDeadlines,
              'academicLanguage': newScholarship.AcdimicLanguage,
              'universityName': newScholarship.UniversityName,
              'pays': newScholarship.pays,
              'scholarshipDocuments': newScholarship.ScholarshipDocuments,
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Scholarship Management"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('scholarships').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          var scholarshipsDocs = snapshot.data?.docs ?? [];
          var filteredDocs = scholarshipsDocs.where((doc) {
            var scholarship = ScholarshipModel(
              ScholarshipName: doc['scholarshipName'] ?? '',
              ScholarshipType: doc['scholarshipType'] ?? '',
              years: doc['years'] ?? '',
              SchoalrshipAmount: doc['scholarshipAmount'] ?? '',
              ScholarshipDeadlines: doc['scholarshipDeadlines'] ?? '',
              AcdimicLanguage: doc['academicLanguage'] ?? '',
              UniversityName: doc['universityName'] ?? '',
              pays: doc['pays'] ?? '',
              ScholarshipDocuments: doc['scholarshipDocuments'] ?? '',
            );
            return scholarship.matchesSearch(searchText);
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
                    CustumTextField(
                      width: 300,
                      labelText: 'Search Scholarship',
                      icons: const Icon(Icons.search),
                      onChanged: (text) {
                        setState(() {
                          searchText = text;
                        });
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Scholarship Name")),
                            DataColumn(label: Text("Scholarship Type")),
                            DataColumn(label: Text("Years")),
                            DataColumn(label: Text("Scholarship Amount")),
                            DataColumn(label: Text("Scholarship Deadlines")),
                            DataColumn(label: Text("Academic Language")),
                            DataColumn(label: Text("University Name")),
                            DataColumn(label: Text("Pays")),
                            DataColumn(label: Text("Scholarship Documents")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows: filteredDocs.map((doc) {
                            var scholarship = ScholarshipModel(
                              ScholarshipName: doc['scholarshipName'] ?? '',
                              ScholarshipType: doc['scholarshipType'] ?? '',
                              years: doc['years'] ?? '',
                              SchoalrshipAmount: doc['scholarshipAmount'] ?? '',
                              ScholarshipDeadlines:
                                  doc['scholarshipDeadlines'] ?? '',
                              AcdimicLanguage: doc['academicLanguage'] ?? '',
                              UniversityName: doc['universityName'] ?? '',
                              pays: doc['pays'] ?? '',
                              ScholarshipDocuments:
                                  doc['scholarshipDocuments'] ?? '',
                            );
                            return _buildDataRow(scholarship);
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

  DataRow _buildDataRow(ScholarshipModel scholarship) {
    return DataRow(
      cells: [
        DataCell(Text(scholarship.ScholarshipName)),
        DataCell(Text(scholarship.ScholarshipType)),
        DataCell(Text(scholarship.years)),
        DataCell(Text(scholarship.SchoalrshipAmount)),
        DataCell(Text(scholarship.ScholarshipDeadlines)),
        DataCell(Text(scholarship.AcdimicLanguage)),
        DataCell(Text(scholarship.UniversityName)),
        DataCell(Text(scholarship.pays)),
        DataCell(Text(scholarship.ScholarshipDocuments)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editScholarship(scholarship);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteScholarship(scholarship);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

 void _editScholarship(ScholarshipModel scholarship) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddScholarshipDialog(
        scholarship: scholarship,
        onAdd: (editedScholarship) async {
          try {
            // Récupérer le document correspondant
            var querySnapshot = await _firestore
                .collection('scholarships')
                .where('scholarshipName', isEqualTo: scholarship.ScholarshipName)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              var docId = querySnapshot.docs.first.id; // Obtenir l'ID du document

              if (docId.isNotEmpty) {
                // Vérification si docId n'est pas vide
                await _firestore.collection('scholarships').doc(docId).update({
                  'scholarshipName': editedScholarship.ScholarshipName,
                  'scholarshipType': editedScholarship.ScholarshipType,
                  'years': editedScholarship.years,
                  'scholarshipAmount': editedScholarship.SchoalrshipAmount,
                  'scholarshipDeadlines': editedScholarship.ScholarshipDeadlines,
                  'academicLanguage': editedScholarship.AcdimicLanguage,
                  'universityName': editedScholarship.UniversityName,
                  'pays': editedScholarship.pays,
                  'scholarshipDocuments': editedScholarship.ScholarshipDocuments,
                });

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text("Scholarship updated successfully"),
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
                content: Text("Error updating scholarship: $error"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    },
  );
}

  void _deleteScholarship(ScholarshipModel scholarship) async {
    var querySnapshot = await _firestore
        .collection('scholarships')
        .where('scholarshipName', isEqualTo: scholarship.ScholarshipName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var docId = querySnapshot.docs.first.id; // Get the document ID
      await _firestore.collection('scholarships').doc(docId).delete();
    }
  }
}
