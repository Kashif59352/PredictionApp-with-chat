import 'package:flutter/material.dart';
import 'package:fypproject/screens/doctor_scection.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAD Diagnosis Assistant'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue.withOpacity(0.1),
              AppColors.backgroundWhite,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Container(
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
                          const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Welcome Doctor',
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
                        'AI-powered system for accurate CAD diagnosis using X-ray angiograms',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Features Section
                Text(
                  'Main Features',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 20),

                // Feature Cards Grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      FeatureCard(
                        icon: Icons.upload_file,
                        title: 'Upload X-ray\nAngiogram',
                        subtitle: 'Select and analyze\nmedical images',
                        color: AppColors.primaryBlue,
                        onTap: () {},
                        // => NavigationService.navigateTo('/upload'),
                      ),
                      FeatureCard(
                        icon: Icons.assessment,
                        title: 'View Diagnosis\nReport',
                        subtitle: 'Check analysis\nresults',
                        color: AppColors.medicalRed,
                        onTap: () {},
                        // => NavigationService.navigateTo('/report'),
                      ),
                      FeatureCard(
                        icon: Icons.picture_as_pdf,
                        title: 'Generate PDF\nReport',
                        subtitle: 'Export detailed\nreports',
                        color: AppColors.successGreen,
                        onTap: () {},
                       
                      ),
                      FeatureCard(
                        icon: Icons.info_outline,
                        title: 'All Doctors',
                        subtitle: 'Reference Section',
                        color: AppColors.warningOrange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => DoctorSection(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Quick Stats Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Accuracy', '95.2%', Icons.check_circle),
                      _buildStatItem('Speed', '<2s', Icons.speed),
                      _buildStatItem('Offline', 'Ready', Icons.offline_bolt),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 12, color: AppColors.mediumGray),
        ),
      ],
    );
  }
}
