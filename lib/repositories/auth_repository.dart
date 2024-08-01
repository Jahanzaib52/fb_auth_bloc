import 'package:fb_auth_bloc/Exception/image_exception.dart';
import 'package:fb_auth_bloc/models/custom_error.dart';
import 'package:fb_auth_bloc/models/user_model.dart';
import 'package:fb_auth_bloc/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AuthRepository {
  final FirebaseServices firebaseServices;
  const AuthRepository({
    required this.firebaseServices,
  });
  Stream<User?> get user => firebaseServices.firebaseAuth.userChanges();
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    XFile? image,
  }) async {
    try {
      await firebaseServices.signup(
        name: name,
        email: email,
        password: password,
        image: image,
      );
    } on FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } on ImageException catch (e) {
      throw CustomError(
        code: "Image Exception",
        message: e.message,
        plugin: "Image Error",
      );
    } catch (e) {
      throw CustomError(
        code: "Exception",
        message: e.toString(),
        plugin: "flutter_error/server_error",
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseServices.signin(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: "Exception",
        message: e.toString(),
        plugin: "flutter_error/server_error",
      );
    }
  }

  Future<void> signout() async {
    await firebaseServices.signout();
  }

  Future<CustomUser> getProfile({
    required String uid,
  }) async {
    try {
      final CustomUser user=await firebaseServices.getProfile(uid: uid);
      return user;
    } on FirebaseException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: "Exception",
        message: e.toString(),
        plugin: "flutter_error/server_error",
      );
    }
  }
  /*Future<void> signup({
    required String name,
    required String email,
    required String password,
    required XFile image,
  }) async {
    try {
      late final String profileImageUrl;
      //late final User user;
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
      //     .then((UserCredential userCredential) async {
      //   user = userCredential.user!;
      //   Reference reference = firebaseStorage.ref("user/${user.uid}.jpg");
      //   UploadTask uploadTask = reference.putFile(File(image.path));
      //   TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      //   await taskSnapshot.ref.getDownloadURL().then((url) {
      //     profileImageUrl = url;
      //   });
      //   //profileImageUrl = await reference.getDownloadURL();
      // }).whenComplete(() async {
      //   // final user = userCredential.user;
      //   await userRef.doc(user.uid).set({
      //     "name": name,
      //     "email": email,
      //     "profileImage": profileImageUrl,
      //     "point": 0,
      //     "rank": "bronze",
      //   });
      // });
    } on FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: "Exception",
        message: e.toString(),
        plugin: "flutter_error/server_error",
      );
    }
  }

  //
  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: "Exception",
        message: e.toString(),
        plugin: "flutter_error/server_error",
      );
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }*/
}
