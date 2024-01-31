import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:somGram/models/post.dart';
import 'package:somGram/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = 'Some error occurred';
    try {
      String photoUrl =
          await StrorageMethods().uploadImageToStrorage('posts', file, true);

      //&============================Post to Firebase=====================================//
      String postId = const Uuid()
          .v1(); // * variable ka postId wuxu naga caawina ina dhowr posts ku keedino databse si aysan u dhicin override
      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
      //&=============xx===============Post to Firebase===================xx==================//
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      //* hadii uu hore like u saarna remove that like 👍🩷
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentPost(String postId, String comment, String uid,
      String username, String profilePic) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'username': username,
          'uid': uid,
          'comment': comment,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        log("Comment is empty");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  //* comment delete

  Future<String> deleteComment(
      String postId, String commentId, String deletingComment) async {
    String res = 'some error occured..';
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comment')
          .doc(commentId)
          .delete();
      res = 'success';
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      // ? if u already follow unfollow functionality
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }
}
