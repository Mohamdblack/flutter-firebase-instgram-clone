import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:somGram/utilis/utilis.dart';

import '../provider/dark_themes_provider.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final TextEditingController _email = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      isLoading = true;
    });
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
        setState(() {
          Utilis().showSnackBar(
              'Password reset email sent. Please check your inbox.',
              Colors.green,
              context);
        });
      } catch (e) {
        setState(() {
          Utilis().showSnackBar(
              'Failed to send password reset email. Please try again.',
              Colors.red,
              context);
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget password"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: themeState.getDarkTheme ? Colors.white : Colors.black,
      ),
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //sooyal Logo
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
              "Forget your password\n it happens some times .😍",
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
                    color:
                        themeState.getDarkTheme ? Colors.white : Colors.black,
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

            // loginBtn
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: InkWell(
                onTap: () {
                  _resetPassword();
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
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "SEND",
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
            // dont have an account
          ],
        ),
      ),
    );
  }
}
