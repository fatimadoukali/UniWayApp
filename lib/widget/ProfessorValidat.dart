import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:uniwayapp/Model/professormodel.dart';
import 'package:uniwayapp/colors/colors.dart';
import 'package:uniwayapp/service/ProfessorList.dart';
import 'package:uniwayapp/service/Professorfunction.dart';
import 'package:uniwayapp/widget/Buttom.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart';

class ProfessorValid extends StatefulWidget {
  const ProfessorValid({super.key});

  @override
  State<ProfessorValid> createState() => _ProfessorValidState();
}

class _ProfessorValidState extends State<ProfessorValid> {
  List<ProfessorModel> proflist = [];
  final ProfService _profservice = ProfService();
  final ProfServiceList prof = ProfServiceList();
  String searchText = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String selectscholarship = '';
  List<String> listsholarship = ['Erasmus', 'Insubrie'];
  void toggleStatus(ProfessorModel prof) {
    setState(() {
      if (prof.status == 'Accept') {
        prof.status = 'Reject';
      } else if (prof.status == 'Reject') {
        prof.status = 'Attend';
      } else if (prof.status == 'Attend') {
        prof.status = 'Accept';
      } else {
        prof.status = 'Selct please';
      }
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Accept':
        return Colors.green;
      case 'Reject':
        return Colors.red;
      case 'Attend':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _fetchdata() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final snapshot = await _firestore.collection('professors').get();
      final studentdata = snapshot.docs.map((doc) {
        final data = doc.data();
        return ProfessorModel(
          firstname: data['firstname'],
          lastname: data['lastname'],
          grade: data['grade'],
          email: data['email'],
          nmbofphone: data['phone'],
          age: data['age'],
          situation: data['situation'],
          specialty: data['specialty'],
          sex: data['sex'],
          yearofstart: data['yearOfStart'],
          status: 'Reject',
        );
      }).toList();

      setState(() {
        proflist = studentdata;
        _isLoading = false;
      });

      // Debug print to verify data fetching
      print('Fetched ${proflist.length} prof');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Professor Validat"),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  CustumTextField(
                    width: 300,
                    labelText: 'Search proffesor ',
                    icons: const Icon(Icons.search),
                    onChanged: (text) {
                      setState(() {
                        searchText = text;
                      });
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
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
                        return "Please select a grade";
                      }
                      return null;
                    },
                    label: 'select scholarship',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  CustomButton(
                    onPressed: () {
                      List<ProfessorModel> filteredStudents = proflist
                          .where((student) =>
                              student.status == 'Accept' ||
                              student.status == 'Attend' ||
                              student.status == 'Reject')
                          .toList();
                      prof.generateAndPrintPdf(
                          filteredStudents, selectscholarship);
                    },
                    color: primary,
                    option: 'Print List ',
                    icons: Icons.print,
                  ),
                ],
              ),
              Expanded(
                child: _buildCompteTable(searchText),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompteTable(String searchText) {
    List<ProfessorModel> filtered =
        proflist.where((prof) => prof.matchesSearch(searchText)).toList();

    // Filter professors based on scholarship selection
    if (selectscholarship == 'Erasmus') {
      filtered = filtered
          .where((prof) => ['boumadin'].contains(prof.firstname))
          .toList();
    } else if (selectscholarship == 'Insubrie') {
      filtered = filtered
          .where((prof) =>
              prof.firstname == 'fatima' || prof.firstname == 'bourase')
          .toList();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
          color: grey2,
        ),
        headingTextStyle: const TextStyle(
          color: grey1,
          fontSize: 17,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w200,
        ),
        columns: const [
          DataColumn(label: Text("First Name")),
          DataColumn(label: Text("Last Name")),
          DataColumn(label: Text("Grade")),
          DataColumn(label: Text("Email")),
          DataColumn(label: Text("N phone")),
          DataColumn(label: Text("Age")),
          DataColumn(label: Text("Situation")),
          DataColumn(label: Text("Specialty")),
          DataColumn(label: Text("Sex")),
          DataColumn(label: Text("Year of start")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Print")),
        ],
        rows: filtered.map((student) => _buildDataRow(student)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(ProfessorModel Proffesor) {
    return DataRow(
      cells: [
        DataCell(Text(Proffesor.firstname)),
        DataCell(Text(Proffesor.lastname)),
        DataCell(Text(Proffesor.grade)),
        DataCell(Text(Proffesor.email)),
        DataCell(Text(Proffesor.nmbofphone)),
        DataCell(Text(Proffesor.age)),
        DataCell(Text(Proffesor.situation)),
        DataCell(Text(Proffesor.specialty)),
        DataCell(Text(Proffesor.sex)),
        DataCell(Text(Proffesor.yearofstart)),
        DataCell(
          InkWell(
            onTap: () => toggleStatus(Proffesor),
            child: Text(
              Proffesor.status ?? 'Selct please',
              style: TextStyle(
                color: getStatusColor(Proffesor.status ?? ''),
              ),
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              if (Proffesor.status == 'Accept') {
                _profservice.generateAndPrintPdf(Proffesor, selectscholarship);
              }
            },
            color: Proffesor.status == 'Accept' ? primary : Colors.grey,
          ),
        ),
      ],
    );
  }
}
