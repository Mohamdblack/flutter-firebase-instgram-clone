import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:somGram/screens/login_screen.dart';
import 'package:somGram/services/storage_methods.dart';
import 'package:somGram/models/user_modal.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // * Getting Current Logged User Details 🙆

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String fullName,
    required String username,
    required String bio,
    required String email,
    required String phoneNumber,
    required String password,
    required Uint8List file,
  }) async {
    String result = "Some error occured";

    try {
      if (fullName.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          email.isNotEmpty ||
          phoneNumber != null ||
          password.isNotEmpty) {
        // register these fields

        // * Registering email and passowrd only
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        // add And download profile image function

        String photoUrl = await StrorageMethods()
            .uploadImageToStrorage("ProfilePics", file, false);

        // short way to add User to database

        model.User user = model.User(
          fullname: fullName,
          username: username,
          bio: bio,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          followers: [],
          following: [],
        );

        // add registered user to the cloud database
        await _firestore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );
        result = "success";
      } else {
        result = "Please fill all fields !!!";
      }
    } catch (err) {
      print(
        result = err.toString(),
      );
    }
    return result;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result = "some error occured";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      result = "Success";
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  void logOut(BuildContext context) {
    _auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }
}
