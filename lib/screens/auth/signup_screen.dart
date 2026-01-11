import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fypproject/Dialogs/dialogs.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/screens/auth/login_screen.dart';
import '../../utils/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  signup() async {
    try {
      if (passwordController.text != confirmPasswordController.text
      // ||
      //     nameController.text.isEmpty ||
      //     emailController.text.isEmpty
      ) {
        Dialogs.showAlert("Password Not Match", context);
        return;
      } else if (nameController.text.isEmpty) {
        Dialogs.showAlert("Enter Name", context);
        return;
      } else if (emailController.text.isEmpty) {
        Dialogs.showAlert("Enter Email", context);
        return;
      }

      UserCredential userCredintial = await APIs.auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      await userCredintial.user!.updateDisplayName(nameController.text.trim());
      await userCredintial.user!.reload();
      nameController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      emailController.clear();
      Dialogs.showAlert("Signup successful", context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Dialogs.showAlert(
          "An account with this email already exists. Please sign in.",
          context,
        );
      } else if (e.code == 'weak-password') {
        Dialogs.showAlert("Password should be at least 6 characters", context);
      } else if (e.code == 'invalid-email') {
        Dialogs.showAlert("Please enter a valid email address", context);
      } else {
        Dialogs.showAlert(e.message ?? "Signup failed", context);
      }
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEAEAEA),
        body: SafeArea(
          child: Stack(
            children: [
              _headerSection(
                left: 0,
                right: 0,
                top: 0,
                bottom: np.height * 0.8,
              ),
              Positioned(
                left: np.width * 0.02,
                right: np.width * 0.02,
                top: np.height * 0.18,
                bottom: np.height * 0.02,
                child: Column(
                  children: [
                    // Full Name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Email Address",
                        hintText: "example@gmail.com",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Confirm Password
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Terms & Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "I agree to the Terms & Conditions",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Sign Up Button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _acceptTerms
                            ? () {
                                signup();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryBlue.withOpacity(
                            0.6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(80),
          bottomLeft: Radius.circular(80),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.person_add,
              size: np.height * 0.09,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: Offset(0, 6),
                  blurRadius: 0.2,
                ),
              ],
            ),
            Text(
              "Sign Up",
              textAlign: TextAlign.center,
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
          ],
        ),
      ),
    ),
  );
}
