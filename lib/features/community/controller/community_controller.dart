import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/constants/constant.dart';
import 'package:red_it/core/utils.dart';
import 'package:red_it/features/auth/controller/auth_controller.dart';
import 'package:red_it/features/community/repository/community_repository.dart';
import 'package:red_it/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUSerCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository, ref: ref);
});

final getCommunityByNameProvider = StreamProvider.family((ref,String name){
  return  ref.watch(communityControllerProvider.notifier).getCommunityRepositoryByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
        super(false);

  void community(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? " ";
    Community community = Community(
        id: name,
        name: name,
        banner: Contstant.bannerDefault,
        avatar: Contstant.avatarDefault,
        members: [uid],
        mods: [uid]);
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Community Created Successfully");
      Routemaster.of(context).pop();
    });
  }

  Stream<Community> getCommunityRepositoryByName(String name) {
    return _communityRepository.getCommunityRepositoryByName(name);
  }

  Stream<List<Community>> getUSerCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUSerCommunity(uid);
  }
}
