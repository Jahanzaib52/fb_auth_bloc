import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth_bloc/Exception/image_exception.dart';
import 'package:fb_auth_bloc/constants/db_constants.dart';
import 'package:fb_auth_bloc/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  const FirebaseServices({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    XFile? image,
  }) async {
    try {
      if (image == null) {
        throw ImageException();
      }
      late final String profileImageUrl;
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      Reference reference = firebaseStorage.ref("user/${user.uid}.jpg");

      UploadTask uploadTask = reference.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) {
        profileImageUrl = url;
      }).whenComplete(() async {
        await userRef.doc(user.uid).set({
          "name": name,
          "email": email,
          "profileImage": profileImageUrl,
          "point": 0,
          "rank": "bronze",
        });
      });
    }
    // on FirebaseAuthException catch (e) {
    //   throw CustomError(
    //     code: e.code,
    //     message: e.message!,
    //     plugin: e.plugin,
    //   );
    // }
    catch (e) {
      rethrow;
      // throw CustomError(
      //   code: "Exception",
      //   message: e.toString(),
      //   plugin: "flutter_error/server_error",
      // );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    // on FirebaseAuthException catch (e) {
    //   throw CustomError(
    //     code: e.code,
    //     message: e.message!,
    //     plugin: e.plugin,
    //   );
    // }
    catch (e) {
      rethrow;
      // throw CustomError(
      //   code: "Exception",
      //   message: e.toString(),
      //   plugin: "flutter_error/server_error",
      // );
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }

  Future<CustomUser> getProfile({
    required String uid,
  }) async {
    try {
      final DocumentSnapshot userDoc = await userRef.doc(uid).get();

      if (userDoc.exists) {
        final currentUser = CustomUser.fromDoc(userDoc: userDoc);
        return currentUser;
      }

      throw 'User not found';
    } catch (e) {
      rethrow;
    }
  }
}
