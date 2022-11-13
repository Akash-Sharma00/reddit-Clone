import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/common/error_text.dart';
import 'package:red_it/core/common/loader.dart';
import 'package:red_it/features/auth/controller/auth_controller.dart';
import 'package:red_it/models/user_model.dart';
import 'package:red_it/router.dart';
import 'package:red_it/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModal? userModal;
  void getData(WidgetRef ref, User data) async {
    userModal = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModal);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authAtateChangeProvider).when(
        data: (data) => MaterialApp.router(
              title: 'Reddit',
              theme: ref.watch(themeNotifiereProvider),
              // home: const LoginScreen(),
              routerDelegate: RoutemasterDelegate(
                routesBuilder: (context) {
                  if (data != null) {
                    getData(ref, data);
                    if (userModal != null) {
                      return loggedInRoute;
                    }
                  }
                  return loggedOutRoute;
                },
              ),
              routeInformationParser: const RoutemasterParser(),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}


// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ref.watch(authAtateChangeProvider).when(
//         data: (data) => MaterialApp.router(
//               title: 'Reddit',
//               theme: Pallete.darkModeAppTheme,
//               // home: const LoginScreen(),
//               routerDelegate: RoutemasterDelegate(
//                   routesBuilder: (context) { 
//                     if(data != null){
//                       return loggedInRoute;
//                     }
//                     return loggedOutRoute;
//                   },),
//               routeInformationParser: const RoutemasterParser(),
//             ),
//         error: (error, stackTrace) => ErrorText(error: error.toString()),
//         loading: () => Loader());
//   }
// }
