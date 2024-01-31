import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:somGram/utilis/utilis.dart';

import '../provider/dark_themes_provider.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key? key,
    required this.uid,
    required this.username,
    required this.profUrl,
    required this.fullname,
    required this.bio,
  }) : super(key: key);
  String uid;
  String username;
  String profUrl;
  String fullname;
  String bio;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var postLen = 0;
  bool isFollowing = false;

  DocumentSnapshot? postSnap;
  void getPostDetails() async {
    postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {});
  }

  void getPostLen() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .get();
      setState(() {
        postLen = snap.docs.length;
        //
        isFollowing = userSnapshot!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      Utilis().showSnackBar(e.toString(), Colors.red, context);
    }
  }

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
    getPostLen();
    getPostDetails();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return userSnapshot == null
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: themeState.getDarkTheme
                  ? const Color.fromARGB(255, 11, 11, 21)
                  : Colors.white,
              title: Text(
                userSnapshot!['username']
                        .contains(FirebaseAuth.instance.currentUser!.uid)
                    ? userSnapshot!['username']
                    : widget.username,
                style: GoogleFonts.poppins(
                  color: themeState.getDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                color: themeState.getDarkTheme ? Colors.white : Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // row containing ProfileImg, ColumnWithpost, ColumnWithfollowers, ColumnWithfollowing
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // profile img
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            userSnapshot!['username'].contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? userSnapshot!['photoUrl']
                                : widget.profUrl,
                          ),
                        ),

                        // column with post
                        Column(
                          children: [
                            Text(
                              '$postLen',
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Posts",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        // column with followers
                        Column(
                          children: [
                            Text(
                              userSnapshot!['followers'].length.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Followers",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        // column with following
                        Column(
                          children: [
                            Text(
                              userSnapshot!['following'].length.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Following",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // profile name
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      userSnapshot!['username']
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? userSnapshot!['fullname']
                          : widget.fullname,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // profile bio
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      userSnapshot!['username']
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? userSnapshot!['bio']
                          : widget.bio,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: FirebaseAuth.instance.currentUser!.uid ==
                              widget.uid
                          ? followButton(
                              themeState: themeState,
                              backgroudColor: themeState.getDarkTheme
                                  ? Colors.white10
                                  : const Color.fromARGB(255, 215, 215, 215),
                              text: 'edit Profile',
                              textColor: themeState.getDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                              function: () {},
                            )
                          : isFollowing
                              ? followButton(
                                  themeState: themeState,
                                  backgroudColor: themeState.getDarkTheme
                                      ? Colors.white10
                                      : const Color.fromARGB(
                                          255, 215, 215, 215),
                                  text: 'Unfollow',
                                  textColor: themeState.getDarkTheme
                                      ? Colors.red
                                      : Colors.green,
                                  function: () {},
                                )
                              : followButton(
                                  themeState: themeState,
                                  backgroudColor: themeState.getDarkTheme
                                      ? Colors.white10
                                      : const Color.fromARGB(
                                          255, 215, 215, 215),
                                  text: 'follow',
                                  textColor: themeState.getDarkTheme
                                      ? Colors.blue
                                      : Colors.yellow,
                                  function: () {},
                                )),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("posts")
                          .where('uid', isEqualTo: userSnapshot!['uid'])
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                crossAxisCount: 3,
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                    // width: 300,
                                    // height: 200,
                                    // color: Colors.red,
                                    child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot
                                      .data!.docs[index]['postUrl']
                                      .toString(),
                                ));
                              })),
                        );
                      })
                ],
              ),
            ),
          );
  }
// }
}
