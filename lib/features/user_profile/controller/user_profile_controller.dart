import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/storage_repository.dart';
import '../../../core/utils.dart';
import '../repository/user_profile_repository.dart';

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
      {required Community community,
      required File? bannerFile,
      required File? profileFile,
      required BuildContext context}) async {
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/profile', id: community.name, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/banner', id: community.name, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }
    final res = await _communityRepository.editCommunity(community);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }
}
