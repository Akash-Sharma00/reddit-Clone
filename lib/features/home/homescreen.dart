import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/constants/constant.dart';
import 'package:red_it/features/auth/controller/auth_controller.dart';
import 'package:red_it/features/home/delegate/search_community_delegate.dart';
import 'package:red_it/features/home/drawers/community_list_drawer.dart';
import 'package:red_it/features/home/drawers/profile_drawer.dart';
import 'package:red_it/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChnaged(int page) {
    _page = page;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final theme = ref.watch(themeNotifiereProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          // Image.network(user.profilePic),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          })
        ],
      ),
      body: Constants.tabWidgets[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onPageChnaged,
        currentIndex: _page,
        backgroundColor: theme.backgroundColor,
        selectedItemColor: theme.iconTheme.color,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
        ],
      ),
    );
  }
}
