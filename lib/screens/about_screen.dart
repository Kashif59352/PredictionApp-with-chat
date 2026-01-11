import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Project'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            _buildProjectHeader(),
            const SizedBox(height: 20),
            
            // Project Overview
            _buildProjectOverview(),
            const SizedBox(height: 20),
            
            // Key Features
            _buildKeyFeatures(),
            const SizedBox(height: 20),
            
            // Technology Stack
            _buildTechnologyStack(),
            const SizedBox(height: 20),
            
            // AI Model Details
            _buildAIModelDetails(),
            const SizedBox(height: 20),
            
            // Benefits
            _buildBenefits(),
            const SizedBox(height: 20),
            
            // Developer Info
            _buildDeveloperInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CAD Diagnosis Assistant',
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Final Year Project',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'AI-powered system for diagnosing Coronary Artery Disease (CAD) using X-ray angiograms with advanced machine learning techniques.',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectOverview() {
    return _buildSectionCard(
      title: 'Project Overview',
      icon: Icons.info_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coronary Artery Disease (CAD) is one of the leading causes of death worldwide. Early and accurate diagnosis is crucial for effective treatment and patient outcomes.',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.darkGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This project leverages artificial intelligence to assist medical professionals in diagnosing CAD from X-ray angiogram images, providing:',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: AppColors.darkGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('Automated CAD detection with high accuracy'),
          _buildBulletPoint('Region-specific analysis of coronary arteries'),
          _buildBulletPoint('Explainable AI using Grad-CAM visualization'),
          _buildBulletPoint('Offline processing for data privacy'),
          _buildBulletPoint('Fast diagnosis results in under 2 seconds'),
        ],
      ),
    );
  }

  Widget _buildKeyFeatures() {
    return _buildSectionCard(
      title: 'Key Features',
      icon: Icons.star,
      child: Column(
        children: [
          _buildFeatureItem(
            Icons.upload_file,
            'Image Upload & Processing',
            'Easy upload of X-ray angiogram images with automatic preprocessing',
            AppColors.primaryBlue,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.psychology,
            'AI-Powered Analysis',
            'Advanced ResNet50 neural network for accurate CAD detection',
            AppColors.medicalRed,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.visibility,
            'Explainable Results',
            'Grad-CAM heatmaps show AI decision-making process',
            AppColors.successGreen,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.description,
            'Comprehensive Reports',
            'Detailed medical reports with PDF export functionality',
            AppColors.warningOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildTechnologyStack() {
    return _buildSectionCard(
      title: 'Technology Stack',
      icon: Icons.code,
      child: Column(
        children: [
          _buildTechItem('Mobile Framework', 'Flutter', Icons.phone_android),
          _buildTechItem('AI Framework', 'TensorFlow Lite', Icons.memory),
          _buildTechItem('Neural Network', 'ResNet50', Icons.device_hub),
          _buildTechItem('Explainability', 'Grad-CAM', Icons.visibility),
          _buildTechItem('Image Processing', 'OpenCV', Icons.image),
          _buildTechItem('Report Generation', 'PDF Library', Icons.picture_as_pdf),
        ],
      ),
    );
  }

  Widget _buildAIModelDetails() {
    return _buildSectionCard(
      title: 'AI Model Details',
      icon: Icons.smart_toy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModelDetailItem(
            'Architecture',
            'ResNet50 (Residual Neural Network)',
            'Deep convolutional neural network with 50 layers, optimized for medical image analysis',
          ),
          const SizedBox(height: 16),
          _buildModelDetailItem(
            'Training Data',
            'Medical Angiogram Dataset',
            'Trained on thousands of annotated X-ray angiogram images from medical databases',
          ),
          const SizedBox(height: 16),
          _buildModelDetailItem(
            'Accuracy',
            '95.2% Validation Accuracy',
            'Achieved high accuracy on test dataset with low false positive/negative rates',
          ),
          const SizedBox(height: 16),
          _buildModelDetailItem(
            'Explainability',
            'Gradient-weighted Class Activation Mapping',
            'Grad-CAM provides visual explanations showing which regions influenced the diagnosis',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    return _buildSectionCard(
      title: 'Clinical Benefits',
      icon: Icons.local_hospital,
      child: Column(
        children: [
          _buildBenefitItem(
            Icons.speed,
            'Fast Diagnosis',
            'Results in under 2 seconds',
            AppColors.successGreen,
          ),
          const SizedBox(height: 12),
          _buildBenefitItem(
            Icons.verified,
            'High Accuracy',
            '95.2% diagnostic accuracy',
            AppColors.primaryBlue,
          ),
          const SizedBox(height: 12),
          _buildBenefitItem(
            Icons.offline_bolt,
            'Offline Processing',
            'No internet required for analysis',
            AppColors.warningOrange,
          ),
          const SizedBox(height: 12),
          _buildBenefitItem(
            Icons.security,
            'Data Privacy',
            'Patient data stays on device',
            AppColors.medicalRed,
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfo() {
    return _buildSectionCard(
      title: 'Developer Information',
      icon: Icons.person,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryBlue.withOpacity(0.1),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryBlue,
                      child: Text(
                        'FYP',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Final Year Project',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray,
                            ),
                          ),
                          Text(
                            'Computer Science Department',
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
                const SizedBox(height: 16),
                Text(
                  'This application is developed as part of a Final Year Project focusing on the application of artificial intelligence in medical diagnosis, specifically for Coronary Artery Disease detection.',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: AppColors.darkGray,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 16,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Academic Year 2024',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              Icon(
                icon,
                color: AppColors.primaryBlue,
                size: 24,
              ),
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
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
  }

  Widget _buildFeatureItem(IconData icon, String title, String description, Color color) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechItem(String category, String technology, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
            ),
          ),
          Text(
            technology,
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

  Widget _buildModelDetailItem(String title, String subtitle, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: GoogleFonts.roboto(
            fontSize: 13,
            color: AppColors.mediumGray,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                Text(
                  description,
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