import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:somGram/screens/forget_screen.dart';
import 'package:somGram/screens/sign_up_screen.dart';
import 'package:somGram/services/auth_methods.dart';
import '../provider/dark_themes_provider.dart';
import '../utilis/utilis.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String result = await AuthMethods().loginUser(
      email: _email.text.trim(),
      password: _password.text,
    );
    if (result == "Success") {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show the error

      // ignore: use_build_context_synchronously
      Utilis().showSnackBar(result, Colors.red, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //sooyal Logo
                Image.asset("images/login.png"),
                Text(
                  "somGram",
                  style: GoogleFonts.courgette(
                    fontSize: 45,
                    color: const Color(0xff2F57E2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // login text
                Text(
                  "Login with your email and password to \naccess your account. if you don't Have an \naccount, you can create one by clicking the \nbutton below.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                // email txt
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      )),
                      hintText: "example@gmail.com",
                      labelText: "email",
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintStyle: GoogleFonts.poppins(
                          // fontSize: 20,
                          color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email required !!";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // password txt
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      )),
                      hintText: "type your password here",
                      labelText: "password",
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintStyle: GoogleFonts.poppins(
                          // fontSize: 20,
                          color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Password required !!";
                      }
                      return null;
                    }),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // forget text
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgetScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 45),
                        child: Text(
                          "Forgot your password",
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // loginBtn
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: InkWell(
                    onTap: () {
                      if (_email.text == "" || _password.text == "") {
                        if (_formkey.currentState!.validate()) {}
                      }
                      loginUser();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : const Color(0xff2F57E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: isLoading == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  color: themeState.getDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 23,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                // dont have an account
              ],
            ),
          ),
        ),
      ),
    );
  }
}
