import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/common/error_text.dart';
import 'package:red_it/core/common/loader.dart';
import 'package:red_it/core/common/post_card.dart';
import 'package:red_it/features/community/controller/community_controller.dart';
import 'package:red_it/features/post/repository/add_post_repository.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userCommunitiesProvider).when(
        data: (community) => ref.watch(userPostsProvider(community)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return PostCard(post: post);
                },
              );
            },
            error: (error, sta) => ErrorText(error: error.toString()),
            loading: () => const Loader()),
        error: (error, strace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
