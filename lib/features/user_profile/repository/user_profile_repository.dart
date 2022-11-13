import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:red_it/models/user_model.dart';

import '../../../core/constants/firebase_constant.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_provider.dart';
import '../../../core/type_def.dart';
import '../../../models/post_modal.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
        CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);


  FutureVoid editCommunity(UserModal user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
   Stream<List<Post>> getUserPosts(String uid) {
    return _posts.where('uid', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots().map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid updateUserKarma(UserModal user) async {
    try {
      return right(_users.doc(user.uid).update({
        'karma': user.karma,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
