
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/common/error_text.dart';
import 'package:red_it/core/common/loader.dart';
import 'package:red_it/features/auth/controller/auth_controller.dart';

import 'package:routemaster/routemaster.dart';

import '../../../core/common/post_card.dart';
import '../controller/user_profile_controller.dart';

class USerProfileScreen extends ConsumerWidget {
  final String uid;
  const USerProfileScreen({super.key, required this.uid});

  navigateToEditUSerScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (data) => NestedScrollView(
              headerSliverBuilder: ((context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(children: [
                      Positioned.fill(
                        child: Image.network(
                          data.banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(data.profilePic),
                          radius: 35,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () => navigateToEditUSerScreen(context),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25)),
                          child: const Text("Edit Profile"),
                        ),
                      ),
                    ]),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "U/${data.name}",
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${data.karma} Karma",
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              }),
              body: ref.watch(getUserPostsProvider(uid)).when(
                    data: (posts) {
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = posts[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
