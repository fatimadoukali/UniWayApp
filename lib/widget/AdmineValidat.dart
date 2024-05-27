import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniwayapp/Model/adminstatoemodel.dart';
import 'package:uniwayapp/colors/colors.dart';
import 'package:uniwayapp/service/AdminList.dart';
import 'package:uniwayapp/service/Adminisfunction.dart';
import 'package:uniwayapp/widget/Buttom.dart';
import 'package:uniwayapp/widget/DropdownButton.dart';
import 'package:uniwayapp/widget/TextFiled.dart';

class AdminValid extends StatefulWidget {
  const AdminValid({super.key});

  @override
  State<AdminValid> createState() => _AdminValidState();
}

class _AdminValidState extends State<AdminValid> {
  List<AdminstratorsModele> proflist = [];
  String searchText = "";
  final AdminService _adminservice = AdminService();
  final AdminServiceList admin = AdminServiceList();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String selectscholarship = '';
  List<String> listsholarship = ['Erasmus', 'Insubrie'];
  void toggleStatus(AdminstratorsModele admin) {
    setState(() {
      if (admin.status == 'Accept') {
        admin.status = 'Reject';
      } else if (admin.status == 'Reject') {
        admin.status = 'Attend';
      } else if (admin.status == 'Attend') {
        admin.status = 'Accept';
      } else {
        admin.status = 'Selct please';
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
      final snapshot = await _firestore.collection('administrators').get();
      final studentdata = snapshot.docs.map((doc) {
        final data = doc.data();
        return AdminstratorsModele(
          firstname: data['firstname'],
          lastname: data['lastname'],
          job: data['job'],
          email: data['email'],
          nmbofphone: data['phone'],
          age: data['age'],
          situation: data['situation'],
          specialty: data['specialty'],
          sex: data['sex'] ?? '',
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
        title: const Text("Administrator Validat"),
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
                    labelText: 'Search Adminstrator ',
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
                  //choose the scholarship and return the list of student for the scholarship
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
                      List<AdminstratorsModele> filteredStudents = proflist
                          .where((student) =>
                              student.status == 'Accept' ||
                              student.status == 'Attend' ||
                              student.status == 'Reject')
                          .toList();
                      admin.generateAndPrintPdf(filteredStudents);
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
    List<AdminstratorsModele> filtered =
        proflist.where((admin) => admin.matchesSearch(searchText)).toList();

    // Filter administrators based on scholarship selection
    if (selectscholarship == 'Erasmus') {
      filtered = filtered
          .where((admin) => ['fatima'].contains(admin.firstname))
          .toList();
    } else if (selectscholarship == 'Insubrie') {
      filtered = filtered.where((admin) => admin.firstname == 'homis').toList();
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
          DataColumn(label: Text("job")),
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

  DataRow _buildDataRow(AdminstratorsModele Aminis) {
    return DataRow(
      cells: [
        DataCell(Text(Aminis.firstname)),
        DataCell(Text(Aminis.lastname)),
        DataCell(Text(Aminis.job)),
        DataCell(Text(Aminis.email)),
        DataCell(Text(Aminis.nmbofphone)),
        DataCell(Text(Aminis.age)),
        DataCell(Text(Aminis.situation)),
        DataCell(Text(Aminis.specialty)),
        DataCell(Text(Aminis.sex)),
        DataCell(Text(Aminis.yearofstart)),
        DataCell(
          InkWell(
            onTap: () => toggleStatus(Aminis),
            child: Text(
              Aminis.status ?? 'Selct please',
              style: TextStyle(
                color: getStatusColor(Aminis.status ?? ''),
              ),
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              if (Aminis.status == 'Accept') {
                _adminservice.generateAndPrintPdf(Aminis, selectscholarship);
              }
            },
            color: Aminis.status == 'Accept' ? primary : Colors.grey,
          ),
        ),
      ],
    );
  }
}
