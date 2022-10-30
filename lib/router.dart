import 'package:flutter/material.dart';
import 'package:red_it/features/community/screens/community_screen.dart';
import 'package:red_it/features/auth/screen/login_screen.dart';
import 'package:red_it/features/community/screens/create_community_screen.dart';
import 'package:red_it/features/community/screens/edit_community_screen.dart';
import 'package:red_it/features/community/screens/mod_tools_screen.dart';
import 'package:red_it/features/home/homescreen.dart';
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
  },
);
