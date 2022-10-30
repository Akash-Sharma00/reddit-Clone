import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/common/error_text.dart';
import 'package:red_it/core/common/loader.dart';
import 'package:red_it/features/community/controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final community = ref.watch(getCommunityByNameProvider(name));
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (data) => NestedScrollView(
              headerSliverBuilder: ((context, innerBoxIsScrolled) {
                return [
                SliverAppBar(expandedHeight: 150,
                flexibleSpace: Stack(children: [
                  Positioned.fill(child: Image.network(data.banner),)
                ]),)
                ];
              }),
              body: const Text("Hello")),
          error: (error, trace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
