import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:uniwayapp/Model/Studentmodel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:uniwayapp/Model/adminstatoemodel.dart';
import 'package:uniwayapp/Model/professormodel.dart';

class Authservice {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email.trim());
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> generateAndPrintPdf(String namesholarship) async {
    final pdf = pw.Document();
    final imageData = await rootBundle.load('asset/image/logo7.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());
    var studentDocs = await _firestore.collection('students').get();
    var students = studentDocs.docs.map((doc) {
      var data = doc.data();
      return Studentmodel(
        firstname: data['firstname'] ?? '',
        lastname: data['lastname'] ?? '',
        level: data['level'] ?? '',
        email: data['email'] ?? '',
        nmbofphone: data['phone'] ?? '',
        age: data['age'] ?? '',
        situation: data['situation'] ?? '',
        specialty: data['specialty'] ?? '',
        sex: data['sex'] ?? '',
        yearofstart: data['yearOfStart'] ?? '',
      );
    }).toList();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(children: [
                pw.Image(image, width: 100, height: 100),
                pw.SizedBox(width: 10),
                pw.Column(children: [
                  pw.Text(
                    'Democratic and Popular Republic of Algeria',
                    style: const pw.TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Ministry Of Higher Education And Scientific Research',
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'University of Ain Temouchent',
                    style: const pw.TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'BR284 RP,46000,AIN TEMOUCHENT,Algeria',
                    style: const pw.TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Tel/Fax:002134379386',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey900,
                    ),
                  ),
                  pw.UrlLink(
                    destination: 'https://www.univ-temouchent.edu.dz/',
                    child: pw.Text(
                      'https://www.univ-temouchent.edu.dz/',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.black,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ]),
              ]),
              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text(
                  namesholarship,
                  style: const pw.TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                'Student List',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'The table below represents information about candidate students:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                tableWidth: pw.TableWidth.max,
                headers: [
                  'First Name',
                  'Last Name',
                  'Level',
                  'Email',
                  'Phone',
                  'Age',
                  'Situation',
                  'Specialty',
                ],
                data: students.map((student) {
                  return [
                    student.firstname,
                    student.lastname,
                    student.level,
                    student.email,
                    student.nmbofphone,
                    student.age,
                    student.situation,
                    student.specialty,
                  ];
                }).toList(),
                border: pw.TableBorder.all(color: PdfColors.black),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey800,
                ),
                cellStyle: const pw.TextStyle(
                  fontSize: 10,
                ),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.centerLeft,
                  5: pw.Alignment.centerLeft,
                  6: pw.Alignment.centerLeft,
                  7: pw.Alignment.centerLeft,
                },
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> generateAndPrintPdfProf(String namesholarship) async {
    final pdf = pw.Document();
    final imageData = await rootBundle.load('asset/image/logo7.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());
    var studentDocs = await _firestore.collection('professors').get();
    var students = studentDocs.docs.map((doc) {
      var data = doc.data();
      return ProfessorModel(
        firstname: data['firstname'] ?? '',
        lastname: data['lastname'] ?? '',
        grade: data['grade'] ?? '',
        email: data['email'] ?? '',
        nmbofphone: data['phone'] ?? '',
        age: data['age'] ?? '',
        situation: data['situation'] ?? '',
        specialty: data['specialty'] ?? '',
        sex: data['sex'] ?? '',
        yearofstart: data['yearOfStart'] ?? '',
      );
    }).toList();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(children: [
                pw.Image(image, width: 100, height: 100),
                pw.SizedBox(width: 10),
                pw.Column(children: [
                  pw.Text(
                    'Democratic and Popular Republic of Algeria',
                    style: const pw.TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Ministry Of Higher Education And Scientific Research',
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'University of Ain Temouchent',
                    style: const pw.TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'BR284 RP,46000,AIN TEMOUCHENT,Algeria',
                    style: const pw.TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Tel/Fax:002134379386',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey900,
                    ),
                  ),
                  pw.UrlLink(
                    destination: 'https://www.univ-temouchent.edu.dz/',
                    child: pw.Text(
                      'https://www.univ-temouchent.edu.dz/',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.black,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ]),
              ]),
              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text(
                  namesholarship,
                  style: const pw.TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                'Proffessor List',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'The table below represents information about candidate Professors:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                tableWidth: pw.TableWidth.max,
                headers: [
                  'First Name',
                  'Last Name',
                  'Level',
                  'Email',
                  'Phone',
                  'Age',
                  'Situation',
                  'Specialty',
                ],
                data: students.map((student) {
                  return [
                    student.firstname,
                    student.lastname,
                    student.grade,
                    student.email,
                    student.nmbofphone,
                    student.age,
                    student.situation,
                    student.specialty,
                  ];
                }).toList(),
                border: pw.TableBorder.all(color: PdfColors.black),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey800,
                ),
                cellStyle: const pw.TextStyle(
                  fontSize: 10,
                ),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.centerLeft,
                  5: pw.Alignment.centerLeft,
                  6: pw.Alignment.centerLeft,
                  7: pw.Alignment.centerLeft,
                },
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> generateAndPrintPdfAdmin(String namesholarship) async {
    final pdf = pw.Document();
    final imageData = await rootBundle.load('asset/image/logo7.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());
    var studentDocs = await _firestore.collection('administrators').get();
    var students = studentDocs.docs.map((doc) {
      var data = doc.data();
      return AdminstratorsModele(
        firstname: data['firstname'] ?? '',
        lastname: data['lastname'] ?? '',
        job: data['job'] ?? '',
        email: data['email'] ?? '',
        nmbofphone: data['phone'] ?? '',
        age: data['age'] ?? '',
        situation: data['situation'] ?? '',
        specialty: data['specialty'] ?? '',
        sex: data['sex'] ?? '',
        yearofstart: data['yearOfStart'] ?? '',
      );
    }).toList();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(children: [
                pw.Image(image, width: 100, height: 100),
                pw.SizedBox(width: 10),
                pw.Column(children: [
                  pw.Text(
                    'Democratic and Popular Republic of Algeria',
                    style: const pw.TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Ministry Of Higher Education And Scientific Research',
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'University of Ain Temouchent',
                    style: const pw.TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'BR284 RP,46000,AIN TEMOUCHENT,Algeria',
                    style: const pw.TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Tel/Fax:002134379386',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey900,
                    ),
                  ),
                  pw.UrlLink(
                    destination: 'https://www.univ-temouchent.edu.dz/',
                    child: pw.Text(
                      'https://www.univ-temouchent.edu.dz/',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.black,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ]),
              ]),
              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text(
                  namesholarship,
                  style: const pw.TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                'Administrator List',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'The table below represents information about candidate Administrator:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                tableWidth: pw.TableWidth.max,
                headers: [
                  'First Name',
                  'Last Name',
                  'Level',
                  'Email',
                  'Phone',
                  'Age',
                  'Situation',
                  'Specialty',
                ],
                data: students.map((student) {
                  return [
                    student.firstname,
                    student.lastname,
                    student.job,
                    student.email,
                    student.nmbofphone,
                    student.age,
                    student.situation,
                    student.specialty,
                  ];
                }).toList(),
                border: pw.TableBorder.all(color: PdfColors.black),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey800,
                ),
                cellStyle: const pw.TextStyle(
                  fontSize: 10,
                ),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.centerLeft,
                  5: pw.Alignment.centerLeft,
                  6: pw.Alignment.centerLeft,
                  7: pw.Alignment.centerLeft,
                },
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
