import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String caption;
  String uid;
  String username;
  String postId;
  final datePublished;
  String postUrl;
  String profileImage;
  final likes;

  Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      caption: snapshot["caption"],
      uid: snapshot["uid"],
      username: snapshot["username"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot["postUrl"],
      profileImage: snapshot["profileImage"],
      likes: snapshot["likes"],
    );
  }
}
