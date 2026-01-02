import 'package:flutter/material.dart';
import 'package:fypproject/api/save_pdf_data.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/module/pdf_model.dart';
import 'package:fypproject/screens/genrate_pdf.dart';
import 'package:fypproject/screens/upload_diagnosis_screen.dart';
import 'package:fypproject/utils/app_colors.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

class ReportScreen extends StatefulWidget {
  final PdfModel pdfData;

  const ReportScreen({super.key, required this.pdfData});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>> conditionData = [
    {
      "severe": Text(
        ' AI analysis indicates a severe stenotic region with significant vessel'
        'narrowing.This case is marked as high priority and requires immediate'
        'clinical review.The result is AI-assisted and should be confirmed by a '
        'cardiologist using standard diagnostic procedures.',
      ),
    },
    {
      "moderate": Text(
        'AI analysis suggests a moderate level of coronary stenosis.Clinical correlation'
        'and further diagnostic evaluation are recommended. This AI-based assessment is '
        'intended to support, not replace, expert medical judgment.',
      ),
    },
    {
      "mild": Text(
        'AI analysis indicates mild or no significant coronary stenosis. No urgent intervention'
        'is suggested based on this automated assessment. Final interpretation should be performed'
        ' by a qualified medical professional.',
      ),
    },
  ];

  pw.ImageProvider? urlImage;
  bool isLoad = false;
  String url =
      "https://expertcardiologist.co.uk/wp-content/uploads/bb-plugin/cache/adobestock_416300963-circle-9251c52126b153d9e9f61595d08102db-1e6rowas79bq.webp";
  @override
  void initState() {
    super.initState();
    loadImage(url);
  }

