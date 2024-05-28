import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:uniwayapp/Model/professormodel.dart';

class ProfServiceList {
  Future<void> generateAndPrintPdf(
      List<ProfessorModel> students, String scholar) async {
    final pdf = pw.Document();
    final imageData = await rootBundle.load('asset/image/logo7.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    // Group students by status
    Map<String, List<ProfessorModel>> studentsByStatus = {
      'Accept': [],
      'Attend': [],
      'Reject': [],
    };

    for (var student in students) {
      studentsByStatus[student.status ?? 'Reject']!.add(student);
    }

    // Generate tables for each status
    for (var status in studentsByStatus.keys) {
      if (studentsByStatus[status]!.isEmpty) continue;

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
                    status,
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  'The following students applied with this status:',
                  style: const pw.TextStyle(
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    _buildTableHeader(),
                    ...studentsByStatus[status]!.map((student) {
                      return _buildTableRow(student);
                    }),
                  ],
                ),
                pw.SizedBox(height: 50),
                pw.Text('President:', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Dr Mohamed FLITTI',
                    style: const pw.TextStyle(fontSize: 8)),
              ],
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.TableRow _buildTableHeader() {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            'First Name',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            'Last Name',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            'Grade',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            'Email',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            'Specialty',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  pw.TableRow _buildTableRow(ProfessorModel student) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            student.firstname ?? '',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            student.lastname ?? '',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            student.grade ?? '',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            student.email ?? '',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            student.specialty ?? '',
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
