// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_live/models/user.dart' as model;
import 'package:go_live/providers/user_provider.dart';
import 'package:go_live/utils/utils.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    if (uid != null) {
      final sanp = await _userRef.doc(uid).get();
      return sanp.data();
    }
    return null;
  }

  Future<bool> signUpUser(BuildContext context, String email, String username,
      String password) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        model.User user = model.User(
          username: username.trim(),
          email: email.trim(),
          uid: cred.user!.uid,
        );
        await _userRef.doc(cred.user!.uid).set(user.toMap());
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message!);
      showSnackBar(context, e.message!);
      res = false;
    }

    return res;
  }

  Future<bool> logInUser(
      BuildContext context, String email, String password) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(
          model.User.fromMap(
            await getCurrentUser(cred.user!.uid) ?? {},
          ),
        );
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message!);
      showSnackBar(context, e.message!);
      res = false;
    }

    return res;
  }
}
