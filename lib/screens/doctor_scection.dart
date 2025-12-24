import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/module/chat_user.dart';
import 'package:fypproject/screens/auth/login_screen.dart';
import 'package:fypproject/screens/profile_screen.dart';
import 'package:fypproject/utils/app_colors.dart';
import 'package:fypproject/widgets/chat_user_card.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DoctorSection extends StatefulWidget {
  const DoctorSection({super.key});

  @override
  State<DoctorSection> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<DoctorSection> {
  List<ChatUser> list = [];
  List<ChatUser> searchUser = [];
  bool _isSerach = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSerach) {
            setState(() {
              _isSerach = !_isSerach;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: _isSerach
                ? TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name, Email........",
                    ),
                    autofocus: true,
                    style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                    onChanged: (val) {
                      searchUser.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) &&
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          setState(() {
                            searchUser.add(i);
                          });
                        }
                      }
                    },
                  )
                : Text('Doctor Contact'),
            backgroundColor: AppColors.primaryBlue,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSerach = !_isSerach;
                  });
                },
                icon: Icon(
                  _isSerach ? CupertinoIcons.clear_circled_solid : Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ProfileScreen(user: APIs.me),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              GoogleSignIn.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (ctx) => LoginScreen()),
              );
            },
          ),
          body: StreamBuilder(
            stream: APIs.getUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.waiting:
                case ConnectionState.active:
                case ConnectionState.done:

                  // 🔴 Error state
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  // ⏳ Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 📭 No data
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  final data = snapshot.data!.docs;
                  // log("data ${jsonEncode(data)}");
                  list = data.map((e) => ChatUser.fromJson(e.data())).toList();
                  // log("data ${list[0].name}");
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _isSerach ? searchUser.length : list.length,
                      itemBuilder: (context, index) {
                        // final data = users[index];

                        return ChatUserCard(
                          user: _isSerach ? searchUser[index] : list[index],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("Not USers", style: TextStyle(fontSize: 20)),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
