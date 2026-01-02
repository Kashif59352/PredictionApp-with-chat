class PdfModel {
  bool? ok;
  String? requestId;
  String? patientId;
  double? scoreThr;
  Severity? severity;
  Files? files;

  PdfModel({
    this.ok,
    this.requestId,
    this.patientId,
    this.scoreThr,
    this.severity,
    this.files,
  });

  PdfModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    requestId = json['request_id'];
    patientId = json['patient_id'];
    scoreThr = (json['score_thr'] as num?)?.toDouble();
    severity = json['severity'] != null
        ? Severity.fromJson(json['severity'])
        : null;
    files = json['files'] != null ? Files.fromJson(json['files']) : null;
  }
}

class Severity {
  int? numPreds;
  double? bestScore;
  double? maxWidthPx;
  String? severityLabel;
  String? note;

  Severity({
    this.numPreds,
    this.bestScore,
    this.maxWidthPx,
    this.severityLabel,
    this.note,
  });

  Severity.fromJson(Map<String, dynamic> json) {
    numPreds = json['num_preds'];
    bestScore = (json['best_score'] as num?)?.toDouble();
    maxWidthPx = (json['max_width_px'] as num?)?.toDouble();
    severityLabel = json['severity_label'];
    note = json['note'];
  }
}

class Files {
  String? input;
  String? predictionJson;
  List<String>? panels;
  List<dynamic>? xai;
  String? pdf;

  Files({this.input, this.predictionJson, this.panels, this.xai, this.pdf});

  Files.fromJson(Map<String, dynamic> json) {
    input = json['input'];
    predictionJson = json['prediction_json'];
    panels = json['panels'] != null ? List<String>.from(json['panels']) : [];
    xai = json['xai'] != null ? List<dynamic>.from(json['xai']) : [];
    pdf = json['pdf'];
  }
}
