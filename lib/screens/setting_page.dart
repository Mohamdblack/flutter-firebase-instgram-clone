import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:somGram/provider/dark_themes_provider.dart';
import 'package:somGram/screens/profile_screen.dart';
import 'package:somGram/services/auth_methods.dart';

import '../widgets/setting_re_usable.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  DocumentSnapshot? userSnapshot;
  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);
    // model.User user = Provider.of<UserProvider>(context).getUser;

    return userSnapshot == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: themeState.getDarkTheme ? Colors.white : Colors.black,
                  size: 25,
                ),
              ),
              title: Text(
                "Settings",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: themeState.getDarkTheme ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                // row with image and name
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            uid: userSnapshot!['uid'],
                            username: userSnapshot!['username'],
                            profUrl: userSnapshot!['photoUrl'],
                            fullname: userSnapshot!['fullname'],
                            bio: userSnapshot!['bio'],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: CachedNetworkImageProvider(
                            userSnapshot!['photoUrl'],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          userSnapshot!['fullname'],
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: themeState.getDarkTheme
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),

                // other all columns
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      SetiingReUsable(
                        iconName: Icons.favorite_border_outlined,
                        tileName: "Favourites",
                        tapClick: () {
                          print("Favourites");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SetiingReUsable(
                        iconName: Icons.lock,
                        tileName: "Change password",
                        tapClick: () {
                          print("change password");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SetiingReUsable(
                        iconName: Icons.notifications_active_outlined,
                        tileName: "Notifications",
                        tapClick: () {
                          print("Notifications");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SetiingReUsable(
                        iconName: Icons.check,
                        tileName: "Privacy & Security",
                        tapClick: () {
                          print("Privacay & Security");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SetiingReUsable(
                        iconName: Icons.info_outline,
                        tileName: "About",
                        tapClick: () {
                          print("About");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SetiingReUsable(
                        iconName: Icons.question_mark_outlined,
                        tileName: "Help",
                        tapClick: () {
                          print("Help");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      // SetiingReUsable(
                      //   iconName: Icons.light_mode_outlined,
                      //   tileName: "Light Mode",
                      //   themeIcon: Icons.light_mode_outlined,
                      //   tapClick: () {
                      //     print("Light Mode");
                      //   },
                      // ),

                      SwitchListTile(
                        secondary: Icon(
                          themeState.getDarkTheme
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          size: 36,
                          color: themeState.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          "Light Mode",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),
                        ),
                        value: themeState.getDarkTheme,
                        onChanged: ((value) {
                          themeState.setDarkTheme = value;
                        }),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      SetiingReUsable(
                        iconName: Icons.delete_outline,
                        tileName: "Delete Account",
                        tapClick: () {
                          print("Delete Account");
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SetiingReUsable(
                        iconName: Icons.logout_outlined,
                        tileName: "Logout",
                        tapClick: () {
                          AuthMethods().logOut(context);
                        },
                      ),
                      // const SwitchListile(),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
