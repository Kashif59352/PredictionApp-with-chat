import 'dart:io';

class UploadModel {
  String? title;
  String? description;
  File? image;
  String? imageUrl;

  UploadModel({this.imageUrl, this.title, this.description, this.image});

  factory UploadModel.fromJson(Map<String, dynamic> json) {
    String? url = json['imageUrl'];

    if (url != null && url.contains("localhost")) {
      url = url.replaceFirst(
        "http://localhost:3000",
        "http://192.168.0.106:3000",
      );
    }

    return UploadModel(
      title: json['title'],
      description: json['description'],
      imageUrl: url,
    );
  }

  // JSON me convert karna (sirf title & description ke liye)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      // Image file ko backend me multipart/form-data ke through send karenge, isliye yahan null
    };
  }
}
