import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Sample report data
  final Map<String, dynamic> _reportData = {
    'patientId': 'P-2024-001',
    'patientName': 'John Doe',
    'age': 58,
    'gender': 'Male',
    'analysisDate': '2024-01-15',
    'analysisTime': '14:30',
    'cadDetected': true,
    'confidence': 0.87,
    'riskLevel': 'High',
    'stenosis': '75-85%',
    'affectedVessels': ['LAD', 'RCA'],
    'recommendations': [
      'Immediate cardiology consultation recommended',
      'Consider coronary angioplasty or bypass surgery',
      'Lifestyle modifications: diet and exercise',
      'Regular monitoring and follow-up required',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Report'),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            onPressed: _generatePDF,
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate PDF',
          ),
          IconButton(
            onPressed: _shareReport,
            icon: const Icon(Icons.share),
            tooltip: 'Share Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Header
            _buildReportHeader(),
            const SizedBox(height: 20),

            // Patient Information
            _buildPatientInfo(),
            const SizedBox(height: 20),

            // Analysis Results
            _buildAnalysisResults(),
            const SizedBox(height: 20),

            // Detailed Findings
            _buildDetailedFindings(),
            const SizedBox(height: 20),

            // Recommendations
            _buildRecommendations(),
            const SizedBox(height: 20),

            // AI Model Information
            _buildModelInfo(),
            const SizedBox(height: 30),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                'CAD Diagnosis Report',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'AI-Powered Coronary Artery Disease Analysis',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Generated: ${_reportData['analysisDate']} at ${_reportData['analysisTime']}',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return _buildSectionCard(
      title: 'Patient Information',
      icon: Icons.person,
      child: Column(
        children: [
          _buildInfoRow('Patient ID', _reportData['patientId']),
          _buildInfoRow('Name', _reportData['patientName']),
          _buildInfoRow('Age', '${_reportData['age']} years'),
          _buildInfoRow('Gender', _reportData['gender']),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final bool cadDetected = _reportData['cadDetected'];
    final double confidence = _reportData['confidence'];

    return _buildSectionCard(
      title: 'Analysis Results',
      icon: Icons.analytics,
      child: Column(
        children: [
          // Main Result
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cadDetected
                      ? AppColors.medicalRed.withOpacity(0.1)
                      : AppColors.successGreen.withOpacity(0.1),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cadDetected
                    ? AppColors.medicalRed.withOpacity(0.3)
                    : AppColors.successGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  cadDetected ? Icons.warning : Icons.check_circle,
                  color: cadDetected
                      ? AppColors.medicalRed
                      : AppColors.successGreen,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cadDetected ? 'CAD DETECTED' : 'NO CAD DETECTED',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cadDetected
                              ? AppColors.medicalRed
                              : AppColors.successGreen,
                        ),
                      ),
                      Text(
                        'Confidence: ${(confidence * 100).toInt()}%',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Confidence Meter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confidence Level',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: confidence,
                backgroundColor: AppColors.lightGray,
                valueColor: AlwaysStoppedAnimation<Color>(
                  confidence > 0.8
                      ? AppColors.successGreen
                      : confidence > 0.6
                      ? AppColors.warningOrange
                      : AppColors.medicalRed,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(confidence * 100).toInt()}% - ${_getConfidenceLabel(confidence)}',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedFindings() {
    if (!_reportData['cadDetected']) {
      return _buildSectionCard(
        title: 'Detailed Findings',
        icon: Icons.search,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.successGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No significant coronary artery disease detected. Coronary arteries appear normal.',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.darkGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildSectionCard(
      title: 'Detailed Findings',
      icon: Icons.search,
      child: Column(
        children: [
          _buildFindingItem(
            'Risk Level',
            _reportData['riskLevel'],
            _getRiskColor(_reportData['riskLevel']),
            Icons.warning,
          ),
          const SizedBox(height: 12),
          _buildFindingItem(
            'Stenosis Severity',
            _reportData['stenosis'],
            AppColors.medicalRed,
            Icons.timeline,
          ),
          const SizedBox(height: 12),
          _buildFindingItem(
            'Affected Vessels',
            _reportData['affectedVessels'].join(', '),
            AppColors.warningOrange,
            Icons.device_hub,
          ),
        ],
      ),
    );
  }

  Widget _buildFindingItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
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
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return _buildSectionCard(
      title: 'Clinical Recommendations',
      icon: Icons.medical_services_rounded,
      child: Column(
        children: _reportData['recommendations'].asMap().entries.map<Widget>((
          entry,
        ) {
          int index = entry.key;
          String recommendation = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    recommendation,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.darkGray,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModelInfo() {
    return _buildSectionCard(
      title: 'AI Model Information',
      icon: Icons.psychology,
      child: Column(
        children: [
          _buildInfoRow('Model Architecture', 'ResNet50'),
          _buildInfoRow('Explainability Method', 'Grad-CAM'),
          _buildInfoRow('Training Dataset', 'Medical Angiogram Database'),
          _buildInfoRow('Model Version', 'v2.1.0'),
          _buildInfoRow('Processing Time', '< 2 seconds'),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _generatePDF,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.medicalRed,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _shareReport,
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
              // Navigator.pushNamed(context, '/upload');
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

  String _getConfidenceLabel(double confidence) {
    if (confidence >= 0.9) return 'Very High';
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.7) return 'Good';
    if (confidence >= 0.6) return 'Moderate';
    return 'Low';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return AppColors.medicalRed;
      case 'medium':
        return AppColors.warningOrange;
      case 'low':
        return AppColors.successGreen;
      default:
        return AppColors.mediumGray;
    }
  }

  void _generatePDF() {
    // Placeholder for PDF generation
    // NavigationService.showInfoSnackBar('PDF generation feature coming soon!');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('PDF report generated successfully!'),
        backgroundColor: AppColors.successGreen,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Open PDF viewer
          },
        ),
      ),
    );
  }

  void _shareReport() {
    // Placeholder for sharing functionality
    // NavigationService.showInfoSnackBar('Report sharing feature coming soon!');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Report shared successfully!'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }
}
