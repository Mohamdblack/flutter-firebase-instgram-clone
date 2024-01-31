import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:somGram/screens/login_screen.dart';
import 'package:somGram/services/auth_methods.dart';
import 'package:somGram/utilis/utilis.dart';

import '../provider/dark_themes_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _fullname.dispose();
    _username.dispose();
    _bio.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _password.dispose();
  }

  void signUpUser() async {
    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      fullName: _fullname.text,
      username: _username.text,
      bio: _bio.text,
      email: _email.text,
      phoneNumber: _phoneNumber.text,
      password: _password.text,
      file: _image!,
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      // navigate to the home screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show the error

      Utilis().showSnackBar(res, Colors.red, context);
    }
  }

  void selectImage() async {
    Uint8List im = await Utilis().pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProfider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: themeState.getDarkTheme
            ? const Color.fromARGB(255, 11, 11, 21)
            : Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Create an account",
          style: GoogleFonts.poppins(
            color: themeState.getDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          color: Colors.blue,
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
          child: Form(
            key: formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fullname",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _fullname,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Fullname required !";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Username",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "username required !";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Bio",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _bio,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Bio required !";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email required !";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Phone number",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  controller: _phoneNumber,
                  decoration: InputDecoration(
                    // labelText: 'Phone Number',

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    border: const UnderlineInputBorder(),
                  ),
                  initialCountryCode: 'SO',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  validator: (value) {
                    if (value!.completeNumber.isEmpty) {
                      return "phone number required !";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Password",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        // width: 1,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.remove_red_eye_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "password required !";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Photo",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    selectImage();
                  },
                  child: _image != null
                      ? CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage: MemoryImage(
                            _image!,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            "https://www.pngarts.com/files/10/Default-Profile-Picture-PNG-Download-Image-265x279.png",
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        if (_fullname.text == "" ||
                            _username.text == "" ||
                            _bio.text == "" ||
                            _email.text == "" ||
                            _phoneNumber.text == "" ||
                            _password.text == "" ||
                            _image == null) {
                          setState(() {
                            isLoading = false;
                          });
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = false;
                            });
                          }

                          setState(() {
                            isLoading = false;
                          });
                        }
                        signUpUser();
                      },
                      child: Container(
                        width: 160,
                        height: 70,
                        decoration: BoxDecoration(
                          color: themeState.getDarkTheme
                              ? Colors.white
                              : const Color(0xff2F57E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  "Submit",
                                  style: GoogleFonts.poppins(
                                    color: themeState.getDarkTheme
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
