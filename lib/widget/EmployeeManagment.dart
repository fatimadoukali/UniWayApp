import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniwayapp/Model/employeemodel.dart';
import 'package:uniwayapp/colors/colors.dart';
import 'package:uniwayapp/widget/AddUserDialog.dart';
import 'package:uniwayapp/widget/TextFiled.dart'; // Import des couleurs personnalisées

class EmployeeManagementPage extends StatefulWidget {
  const EmployeeManagementPage({super.key});

  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<EmployeeRequest> employees = []; // Liste des employés
  String searchText = ""; // Texte de recherche

  @override
  void initState() {
    super.initState();
    _fetchEmployees(); // Récupère les données lors de l'initialisation
  }

  // Récupérer les employés depuis Firestore
  void _fetchEmployees() async {
    final snapshot = await _firestore.collection('employees').get();
    final employeeList = snapshot.docs.map((doc) {
      final data = doc.data();
      return EmployeeRequest(
        name: data['name'],
        email: data['email'],
        job: data['job'],
        password: data['password'],
      );
    }).toList();

    setState(() {
      employees = employeeList; // Mettre à jour la liste des employés
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Employee Management"),
      ),
      body: Stack(
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
                  labelText: 'Search employee',
                  icons: const Icon(
                      Icons.search), // Correction du nom de l'attribut
                  onChanged: (text) {
                    setState(() {
                      searchText = text.toLowerCase(); // Normalisation du texte
                    });
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: _buildEmployeeTable(searchText),
                    ), // Correction du nom de la fonction
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
              onPressed: () {
                // Creating a default EmployeeRequest instance to pass to the dialog
                final newEmployee = EmployeeRequest(
                  name: "",
                  email: "",
                  password: "",
                  job: "",
                );
                _showAddEmployeeDialog(newEmployee);
              },
              tooltip: "add employee", // Correction de la fonction à appeler
              child: const Icon(Icons.add,
                  color: Colors.white), // Infobulle pour plus de clarté
            ),
          ),
        ],
      ),
    );
  }
  // Construire la table des employés avec recherche
  Widget _buildEmployeeTable(String searchText) {
    final filteredEmployees = employees
        .where((employee) =>
            employee.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return DataTable(
      headingTextStyle: const TextStyle(
        color: grey1,
        fontSize: 17,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w200,
      ),
      columns: const [
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Email")),
        DataColumn(label: Text("Password")),
        DataColumn(label: Text("Employee")),
        DataColumn(
            label: Text(
                "Action")), // Colonne pour les actions de suppression et d'édition
      ],
      rows:
          filteredEmployees.map((employee) => _buildDataRow(employee)).toList(),
    );
  }

  // Construire une ligne de données pour la table
  DataRow _buildDataRow(EmployeeRequest employee) {
    return DataRow(
      cells: [
        DataCell(Text(employee.name)),
        DataCell(Text(employee.email)),
        DataCell(Text(employee.password)),
        DataCell(Text(employee.job)),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () => _showEditEmployeeDialog(
                    employee), // Appeler le dialogue d'édition
                icon: const Icon(Icons.edit),
                color: primary,
              ),
              IconButton(
                onPressed: () =>
                    _deleteEmployee(employee), // Logique de suppression
                icon: const Icon(Icons.delete),
                color: primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Afficher le dialogue d'ajout d'employé
  void _showAddEmployeeDialog(EmployeeRequest employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUserDialog(
          onAdd: (newEmployee) async {
            await _addEmployee(newEmployee);
          },
          employee: employee,
        );
      },
    );
  }

  // Ajouter un nouvel employé à Firestore et Firebase Auth
  Future<void> _addEmployee(EmployeeRequest newEmployee) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: newEmployee.email,
        password: newEmployee.password,
      );

      await _firestore
          .collection('employees')
          .doc(userCredential.user!.uid)
          .set({
        'name': newEmployee.name,
        'email': newEmployee.email,
        'job': newEmployee.job,
        'password': newEmployee.password,
      });

      _fetchEmployees(); // Rafraîchir la liste des employés

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Employee added successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("error while adding employee."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Afficher le dialogue d'édition d'employé
  void _showEditEmployeeDialog(EmployeeRequest employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUserDialog(
          onAdd: (updatedEmployee) async {
            await _updateEmployee(updatedEmployee);
          },
          employee: employee,
        );
      },
    );
  }

// Mettre à jour les détails d'un employé
  Future<void> _updateEmployee(EmployeeRequest updatedEmployee) async {
    try {
      // Trouver le document associé à cet employé par son e-mail
      var querySnapshot = await _firestore
          .collection('employees')
          .where('email', isEqualTo: updatedEmployee.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Utiliser l'ID du premier document trouvé pour mettre à jour les données
        var docId = querySnapshot.docs.first.id;

        await _firestore.collection('employees').doc(docId).update({
          'name': updatedEmployee.name,
          'email': updatedEmployee.email,
          'job': updatedEmployee.job,
          'password': updatedEmployee.password,
        });

        _fetchEmployees(); // Rafraîchir la liste après mise à jour

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Employee successfully updated."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Employee not found."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error when updating employee."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Supprimer un employé de Firestore
  void _deleteEmployee(EmployeeRequest employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("delete employee"),
        content: Text("Be sure you want to delete ${employee.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Trouver le document associé à cet employé par son e-mail
                var querySnapshot = await _firestore
                    .collection('employees')
                    .where('email', isEqualTo: employee.email)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  // Utiliser l'ID du premier document trouvé pour supprimer le document
                  var docId = querySnapshot.docs.first.id;

                  await _firestore.collection('employees').doc(docId).delete();

                  _fetchEmployees(); // Rafraîchir la liste des employés après suppression

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Employee successfully deleted"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Employee not found."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Error when deleting employee."),
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
