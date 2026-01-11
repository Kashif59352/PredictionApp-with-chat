class UploadModel {
  bool? ok;
  String? requestId;
  String? patientId;
  double? scoreThr;
  Severity? severity;
  Files? files;

  UploadModel(
      {this.ok,
      this.requestId,
      this.patientId,
      this.scoreThr,
      this.severity,
      this.files});

  UploadModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    requestId = json['request_id'];
    patientId = json['patient_id'];
    scoreThr = json['score_thr'];
    severity = json['severity'] != null
        ? new Severity.fromJson(json['severity'])
        : null;
    files = json['files'] != null ? new Files.fromJson(json['files']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    data['request_id'] = this.requestId;
    data['patient_id'] = this.patientId;
    data['score_thr'] = this.scoreThr;
    if (this.severity != null) {
      data['severity'] = this.severity!.toJson();
    }
    if (this.files != null) {
      data['files'] = this.files!.toJson();
    }
    return data;
  }
}

class Severity {
  int? numPreds;
  double? bestScore;
  double? maxWidthPx;
  String? severityLabel;
  String? note;

  Severity(
      {this.numPreds,
      this.bestScore,
      this.maxWidthPx,
      this.severityLabel,
      this.note});

  Severity.fromJson(Map<String, dynamic> json) {
    numPreds = json['num_preds'];
    bestScore = json['best_score'];
    maxWidthPx = json['max_width_px'];
    severityLabel = json['severity_label'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_preds'] = this.numPreds;
    data['best_score'] = this.bestScore;
    data['max_width_px'] = this.maxWidthPx;
    data['severity_label'] = this.severityLabel;
    data['note'] = this.note;
    return data;
  }
}

class Files {
  String? input;
  String? predictionJson;
  List<String>? panels;
  List<String>? xai;
  Null? pdf;

  Files({this.input, this.predictionJson, this.panels, this.xai, this.pdf});

  Files.fromJson(Map<String, dynamic> json) {
    input = json['input'];
    predictionJson = json['prediction_json'];
    panels = json['panels'].cast<String>();
    xai = json['xai'].cast<String>();
    pdf = json['pdf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['input'] = this.input;
    data['prediction_json'] = this.predictionJson;
    data['panels'] = this.panels;
    data['xai'] = this.xai;
    data['pdf'] = this.pdf;
    return data;
  }
}
