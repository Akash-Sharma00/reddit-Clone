import 'package:flutter/material.dart';
import 'package:red_it/features/auth/screen/login_screen.dart';
import 'package:red_it/features/home/homescreen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: LoginScreen()),
},);

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: HomeScreen()),
},);