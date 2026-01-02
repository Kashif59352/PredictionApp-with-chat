import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fypproject/Dialogs/dialogs.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/api/storage.dart';
import 'package:fypproject/screens/auth/signup_screen.dart';
import 'package:fypproject/screens/home_screen.dart';
import 'package:fypproject/utils/responsive_helper.dart';
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

  loginWithemailAndPassword() async {
    try {
      UserCredential userCredential = await APIs.auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // ✅ If we reach here, user EXISTS and is authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (ctx) => HomeScreen()),
          );
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => HomeScreen()),
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
    Size size = MediaQuery.of(context).size;
    bool isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign In"),
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: isMobile ? size.width * 0.9 : 400,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Icon
                Icon(
                  Icons.medical_services,
                  size: 64,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(height: 16),

                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                SizedBox(height: 8),

                Text(
                  "Sign in to continue",
                  style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
                ),
                SizedBox(height: 24),

                // Username Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      loginWithemailAndPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Google Sign in
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      handeleSignIn();
                    },
                    icon: Image.asset("assets/google.png"),
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Google "),
                          TextSpan(text: "Signin"),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Extra actions
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    "SignUp",
                    style: TextStyle(color: AppColors.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
