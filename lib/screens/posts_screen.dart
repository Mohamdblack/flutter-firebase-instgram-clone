import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:somGram/services/firestore_methods.dart';
import 'package:somGram/utilis/utilis.dart';

import '../provider/dark_themes_provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  TextEditingController captionController = TextEditingController();

  //===================Function kan wuxu no qapana ina User Details Firebase ka ka doonano====================//
  DocumentSnapshot? userSnapshot;
  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {});
  }
//=========xx==========Function kan wuxu no qapana ina User Details Firebase ka ka doonano=========xx===========//

//================================ Function kan Wuxu Post Garena images ka ================================//
  bool isLoading = false;
  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          captionController.text, _file!, uid, username, profileImage);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        Utilis().showSnackBar("Posted!...", Colors.green, context);
        _file = null;
      } else {
        setState(() {
          isLoading = false;
        });
        Utilis().showSnackBar(res, Colors.red, context);
      }
    } catch (e) {
      Utilis().showSnackBar(e.toString(), Colors.red, context);
    }
  }

//=============xx=================== Function kan Wuxu Post Garena images ka ==============xx==================//

  //==========================Creation of Dialog box with image Provider=======================================//

  Uint8List? _file;
  selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create Post"),
          children: [
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await Utilis().pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file =
                      await Utilis().pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
//===========xx===============Creation of Dialog box with image Provider=================xx======================//

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeState.getDarkTheme
            ? const Color.fromARGB(255, 11, 11, 21)
            : Colors.white,
        title: Text(
          "Post to",
          style: GoogleFonts.poppins(
            color: themeState.getDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          color: themeState.getDarkTheme ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
        actions: [
          _file == null
              ? Container()
              : TextButton(
                  onPressed: () {
                    postImage(
                      userSnapshot!['uid'],
                      userSnapshot!['username'],
                      userSnapshot!['photoUrl'],
                    );
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
        ],
      ),
      body: _file == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      selectImage(context);
                    },
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Tap to add an image",
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                  ),
                )
              ],
            )
          : Column(
              children: [
                isLoading ? const LinearProgressIndicator() : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          userSnapshot!['photoUrl'],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: captionController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write a caption..."),
                          ),
                        ),
                      ),
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Divider(),
              ],
            ),
    );
  }
}
