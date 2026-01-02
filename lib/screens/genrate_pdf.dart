// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fypproject/screens/view_screen/pdf_view_screen.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:printing/printing.dart'; // PDF open karne ke liye

// class GenratePdf extends StatefulWidget {
//   const GenratePdf({super.key});

//   @override
//   State<GenratePdf> createState() => _SavedPdfScreenState();
// }

// class _SavedPdfScreenState extends State<GenratePdf> {
//   List<File> pdfFiles = [];

//   @override
//   void initState() {
//     super.initState();
//     loadSavedPdfs();
//   }

//   Future<void> loadSavedPdfs() async {
//     final directory = await getExternalStorageDirectory();
//     final files = directory!.listSync();

//     final pdfs = files
//         .whereType<File>()
//         .where((f) => f.path.endsWith(".pdf"))
//         .toList();

//     // Sort by latest saved first
//     pdfs.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

//     setState(() {
//       pdfFiles = pdfs;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Saved PDF Reports")),
//       body: pdfFiles.isEmpty
//           ? const Center(child: Text("No saved PDFs found."))
//           : ListView.builder(
//               itemCount: pdfFiles.length,
//               itemBuilder: (context, index) {
//                 final file = pdfFiles[index];
//                 final fileName = file.path.split("/").last;
//                 return GestureDetector(
//                   onLongPress: () async {
//                     await sharePdf();
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     child: ListTile(
//                       leading: const Icon(
//                         Icons.picture_as_pdf,
//                         color: Colors.red,
//                       ),
//                       title: Text(fileName),
//                       subtitle: Text(
//                         "Size: ${(file.lengthSync() / 1024).toStringAsFixed(2)} KB",
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.open_in_new),
//                         onPressed: () {
//                           OpenFile.open(file.path); // PDF open
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.refresh),
//         onPressed: () {
//           loadSavedPdfs(); // Refresh list
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart' show XFile, Share;

class GenratePdf extends StatefulWidget {
  const GenratePdf({super.key});

  @override
  State<GenratePdf> createState() => _SavedPdfScreenState();
}

class _SavedPdfScreenState extends State<GenratePdf> {
  List<File> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    loadSavedPdfs();
  }

  // Load all PDF files from app directory
  Future<void> loadSavedPdfs() async {
    final directory = await getExternalStorageDirectory();
    final files = directory!.listSync();

    final pdfs = files
        .whereType<File>()
        .where((f) => f.path.endsWith(".pdf"))
        .toList();

    // Sort by latest saved first
    pdfs.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    setState(() {
      pdfFiles = pdfs;
    });
  }

  // Share a PDF file
  Future<void> sharePdf(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: "Here is your PDF report");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved PDF Reports")),
      body: pdfFiles.isEmpty
          ? const Center(child: Text("No saved PDFs found."))
          : ListView.builder(
              itemCount: pdfFiles.length,
              itemBuilder: (context, index) {
                final file = pdfFiles[index];
                final fileName = file.path.split("/").last;

                return GestureDetector(
                  onLongPress: () async {
                    // Share PDF
                    await sharePdf(file.path);
                  },
                  onTap: () {
                    // Open PDF inside the app
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PdfViewScreen(filePath: file.path),
                    //   ),
                    // );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),
                      title: Text(fileName),
                      subtitle: Text(
                        "Size: ${(file.lengthSync() / 1024).toStringAsFixed(2)} KB",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () {
                          // Open with external app as fallback
                          OpenFile.open(file.path);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          loadSavedPdfs(); // Refresh the list
        },
      ),
    );
  }
}
