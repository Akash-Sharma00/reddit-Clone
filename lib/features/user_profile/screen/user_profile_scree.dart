import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/common/error_text.dart';
import 'package:red_it/core/common/loader.dart';
import 'package:red_it/features/auth/controller/auth_controller.dart';
import 'package:red_it/features/community/controller/community_controller.dart';
import 'package:red_it/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class USerProfileScreen extends ConsumerWidget {
  final String uid;
  const USerProfileScreen({super.key, required this.uid});

navigateToEditUSerScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
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
                        padding:EdgeInsets.all(20).copyWith(bottom: 70),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(data.profilePic),
                              radius: 35,
                            ),
                          ),
                       Container(
                        alignment: Alignment.bottomLeft,
                        padding:EdgeInsets.all(20),
                         child: OutlinedButton(
                                        onPressed: () =>navigateToEditUSerScreen(context),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25)),
                                        child: Text(
                                        "Edit Profile"),
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
                          SizedBox(height: 10,),
                          Divider(thickness: 2,),
                        ],
                      ),
                    ),
                  ),
                ];
              }),
              body: const Text("Hello")),
          error: (error, trace) =>
              ErrorText(error: "${error.toString()} ${trace.toString()}"),
          loading: () => const Loader()),
    );
  }
}
