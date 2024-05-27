import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniwayapp/Model/Studentmodel.dart';
import 'package:uniwayapp/colors/colors.dart';
import 'package:uniwayapp/service/StudentList.dart';
import 'package:uniwayapp/service/Studentfunction.dart';
import 'package:uniwayapp/widget/Buttom.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart';

class StudentValid extends StatefulWidget {
  const StudentValid({super.key});

  @override
  State<StudentValid> createState() => _StudentValidState();
}

class _StudentValidState extends State<StudentValid> {
  List<Studentmodel> studentList = [];
  String searchText = "";
  final StudentService _studentService = StudentService();
  final StudentServiceList _studentServiceList = StudentServiceList();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String selectscholarship = '';
  List<String> listsholarship = ['Erasmus', 'Insubrie'];

  void toggleStatus(Studentmodel student) {
    setState(() {
      if (student.status == 'Accept') {
        student.status = 'Reject';
      } else if (student.status == 'Reject') {
        student.status = 'Attend';
      } else if (student.status == 'Attend') {
        student.status = 'Accept';
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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final snapshot = await _firestore.collection('students').get();
      final studentData = snapshot.docs.map((doc) {
        final data = doc.data();
        return Studentmodel(
          firstname: data['firstname'],
          lastname: data['lastname'],
          level: data['level'],
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
        studentList = studentData;
        _isLoading = false;
      });

      // Debug print to verify data fetching
      print('Fetched ${studentList.length} students');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Student Validat"),
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
                    labelText: 'Search student',
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
                    onPressed: () {
                      List<Studentmodel> filteredStudents = studentList
                          .where((student) =>
                              student.status == 'Accept' ||
                              student.status == 'Attend' ||
                              student.status == 'Reject')
                          .toList();
                      _studentServiceList.generateAndPrintPdf(filteredStudents);
                    },
                    color: primary,
                    option: 'Print List ',
                    icons: Icons.print,
                  ),
                ],
              ),
              Expanded(
                child: _buildDataTable(searchText),
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

  Widget _buildDataTable(String searchText) {
    List<Studentmodel> filteredStudents = studentList
        .where((student) => student.matchesSearch(searchText))
        .toList();
    // Filter students based on scholarship selection
    if (selectscholarship == 'Erasmus') {
      filteredStudents = filteredStudents
          .where((student) =>
              ['Iman', 'Ahmed', 'fatima'].contains(student.firstname))
          .toList();
    } else if (selectscholarship == 'Insubrie') {
      filteredStudents = filteredStudents
          .where((student) => student.firstname == 'amina')
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
          DataColumn(label: Text("Level")),
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
        rows:
            filteredStudents.map((student) => _buildDataRow(student)).toList(),
      ),
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
          InkWell(
            onTap: () => toggleStatus(student),
            child: Text(
              student.status ?? 'Selct please',
              style: TextStyle(
                color: getStatusColor(student.status ?? ''),
              ),
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              if (student.status == 'Accept') {
                _studentService.generateAndPrintPdf(student, selectscholarship);
              }
            },
            color: student.status == 'Accept' ? primary : Colors.grey,
          ),
        ),
      ],
    );
  }
}
