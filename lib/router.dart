import 'package:flutter/material.dart';
import 'package:red_it/features/community/screens/add_mod_scree.dart';
import 'package:red_it/features/community/screens/community_screen.dart';
import 'package:red_it/features/auth/screen/login_screen.dart';
import 'package:red_it/features/community/screens/create_community_screen.dart';
import 'package:red_it/features/community/screens/edit_community_screen.dart';
import 'package:red_it/features/community/screens/mod_tools_screen.dart';
import 'package:red_it/features/home/homescreen.dart';
import 'package:red_it/features/post/screens/add_post_type.dart';
import 'package:red_it/features/user_profile/screen/edit_user_screen.dart';
import 'package:red_it/features/user_profile/screen/user_profile_scree.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
            child: CommunityScreen(
          name: route.pathParameters['name']!,
        )),
    '/mod-tools/:name': (route) =>  MaterialPage(child: ModToolsScreen(name:route.pathParameters['name']!,)),
    '/edit-community/:name': (route) =>  MaterialPage(child: EditCommunityScreen(name:route.pathParameters['name']!,)),
    '/add-mod/:name': (route) =>  MaterialPage(child: AddModScreen(name:route.pathParameters['name']!,)),
    '/u/:uid': (route) =>  MaterialPage(child: USerProfileScreen(uid:route.pathParameters['uid']!,)),
    '/edit-profile/:uid': (route) =>  MaterialPage(child: EditUserScreen(uid:route.pathParameters['uid']!,)),
    '/add-post/:type': (route) =>  MaterialPage(child: AddPostType(type:route.pathParameters['type']!,)),
  },
);
