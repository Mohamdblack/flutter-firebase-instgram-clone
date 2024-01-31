import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somGram/provider/dark_themes_provider.dart';
import 'package:somGram/provider/user_provider.dart';
import 'package:somGram/responsive/mobile_screen_layout.dart';
import 'package:somGram/responsive/responsive_layout.dart';
import 'package:somGram/responsive/web_screen_layout.dart';
import 'package:somGram/screens/login_screen.dart';
import 'package:somGram/themes/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProfider themeProfider = DarkThemeProfider();

// * getting current app theme
  void getTheme() async {
    themeProfider.setDarkTheme = await themeProfider.darkThemeprefs.getTheme();
  }

  // addData() async {
  //   UserProvider userProvider =
  //       Provider.of<UserProvider>(context, listen: false);
  //   await userProvider.updateUser();
  // }

  @override
  void initState() {
    super.initState();
    getTheme();
    // addData();
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProfider>(create: (_) {
          return themeProfider;
        }),
        ChangeNotifierProvider<UserProvider>(create: (_) {
          return UserProvider();
        }),
      ],
      child: Consumer<DarkThemeProfider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
