import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String fullname;
  String username;
  String bio;
  String email;
  String uid;
  String phoneNumber;
  String password;
  String photoUrl;
  List followers;
  List following;

  User({
    required this.fullname,
    required this.username,
    required this.bio,
    required this.email,
    required this.uid,
    required this.phoneNumber,
    required this.password,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "username": username,
        "bio": bio,
        "email": email,
        "uid": uid,
        "phoneNumber": phoneNumber,
        "password": password,
        "photoUrl": photoUrl,
        "followers": followers,
        "following": following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      fullname: snapshot["fullname"],
      username: snapshot["username"],
      bio: snapshot["bio"],
      email: snapshot["email"],
      uid: snapshot["uid"],
      phoneNumber: snapshot["phoneNumber"],
      password: snapshot["password"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
