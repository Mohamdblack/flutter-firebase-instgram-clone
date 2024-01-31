import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:somGram/provider/dark_themes_provider.dart';
import 'package:somGram/screens/posts_screen.dart';
import 'package:somGram/screens/search_screen.dart';
import 'package:somGram/screens/setting_page.dart';
import 'package:somGram/widgets/re_usable_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> getdata() async {
    var n = const Text("data");
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 90,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 90,
        title: Row(
          children: [
            Text(
              "som",
              style: GoogleFonts.courgette(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: themeState.getDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "Gram",
              style: GoogleFonts.courgette(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.search_outlined,
              size: 40,
              color: themeState.getDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.more_vert_outlined,
                size: 40,
                color: themeState.getDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              return getdata();
            },
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                return ReUsableCard(
                  snap: snapshot.data!.docs[index],
                );
              }),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeState.getDarkTheme ? Colors.white : Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PostsScreen(),
            ),
          );
        },
        child: Icon(
          Icons.post_add,
          color: themeState.getDarkTheme ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
