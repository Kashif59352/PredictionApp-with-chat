import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fypproject/Dialogs/dialogs.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/api/storage.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/screens/auth/signup_screen.dart';
import 'package:fypproject/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isShowPassword = true;

  loginWithemailAndPassword() async {
    try {
      UserCredential userCredential = await APIs.auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // ✅ If we reach here, user EXISTS and is authenticated
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Dialogs.showAlert("No account found with this email", context);
      } else if (e.code == 'wrong-password') {
        Dialogs.showAlert("Incorrect password", context);
      } else if (e.code == 'invalid-email') {
        Dialogs.showAlert("Invalid email format", context);
      } else {
        Dialogs.showAlert(e.message ?? "Login failed", context);
      }
    }
  }

  handeleSignIn() async {
    signInWithGoogle().then((user) async {
      Dialogs.showPrograssBar(context);
      if (user != null) {
        log("User Info : ${user.additionalUserInfo}");
        if ((await APIs.userExist())) {
          Storage().setLogin(val: (await APIs.userExist()));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => HomeScreen()),
            (route) => false,
          );
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => HomeScreen()),
              (route) => false,
            );
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate(
        scopeHint: ["email"],
      );

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credintial = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return APIs.auth.signInWithCredential(credintial);
    } catch (e) {
      log("error : $e");
      Dialogs.showAlert("Internet Not Connect", context);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    np = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFEAEAEA),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              _headerSection(
                left: 0,
                right: 0,
                top: 0,
                bottom: np.height * 0.7,
              ),
              _leftImage(bottom: 0, left: 0, right: 0, top: 0),
              _intialHeading(
                left: np.width * 0.20,
                top: np.height * 0.05,
                right: 0,
                heading: "Login",
              ),

              Positioned(
                left: np.width * 0.2,
                top: np.height * 0.4,
                right: 0,
                child: Container(
                  height: np.height * 0.3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _inputFeildEmail(
                          title: "Email",
                          icon: Icons.person,
                          controller: emailController,
                        ),
                        SizedBox(height: 20),
                        _inputFeildPassword(
                          controller: passwordController,
                          title: "Password",
                          icon: Icons.password,
                          isShow: _isShowPassword,
                          onPressed: () {
                            setState(() {
                              _isShowPassword = !_isShowPassword;
                            });
                          },
                        ),
                        SizedBox(height: np.width * 0.05),
                        Align(
                          alignment: Alignment(0.8, 0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              loginWithemailAndPassword();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.25),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(5),
                              ),
                            ),
                            icon: Icon(Icons.login, color: Colors.white),
                            label: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: np.height * 0.18,
                left: 50,
                right: 50,
                child: TextButton.icon(
                  onPressed: () {
                    handeleSignIn();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                  ),
                  icon: Image.asset(
                    "assets/google.png",
                    height: np.width * 0.07,
                  ),
                  label: Text("Sign in With Google"),
                ),
              ),
              Positioned(
                bottom: np.height * 0.12,
                left: 100,
                right: 100,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (ctx) => SignUpScreen()),
                      (route) => false,
                    );
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                  ),
                  icon: Icon(Icons.app_registration),
                  label: Text("Sign up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _intialHeading({
    required double left,
    required double right,
    required double top,
    required String heading,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      child: Center(
        child: Text(
          heading,
          style: TextStyle(
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(0, 6),
                blurRadius: 0.2,
              ),
            ],
            color: Colors.white,
            fontSize: np.width * 0.12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _leftImage({
    required double left,
    required double right,
    required double top,
    required double bottom,
  }) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/doctor.png"),
            fit: BoxFit.fitHeight,
            opacity: 0.9,
          ),
        ),
      ),
    );
  }

  Widget _headerSection({
    required double left,
    required double right,
    required double top,
    required double bottom,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue.withOpacity(0.6),
          // border: Border.all(width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
        ),
      ),
    );
  }

  Widget _inputFeildPassword({
    required String title,
    required IconData icon,
    required bool isShow,
    required VoidCallback onPressed,
    required TextEditingController controller,
  }) {
    return Container(
      width: np.width * 0.7,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: Offset(-6, -6),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        minLines: 1,
        controller: controller,
        obscureText: isShow,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon),
          suffixIcon: IconButton(
            onPressed: onPressed,

            icon: Icon(
              _isShowPassword ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 0.1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 0.1),
          ),
        ),
      ),
    );
  }

  Widget _inputFeildEmail({
    required TextEditingController controller,
    required String title,
    required IconData icon,
  }) {
    return Container(
      width: np.width * 0.7,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: Offset(-6, -6),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        minLines: 1,
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 0.1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 0.1),
          ),
        ),
      ),
    );
  }
}

// class AppColors {
//   static const Color primaryBlue = Color(0xFF2E86AB);
//   static const Color secondaryBlue = Color(0xFF4A90B8);
// }
