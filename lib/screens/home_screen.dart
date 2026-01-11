import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fypproject/Dialogs/dialogs.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/api/storage.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/module/pdf_model.dart';
import 'package:fypproject/screens/about_screen.dart';
import 'package:fypproject/screens/auth/login_screen.dart';
import 'package:fypproject/screens/doctor_scection.dart';
import 'package:fypproject/screens/genrate_pdf.dart';
import 'package:fypproject/screens/report_screen.dart';
import 'package:fypproject/screens/upload_diagnosis_screen.dart';
import 'package:fypproject/widgets/feature_new_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  static List<PdfModel> searchList = [];
  final user = APIs.auth.currentUser;
  // PdfModel? pdfData = PdfModel(
  //   ok: true,
  //   requestId: "baf37572",
  //   patientId: "kashif_001",
  //   scoreThr: 0.4,
  //   severity: Severity(
  //     numPreds: 1,
  //     bestScore: 0.9870097637176514,
  //     maxWidthPx: 13.370025634765625,
  //     severityLabel: "mild",
  //     note:
  //         "Pixel-based severity is an approximation (not QCA). Doctor validation required.",
  //   ),
  //   files: Files(
  //     input: "assets/input.jpeg",
  //     predictionJson: "/outputs/job_20260101_174524_baf37572/prediction.json",
  //     pdf: null,
  //     xai: [],
  //     panels: ["assets/output1.jpeg", "assets/output2.jpeg"],
  //   ),
  // );

  final GlobalKey<ScaffoldState> _openDrawer = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    np = MediaQuery.of(context).size;
    return Scaffold(
      key: _openDrawer,
      drawer: _drawerSection(context),
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          onPressed: () => _openDrawer.currentState?.openDrawer(),
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_add_outlined, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                width: np.width * .099,
                height: np.height * .099,
                imageUrl: "${APIs.auth.currentUser?.photoURL}",
                errorWidget: (context, url, error) =>
                    CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Container(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Good Morning",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Mr. ${APIs.auth.currentUser?.displayName?.split(" ").first ?? ""}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Features Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),

                    child: Text(
                      'Main Features',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: np.width * 1,
                      decoration: BoxDecoration(
                        color: Color(0xFFEAEAEA),

                        // border: Border.all(width: 1),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            FeatureNewWidgets(
                              icon: Icons.upload_file,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => UploadDiagnosisScreen(),
                                  ),
                                );
                              },
                              subtitle: "Select and analyze\nmedical images",
                              title: "Upload X-ray\nAngiogram",
                            ),
                            FeatureNewWidgets(
                              icon: Icons.assessment,

                              onTap: () {
                                if (HomeScreen.searchList.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => ReportScreen(
                                        pdfData: HomeScreen.searchList.first,
                                      ),
                                    ),
                                  );
                                } else {
                                  Dialogs.showAlert(
                                    "No analysis found",
                                    context,
                                  );
                                }

                                // if (
                                // // searchList != null &&
                                // searchList.isNotEmpty) {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (ctx) => ReportScreen(
                                //         pdfData: searchList.first,
                                //       ),
                                //     ),
                                //   );
                                // } else {
                                //   Dialogs.showAlert(
                                //     "Not Analysis X-ray",
                                //     context,
                                //   );
                                // }
                              },
                              subtitle: "Check analysis\nresults",
                              title: "View Diagnosis\nReport",
                            ),
                            FeatureNewWidgets(
                              icon: Icons.picture_as_pdf,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => GenratePdf(),
                                  ),
                                );
                              },
                              subtitle: "Export detailed\nreports",
                              title: "Save All Reports\nReport",
                            ),
                            FeatureNewWidgets(
                              icon: Icons.chat,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => DoctorSection(),
                                  ),
                                );
                              },
                              subtitle: "Help with Other Experts",
                              title: "Expert Communication",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerSection(BuildContext context) {
    return SizedBox(
      width: np.width * 0.6,
      child: Drawer(
        backgroundColor: AppColors.primaryBlue.withOpacity(0.9),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: np.height * 0.05),
              child: Align(
                alignment: AlignmentGeometry.center,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      user?.photoURL ??
                          "https://www.telegraph.co.uk/content/dam/money/2025/04/30/TELEMMGLPICT000420323875_17460181981600_trans_NvBQzQNjv4BqpVlberWd9EgFPZtcLiMQf0Rf_Wk3V23H2268P_XkPxc.jpeg?imwidth=640",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: np.height * 0.02),
            Text(
              user?.displayName ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: np.width * 0.05),
            ),

            ListTile(
              title: Text("About", style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => AboutScreen()),
                );
              },
            ),
            Container(height: 0.1, color: Colors.black),
            ListTile(
              title: Text("Logout", style: TextStyle(color: Colors.white70)),
              onTap: () async {
                GoogleSignIn.instance.signOut();
                Storage().logOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (ctx) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
            Container(height: 0.1, color: Colors.black),
            // ListView.builder(
            //   itemCount: listItemData.length,
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       onTap: ,
            //       leading: Icon(listItemData[index]["icon"]),
            //       title: Text(listItemData[index]["title"]),
            //     );
            //   },
            // ),
          ],
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
