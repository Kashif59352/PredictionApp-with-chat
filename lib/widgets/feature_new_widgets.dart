import 'package:flutter/material.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/utils/app_colors.dart';

class FeatureNewWidgets extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const FeatureNewWidgets({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    np = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: np.width * 0.95,
        height: np.height * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.secondaryBlue.withOpacity(0.6),
          // border: Border.all(width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 6,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: np.width * 0.02,
              top: np.height * 0.02 / 2,
              child: CircleAvatar(
                radius: np.height * 0.03,
                child: Icon(icon, size: np.height * 0.05),
              ),
            ),
            Positioned(
              left: np.width * 0.05,
              top: np.height * 0.03,
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: np.height * 0.03,
                ),
              ),
            ),
            Positioned(
              left: np.width * 0.05,
              top: np.height * 0.07,
              child: Text(
                subtitle,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: np.height * 0.02,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
