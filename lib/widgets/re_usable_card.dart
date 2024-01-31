import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:somGram/provider/dark_themes_provider.dart';
import 'package:somGram/services/firestore_methods.dart';
import 'package:somGram/utilis/utilis.dart';
import 'package:somGram/widgets/like_animation.dart';

import '../screens/comment_screen.dart';

class ReUsableCard extends StatefulWidget {
  const ReUsableCard({
    required this.snap,
    Key? key,
  }) : super(key: key);

  final snap;

  @override
  State<ReUsableCard> createState() => _ReUsableCardState();
}

class _ReUsableCardState extends State<ReUsableCard> {
  void deletePost() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .delete();
    setState(() {});
  }

  bool isLikeAnimating = false;
  DocumentSnapshot? userSnapshot;
  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
    userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: themeState.getDarkTheme
            ? const Color.fromARGB(255, 10, 10, 18)
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.snap['profileImage'],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                          color: themeState.getDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate(),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: themeState.getDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  userSnapshot == null
                      ? Center(
                          child: CircularProgressIndicator(
                            color: themeState.getDarkTheme
                                ? Colors.black
                                : Colors.white,
                          ),
                        )
                      : userSnapshot!['uid'] == widget.snap['uid']
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        "⚠️ Delete Alert Dialog Box"),
                                    content: const Text(
                                        "Are you sure you want to delete this post"),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.green,
                                        child: TextButton(
                                          onPressed: () {
                                            deletePost();
                                            Navigator.pop(context);
                                            Utilis().showSnackBar(
                                                'post deleted!..',
                                                Colors.green,
                                                context);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert_outlined,
                              ),
                            )
                          : Container(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onDoubleTap: () async {
                  await FirestoreMethods().likePost(
                    widget.snap['postId'],
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.snap['likes'],
                  );
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.snap['postUrl'],
                      width: double.infinity,
                      // image.toString(),
                      fit: BoxFit.cover,
                      // useOldImageOnUrlChange: true,
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(milliseconds: 900),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 120,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.snap['caption'],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeAnimation(
                        isAnimating: widget.snap['likes']
                            .contains(FirebaseAuth.instance.currentUser!.uid),
                        smallLike: true,
                        child: IconButton(
                          onPressed: () async {
                            await FirestoreMethods().likePost(
                              widget.snap['postId'],
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.snap['likes'],
                            );
                          },
                          icon: widget.snap['likes'].contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? const Icon(
                                  Icons.favorite_outlined,
                                  size: 30,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border_outlined,
                                ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommentScreen(
                                snap: widget.snap,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.comment_outlined,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.bookmark_border,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  "${widget.snap['likes'].length} likes",
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
