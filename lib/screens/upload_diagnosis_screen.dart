import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/module/pdf_model.dart';
import 'package:fypproject/module/upload_data/post_data.dart';
import 'package:fypproject/screens/home_screen.dart';
import 'package:fypproject/screens/report_screen.dart';
import 'package:fypproject/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UploadDiagnosisScreen extends StatefulWidget {
  const UploadDiagnosisScreen({super.key});

  @override
  State<UploadDiagnosisScreen> createState() => _UploadDiagnosisScreenState();
}

class _UploadDiagnosisScreenState extends State<UploadDiagnosisScreen>
    with TickerProviderStateMixin {
  bool _isAnalyzing = false;
  bool _showResults = false;
  File? _selectImage;
  bool _isSelectImage = false;
  final ImagePicker _picker = ImagePicker();

  String generate8DigitNumber() {
    final random = Random();
    return (10000000 + random.nextInt(90000000)).toString();
  }

  Future<void> postModel(PostData postData) async {
    if (postData.image == null) return;

    setState(() {
      _isAnalyzing = true; // analysis start
    });

    try {
      Uri uri = Uri.parse(APIs.modelUrl);
      var request = http.MultipartRequest('POST', uri);

      // Attach image
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          postData.image!.path,
          filename: basename(postData.image!.path),
        ),
      );

      // Attach fields
      request.fields.addAll(postData.toFields());

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final uploadData = PdfModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(response.body)),
        );

        // ❗ purana report hatao
        HomeScreen.searchList.clear();

        // ❗ naya report add karo
        HomeScreen.searchList.add(uploadData);
        // HomeScreen.searchList?.add(uploadData);
        setState(() {
          _showResults = true; // show button visible
        });
        // Print response
        print("✅ Upload Success");
        print("Patient ID: ${uploadData.patientId}");
        print("Severity Label: ${uploadData.severity?.severityLabel}");
        print("XAI Images: ${uploadData.files?.xai}");
      } else {
        print("❌ Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠ Error occurred: $e");
    } finally {
      setState(() {
        _isAnalyzing = false; // analysis done
      });
    }
  }

  Future<void> selectImageFucntion() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _selectImage = File(image.path);
        _isSelectImage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Upload & Diagnosis',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primaryBlue,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Section
              _buildUploadSection(),
              const SizedBox(height: 20),

              // // Image Preview Section
              if (_isSelectImage) _buildImagePreviewSection(),
              if (_isSelectImage) const SizedBox(height: 20),

              // // Analysis Section
              if (_isSelectImage) _buildAnalysisSection(),
              if (_showResults) SizedBox(height: 20),

              if (_showResults)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            ReportScreen(pdfData: HomeScreen.searchList.first),
                      ),
                    );
                  },
                  icon: Icon(Icons.visibility),
                  label: Text("Show Report"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successGreen,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectImage = null;
                    _isSelectImage = false;
                    _showResults = false;
                  });

                  // ❗ old report delete
                  HomeScreen.searchList.clear();
                },
                icon: Icon(Icons.refresh),
                label: Text("New Analysis"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 64,
            color: AppColors.primaryBlue.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload X-ray Angiogram',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a high-quality X-ray angiogram image\nfor CAD analysis',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: selectImageFucntion, //  _selectImage,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Select Image'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Image',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectImage = null;
                    _isSelectImage = false;
                  });
                },
                // _resetAnalysis,
                icon: const Icon(Icons.close),
                color: AppColors.mediumGray,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectImage == null) Text("No Image Select"),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.3),
                width: 2,
              ),
              image: DecorationImage(
                image: FileImage(_selectImage!),
                fit: BoxFit.cover,
              ),
            ),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(
            //       Icons.medical_services,
            //       size: 48,
            //       color: AppColors.primaryBlue.withOpacity(0.7),
            //     ),
            //     const SizedBox(height: 8),
            //     Text(
            //       'X-ray Angiogram Preview',
            //       style: GoogleFonts.roboto(
            //         fontSize: 14,
            //         color: AppColors.mediumGray,
            //       ),
            //     ),
            //     Text(
            //       '(Sample medical image)',
            //       style: GoogleFonts.roboto(
            //         fontSize: 12,
            //         color: AppColors.mediumGray,
            //         fontStyle: FontStyle.italic,
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.psychology, size: 48, color: AppColors.primaryBlue),
          const SizedBox(height: 12),
          Text(
            'AI Analysis Ready',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start AI-powered CAD detection analysis\nusing ResNet50 and Grad-CAM',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isAnalyzing
                    ? null
                    : () {
                        final pId = generate8DigitNumber;
                        postModel(
                          PostData(
                            patientId: pId.toString(),
                            runPdf: false,
                            runXai: true,
                            scoreThr: 0.4,
                            image: _selectImage,
                          ),
                        );
                      },
                icon: const Icon(Icons.analytics),
                label: Text(_isAnalyzing ? 'Analyzing...' : 'Start Analysis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.medicalRed,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),

              if (_isAnalyzing)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),

          // ElevatedButton.icon(
          //   onPressed: () {
          //     postModel(
          //       PostData(
          //         patientId: "kashif",
          //         runPdf: false,
          //         runXai: true,
          //         scoreThr: 0.4,
          //         image: _selectImage,
          //       ),
          //     );
          //     setState(() {
          //       _selectImage = null;
          //       _isSelectImage = false;
          //     });
          //   },
          //   //  _isAnalyzing ? null : _analyzeImage,
          //   icon: const Icon(Icons.analytics),
          //   label: Text(_isAnalyzing ? 'Analyzing...' : 'Start Analysis'),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: AppColors.medicalRed,
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          // ),
        ],
      ),
    );
  }
}
