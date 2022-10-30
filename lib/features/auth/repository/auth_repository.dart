import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:red_it/core/constants/constant.dart';
import 'package:red_it/core/constants/firebase_constant.dart';
import 'package:red_it/core/failure.dart';
import 'package:red_it/core/providers/firebase_provider.dart';
import 'package:red_it/core/type_def.dart';
import 'package:red_it/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSingInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Stream<User?> get authStateChange => _auth.authStateChanges();
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModal> singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      // print(userCredential.user?.email);
      UserModal userModal;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModal = UserModal(
            name: userCredential.user!.displayName ?? "Untitled",
            profilePic:
                userCredential.user!.photoURL ?? Contstant.avatarDefault,
            banner: Contstant.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: []);
        await _users.doc(userCredential.user!.uid).set(userModal.toMap());
      } else {
        userModal = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModal);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModal> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModal.fromMap(event.data() as Map<String, dynamic>));
  }
}
