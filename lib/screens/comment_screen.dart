import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:somGram/utilis/utilis.dart';

import '../provider/dark_themes_provider.dart';
import '../services/firestore_methods.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  bool isLoading = false;
  int commnetLen = 0;

  // * this method gets comment length
  void getCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commnetLen = snap.docs.length;
      });
    } catch (e) {
      print(Utilis().showSnackBar(e.toString(), Colors.red, context));
    }
  }

  DocumentSnapshot? userSnapshot;
  getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;
    userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    // setState(() {});
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    getCommentLen();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${commnetLen.toString()} comments',
          style: GoogleFonts.poppins(
            color: themeState.getDarkTheme ? Colors.white : Colors.black,
          ),
        ),
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
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
                  // color: Colors.green,
                  ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    //listview comment
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final commentSnap = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                          "⚠️ Delete Alert Dialog Box"),
                                      content: Text(
                                          "Are you sure you want to delete \n (${commentSnap['comment']})"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            color: Colors.blue,
                                            padding: const EdgeInsets.all(14),
                                            child: const Text(
                                              "No",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: Colors.green,
                                          child: TextButton(
                                            onPressed: () {
                                              userSnapshot!['uid'] ==
                                                      commentSnap['uid']
                                                  ? snapshot.data!.docs[index]
                                                      .reference
                                                      .delete()
                                                  : Utilis().showSnackBar(
                                                      'You got No permission to delete other comments',
                                                      Colors.red,
                                                      context);
                                              Navigator.pop(context);
                                              // print(snapshot.data!.docs[index]);
                                            },
                                            child: const Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    // backgroundColor: Colors.green,
                                    backgroundImage: CachedNetworkImageProvider(
                                      commentSnap['profilePic'],
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        "${commentSnap['username']}: ",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(commentSnap['comment']),
                                    ],
                                  ),
                                  subtitle: Text(DateFormat.yMMMd().format(
                                    commentSnap['datePublished'].toDate(),
                                  )),
                                ),
                              ),
                            );
                          }),
                    ),
                    const Divider(),

                    // txtfield comment
                    // const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            // backgroundColor: Colors.green,
                            backgroundImage: CachedNetworkImageProvider(
                                userSnapshot!['photoUrl']),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText:
                                    "Comment as ${userSnapshot!['username']}",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirestoreMethods().commentPost(
                                widget.snap['postId'],
                                commentController.text,
                                userSnapshot!['uid'],
                                userSnapshot!['username'],
                                userSnapshot!['photoUrl'],
                              );
                              commentController.text = '';
                            },
                            child: Text(
                              "Post",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
