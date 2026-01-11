import 'dart:io';

class PostData {
  File? image;
  String? patientId;
  bool? runXai;
  bool? runPdf;
  double? scoreThr;

  PostData({
    required this.image,
    required this.patientId,
    required this.runXai,
    required this.runPdf,
    required this.scoreThr,
  });

  /// Convert model to Map (for multipart fields except file)
  Map<String, String> toFields() {
    return {
      "patient_id": patientId!,
      "run_xai": runXai.toString(), // "true" / "false"
      "run_pdf": runPdf.toString(), // "true" / "false"
      "score_thr": scoreThr.toString(),
    };
  }
}
