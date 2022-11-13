import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/features/auth/controller/auth_controller.dart';
import 'package:red_it/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/storage_repository.dart';
import '../../../core/utils.dart';
import '../../../models/post_modal.dart';
import '../repository/user_profile_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userRepositoryProvider);
  return UserProfileController(
      communityRepository: userProfileRepository,
      ref: ref,
      storageRepository: ref.watch(firebaseStorageProvider));
});


final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});


class UserProfileController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController(
      {required UserRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _userRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editCommunity(
      {required File? bannerFile,
      required File? profileFile,
      required String name,
      required BuildContext context}) async {
    UserModal user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profile', id: user.uid, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'user/banner', id: user.uid, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(banner: r));
    }
    user = user.copyWith(name: name);
    final res = await _userRepository.editCommunity(user);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }
    Stream<List<Post>> getUserPosts(String uid) {
    return _userRepository.getUserPosts(uid);
  }

  // void updateUserKarma(UserKarma karma) async {
  //   UserModal user = _ref.read(userProvider)!;
  //   user = user.copyWith(karma: user.karma + karma.karma);

  //   // final res = await _userProfileRepository.updateUserKarma(user);
  //   res.fold((l) => null, (r) => _ref.read(userProvider.notifier).update((state) => user));
  // }
}
