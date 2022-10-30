import 'package:flutter/material.dart';
import 'package:red_it/features/community/screens/community_screen.dart';
import 'package:red_it/features/auth/screen/login_screen.dart';
import 'package:red_it/features/community/screens/create_community_screen.dart';
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
    '/r/:name': (route) =>
         MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!,)),
  },
);
