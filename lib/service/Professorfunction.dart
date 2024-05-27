import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:uniwayapp/Model/professormodel.dart';

class ProfService {
  Future<void> generateAndPrintPdf(
      ProfessorModel prof, String namesholarship) async {
    final pdf = pw.Document();
    final imageData = await rootBundle.load('asset/image/logo7.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());
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
                'The following student applied for the scholarship:',
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Following evoluation(in accordance with the criteria mutually agreed upon with the host university) we have decided upon nomination of the following applicant:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  _buildTableRow('First Name', prof.firstname),
                  _buildTableRow('Last Name', prof.lastname),
                  _buildTableRow('Level', prof.grade),
                  _buildTableRow('Email', prof.email),
                  _buildTableRow('Specialty', prof.specialty),
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

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.TableRow _buildTableRow(String key, String value) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            key,
            style: const pw.TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 13,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
