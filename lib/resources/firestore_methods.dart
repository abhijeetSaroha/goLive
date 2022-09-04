import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_live/models/livestream.dart';
import 'package:go_live/providers/user_provider.dart';
import 'package:go_live/resources/storage_methods.dart';
import 'package:go_live/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();
  String channelId = '';

  Future<String> startLiveStream(
      BuildContext context, String title, Uint8List? image) async {
    final user = Provider.of<UserProvider>(context, listen: false);

    try {
      if (title.isNotEmpty && image != null) {
        if (!((await _firestore
                .collection('livestream')
                .doc('${user.user.uid}${user.user.username}')
                .get())
            .exists)) {
          String thumbnailUrl = await _storageMethods.uploadImageToStorage(
            'livestream-thumbnails',
            image,
            user.user.uid,
          );
          // channel id : "userid(uid)-username"
          String channelId = '${user.user.uid}${user.user.username}';
          LiveStream liveStream = LiveStream(
            title: title,
            image: thumbnailUrl,
            uid: user.user.uid,
            username: user.user.username,
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          );

          _firestore
              .collection('livestream')
              .doc(channelId)
              .set(liveStream.toMap());
        } else {
          showSnackBar(
              context, 'Two Live Stream can not start at the same time.');
        }
      } else {
        showSnackBar(context, "Please Enter All the Fields.");
        return '';
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
    return channelId;
  }

  Future<void> chat(String text, String id, BuildContext context) async {
    // ignore: unused_local_variable
    final user = Provider.of<UserProvider>(context, listen: false);

    try {
      String commentId = const Uuid().v1();
      await _firestore
          .collection('livestream')
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set({
        'username': user.user.username,
        'message': text,
        'uid': user.user.uid,
        'createdAt': DateTime.now(),
        'commentId': commentId
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore.collection('livestream').doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> endLiveStream(String channelId) async {
    try {
      QuerySnapshot snap = await _firestore
          .collection('livestream')
          .doc(channelId)
          .collection('comments')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .collection('livestream')
            .doc('channelId')
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }

      await _firestore.collection('livestream').doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
