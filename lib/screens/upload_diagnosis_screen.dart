import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class UploadDiagnosisScreen extends StatefulWidget {
  const UploadDiagnosisScreen({super.key});

  @override
  State<UploadDiagnosisScreen> createState() => _UploadDiagnosisScreenState();
}

class _UploadDiagnosisScreenState extends State<UploadDiagnosisScreen>
    with TickerProviderStateMixin {
  bool _isImageSelected = false;
  bool _isAnalyzing = false;
  bool _showResults = false;
  String? _selectedImagePath;
  late AnimationController _progressController;
  late AnimationController _resultController;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;

  // Dummy diagnosis results
  final Map<String, dynamic> _diagnosisResults = {
    'cadDetected': true,
    'confidence': 0.87,
    'riskLevel': 'High',
    'affectedVessels': ['LAD', 'RCA'],
    'stenosis': '75-85%',
  };

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _selectImage() {
    setState(() {
      _isImageSelected = true;
      _selectedImagePath = 'assets/images/sample_angiogram.jpg';
    });
  }

  void _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
      _showResults = false;
    });

    _progressController.forward();

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isAnalyzing = false;
      _showResults = true;
    });

    _resultController.forward();
  }

  void _resetAnalysis() {
    setState(() {
      _isImageSelected = false;
      _isAnalyzing = false;
      _showResults = false;
      _selectedImagePath = null;
    });
    _progressController.reset();
    _resultController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload & Diagnosis'),
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

            // Image Preview Section
            if (_isImageSelected) _buildImagePreviewSection(),
            if (_isImageSelected) const SizedBox(height: 20),

            // Analysis Section
            if (_isImageSelected) _buildAnalysisSection(),
            if (_isAnalyzing) const SizedBox(height: 20),

            // Progress Section
            if (_isAnalyzing) _buildProgressSection(),
            if (_showResults) const SizedBox(height: 20),

            // Results Section
            if (_showResults) _buildResultsSection(),
          ],
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
            onPressed: _selectImage,
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
                onPressed: _resetAnalysis,
                icon: const Icon(Icons.close),
                color: AppColors.mediumGray,
              ),
            ],
          ),
          const SizedBox(height: 12),
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
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_services,
                  size: 48,
                  color: AppColors.primaryBlue.withOpacity(0.7),
                ),
                const SizedBox(height: 8),
                Text(
                  'X-ray Angiogram Preview',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.mediumGray,
                  ),
                ),
                Text(
                  '(Sample medical image)',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
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
          ElevatedButton.icon(
            onPressed: _isAnalyzing ? null : _analyzeImage,
            icon: const Icon(Icons.analytics),
            label: Text(_isAnalyzing ? 'Analyzing...' : 'Start Analysis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.medicalRed,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
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
          Text(
            'AI Analysis in Progress',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: AppColors.lightGray,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(_progressAnimation.value * 100).toInt()}% Complete',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Processing with ResNet50 neural network...',
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: AppColors.mediumGray,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            children: [
              // Main Result Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _diagnosisResults['cadDetected']
                          ? AppColors.medicalRed.withOpacity(0.1)
                          : AppColors.successGreen.withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _diagnosisResults['cadDetected']
                        ? AppColors.medicalRed.withOpacity(0.3)
                        : AppColors.successGreen.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _diagnosisResults['cadDetected']
                          ? Icons.warning_amber
                          : Icons.check_circle,
                      size: 48,
                      color: _diagnosisResults['cadDetected']
                          ? AppColors.medicalRed
                          : AppColors.successGreen,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _diagnosisResults['cadDetected']
                          ? 'CAD Detected'
                          : 'No CAD Detected',
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _diagnosisResults['cadDetected']
                            ? AppColors.medicalRed
                            : AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${(_diagnosisResults['confidence'] * 100).toInt()}%',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Detailed Results
              if (_diagnosisResults['cadDetected']) _buildDetailedResults(),
              const SizedBox(height: 16),

              // Grad-CAM Visualization Placeholder
              _buildGradCAMSection(),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // NavigationService.navigateT  o('/report');
                      },
                      icon: const Icon(Icons.description),
                      label: const Text('View Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _resetAnalysis,
                      icon: const Icon(Icons.refresh),
                      label: const Text('New Analysis'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mediumGray,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailedResults() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Analysis',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          _buildResultRow('Risk Level', _diagnosisResults['riskLevel']),
          _buildResultRow('Stenosis', _diagnosisResults['stenosis']),
          _buildResultRow(
            'Affected Vessels',
            _diagnosisResults['affectedVessels'].join(', '),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.mediumGray,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradCAMSection() {
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
          Text(
            'Grad-CAM Heatmap Visualization',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.medicalRed.withOpacity(0.1),
                  AppColors.warningOrange.withOpacity(0.1),
                  AppColors.lightGray,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGray, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility, size: 32, color: AppColors.mediumGray),
                const SizedBox(height: 8),
                Text(
                  'Explainability Heatmap',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mediumGray,
                  ),
                ),
                Text(
                  'Shows AI focus areas',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