  Future<void> loadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    urlImage = pw.MemoryImage(response.bodyBytes);
  }

  Future<pw.ImageProvider> loadAssetImage(String path) async {
    final data = await rootBundle.load(path);
    return pw.MemoryImage(data.buffer.asUint8List());
  }

  Future<void> sharePdf() async {
    final pdfBytes = await generateReportPdf();

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'CAD_Report_${widget.pdfData.patientId}.pdf',
    );
  }

  void showPdf() async {
    final bytes = await generateReportPdf();
    Printing.layoutPdf(onLayout: (format) async => bytes);
  }

  Future<Uint8List> generateReportPdf(
    //   {
    //   required String paitentId,
    //   required String responseId,
    //   required String dateAndTime,
    //   required String modelVersion,
    //   required String scoreTherishold,
    // }
  ) async {
    final pdf = pw.Document();
    final headerImage = await loadAssetImage("assets/Report_header.png");
    final inPutImage = await loadAssetImage("assets/input.jpeg");
    final outPutImage1 = await loadAssetImage("assets/output1.jpeg");
    final outPutImage2 = await loadAssetImage("assets/output2.jpeg");
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 20),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// HEADER
              pw.Container(
                height: 80,
                // color: PdfColors.blue100,
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: headerImage,
                    fit: pw.BoxFit.fill,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),

              reportDetailsHeaderPDF("Report Details"),
              pw.SizedBox(height: 5),

              /// GRADING SECTION
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'Patient ID: \n'
                      'Request ID: \n'
                      'Date & Time: \n'
                      'Model Version: \n'
                      'Score Threshold: \n',
                    ),
                  ),
                  // changing this section
                  pw.Expanded(
                    child: pw.Text(
                      'Distinction\n'
                      'Merit\n'
                      'Pass\n'
                      'Narrow Fail\n'
                      'Fail',
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              reportDetailsHeaderPDF("Section: Input Angiogram"),
              pw.SizedBox(height: 5),

              // pw.Text('Pass With Merit'),
              pw.Container(
                // width: 400,
                height: 100,
                width: 200,
                decoration: pw.BoxDecoration(
                  // border: pw.Border.all(width: 2),
                  image: pw.DecorationImage(
                    image: inPutImage,
                    fit: pw.BoxFit.fill,
                  ),
                ),
              ),

              pw.SizedBox(height: 10),
              reportDetailsHeaderPDF("Section: AI Prediction Overlay"),

              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      // width: 400,
                      height: 100,
                      decoration: pw.BoxDecoration(
                        // border: pw.Border.all(width: 2),
                        image: pw.DecorationImage(
                          image: outPutImage1,
                          fit: pw.BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Expanded(
                    child: pw.Container(
                      // width: 400,
                      height: 100,
                      decoration: pw.BoxDecoration(
                        // border: pw.Border.all(width: 2),
                        image: pw.DecorationImage(
                          image: outPutImage2,
                          fit: pw.BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),
              reportDetailsHeaderPDF(
                "Section: Explainable AI  Occlusion Sensitivity",
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                'Explanation text (important):',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'The occlusion heatmap illustrates image regions that most influenced the model prediction./n'
                'Warmer colors indicate higher contribution to the final decision.',
              ),
              pw.SizedBox(height: 10),
              reportDetailsHeaderPDF(
                "Section: Severity Estimation (Pixel-Based)",
              ),

              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'Parameter',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      'Value',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'Number of detected regions\n'
                      'Highest confidence score\n'
                      'Maximum estimated width (pixels)\n'
                      'Severity Category',
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      '1\n'
                      '0.987\n'
                      '13.37px\n'
                      'Sever',
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),

              pw.Container(
                height: 90,
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  // border: pw.Border.all(width: 2),
                  gradient: pw.RadialGradient(
                    colors: [PdfColors.blue200, PdfColors.blue100],
                  ),
                ),
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Disclaimer & Clinical Note',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(height: 5),

                      pw.Text(
                        'This is NOT Quantitative Coronary Angiography (QCA)',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 2),

                      pw.Text(
                        'Results should NOT be used as a sole diagnostic decision',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 2),

                      pw.Text(
                        'Clinical validation by a qualified cardiologist is required',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    np = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Report'),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            onPressed: () {},
            //  _generatePDF,
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate PDF',
          ),
          IconButton(
            onPressed: () {},
            //  _shareReport,
            icon: const Icon(Icons.share),
            tooltip: 'Share Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            reportDetailsHeader("Report Details"),
            SizedBox(height: 5),

            /// GRADING SECTION
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Patient ID: \n'
                    'Request ID: \n'
                    'Date & Time: \n'
                    'Model Version: \n'
                    'Score Threshold: \n',
                  ),
                ),
                // changing this section
                Expanded(
                  child: Text(
                    '${widget.pdfData.patientId}\n'
                    '${widget.pdfData.requestId}\n'
                    '10-12-2026\n'
                    'Narrow Fail\n'
                    '${widget.pdfData.scoreThr}',
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            reportDetailsHeader("Section: Input Angiogram"),
            SizedBox(height: 5),

            // Text('Pass With Merit'),
            Container(
              // width: 400,
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                // After Add
                image: DecorationImage(
                  image: AssetImage("${widget.pdfData.files!.input}"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(height: 10),
            reportDetailsHeader("Section: AI Prediction Overlay"),

            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      // After add
                      image: DecorationImage(
                        image: AssetImage(
                          widget.pdfData.files!.panels!.elementAt(0),
                        ),
                        // outPutImage1,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    // width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      // after Add
                      image: DecorationImage(
                        image: AssetImage(
                          widget.pdfData.files!.panels!.elementAt(1),
                        ),
                        // outPutImage2,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            reportDetailsHeader(
              "Section: Explainable AI  Occlusion Sensitivity",
            ),

            SizedBox(height: 10),
            Text(
              'Explanation text (important):',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            if (widget.pdfData.severity!.severityLabel == "severe")
              conditionData[0]["severe"],
            if (widget.pdfData.severity!.severityLabel == "moderate")
              conditionData[1]["moderate"],
            if (widget.pdfData.severity!.severityLabel == "mild")
              conditionData[2]["mild"],
            SizedBox(height: 10),
            reportDetailsHeader("Section: Severity Estimation (Pixel-Based)"),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Parameter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Value',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Number Predict\n'
                    'Highest confidence score\n'
                    'Maximum estimated width (pixels)\n'
                    'Severity Category',
                  ),
                ),
                Expanded(
                  child: Text(
                    '${widget.pdfData.severity!.numPreds}\n'
                    '${widget.pdfData.severity!.bestScore!.toStringAsFixed(2)}\n'
                    '${widget.pdfData.severity!.maxWidthPx!.toStringAsFixed(2)}\n'
                    '${widget.pdfData.severity!.severityLabel}',
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: np.height * .15,
              width: double.infinity,
              decoration: BoxDecoration(
                // border: Border.all(width: 2),
                gradient: RadialGradient(
                  colors: [Colors.blue.shade200, Colors.blue.shade100],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disclaimer & Clinical Note',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),

                    Text(
                      'This is NOT Quantitative Coronary Angiography (QCA)',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 2),

                    Text(
                      'Results should NOT be used as a sole diagnostic decision',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 2),

                    Text(
                      'Clinical validation by a qualified cardiologist is required',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // report header
  Widget reportDetailsHeader(String title) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade200,
            Colors.blue.shade300,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title text
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saving PDF...")),
                  );

                  final pdfBytes = await generateReportPdf();
                  final filePath = await SavePdfData.savePdfToStorage(
                    pdfBytes,
                    "CAD_REPORT_${widget.pdfData.patientId}",
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("PDF saved at $filePath")),
                  );

                  // Navigate to saved PDFs screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GenratePdf()),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Save PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              // ElevatedButton.icon(
              //   onPressed: () async {
              //     ScaffoldMessenger.of(
              //       context,
              //     ).showSnackBar(SnackBar(content: Text("Save Pdf")));
              //     // showPdf();
              //     final pdfBytes = await generateReportPdf();
              //     await SavePdfData.savePdfToStorage(
              //       pdfBytes,
              //       "CAD_REPORT_${widget.pdfData.patientId}",
              //     );
              //   },

              //   icon: const Icon(Icons.picture_as_pdf),
              //   label: const Text('Save PDF'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppColors.medicalRed,
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //   ),
              // ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await sharePdf();
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (ctx) => UploadDiagnosisScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('New Analysis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // report header
  pw.Widget reportDetailsHeaderPDF(String title) {
    return pw.Container(
      height: 25,
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [PdfColors.blue800, PdfColors.blue500, PdfColors.blue300],
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
        ),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Title text
          pw.Text(
            title,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
