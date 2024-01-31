import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somGram/screens/profile_screen.dart';

import '../provider/dark_themes_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUser = false;
  TextEditingController searchController = TextEditingController();

  DocumentSnapshot? userSnapshot;
  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: themeState.getDarkTheme
                            ? Colors.white10
                            : const Color.fromARGB(255, 215, 215, 215),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search user',
                          ),
                          onChanged: (String _) {
                            setState(() {
                              isShowUser = true;
                            });
                          },
                          // onFieldSubmitted: (_) {

                          //   // print(searchController.text);
                          // },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            isShowUser == true
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('username',
                            isEqualTo: searchController.text.trim())
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      log(snapshot.data.toString());
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // print(
                                //     "-------------------------=============================-----------------------------");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfileScreen(
                                      uid: snapshot.data!.docs[index]['uid'],
                                      username: snapshot.data!.docs[index]
                                          ['username'],
                                      profUrl: snapshot.data!.docs[index]
                                          ['photoUrl'],
                                      fullname: snapshot.data!.docs[index]
                                          ['fullname'],
                                      bio: snapshot.data!.docs[index]['bio'],
                                    ),
                                  ),
                                );
                                // print(
                                //     "-------------------------=============================-----------------------------");
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data!.docs[index]['photoUrl'],
                                  ),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index]['username'],
                                ),
                                subtitle: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['fullname'],
                                    ),
                                    const Text("20M followes"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                :
                // : FutureBuilder(
                //     future:
                //         FirebaseFirestore.instance.collection('posts').get(),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) {
                //         return const Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       }
                //       return StaggeredGrid.count(
                //         crossAxisCount: 4,
                //         mainAxisSpacing: 4,
                //         crossAxisSpacing: 4,
                //       );
                //     },
                //   ),
                const Center(child: Text("posts will be displayed here"))
          ],
        ),
      ),
    );
  }
}
