import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SavePdfData {
  static Future<String> savePdfToStorage(
    Uint8List pdfBytes,
    String fileName,
  ) async {
    // Permission request (Android < 11)
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Storage permission denied");
      }
    }

    // App specific directory (SAFE)
    final directory = await getExternalStorageDirectory();

    // Ensure .pdf extension
    final filePath = "${directory!.path}/$fileName.pdf";

    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    print("PDF saved at: $filePath");
    return filePath; // return path so we can refresh list
  }
}
