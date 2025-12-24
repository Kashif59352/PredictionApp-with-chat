import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fypproject/Dialogs/dialogs.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/module/chat_user.dart';
import 'package:fypproject/screens/auth/login_screen.dart';
import 'package:fypproject/utils/app_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    np = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Screen'),
          backgroundColor: AppColors.primaryBlue,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              Dialogs.showPrograssBar(context);
              await APIs.auth.signOut();
              await GoogleSignIn.instance.signOut().then((value) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (ctx) => LoginScreen()),
                );
              });
            },
            icon: Icon(Icons.logout_outlined),
            label: Text("Logout"),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: np.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: np.width, height: np.height * .03),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(
                          np.height * 1,
                        ),
                        child: CachedNetworkImage(
                          width: np.width * .4,
                          height: np.height * .2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              CircleAvatar(child: Icon(Icons.error)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: np.height * .03),
                  Text(
                    widget.user.email,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: np.height * .03),

                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required field",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      label: Text("Name"),
                    ),
                  ),
                  SizedBox(height: np.height * .03),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required field",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      label: Text("About"),
                    ),
                  ),
                  SizedBox(height: np.height * .03),
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserData();
                        log("inside validator");
                        Dialogs.showAlert("Update Successfull ", context);
                      }
                    },
                    label: Text("UPDATE"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Pic Profile Picture",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: np.height*.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(np.width * .3, np.height * .07),
                  ),
                  child: Image.asset("assets/camera.png"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(np.width * .3, np.height * .07 ),
                  ),
                  child: Image.asset("assets/picture.png"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
