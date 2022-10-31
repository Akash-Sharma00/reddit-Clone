import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/core/utils.dart';
import 'package:red_it/features/auth/repository/auth_repository.dart';

import '../../../models/user_model.dart';

final userProvider = StateProvider<UserModal?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref),
);

final authAtateChangeProvider = StreamProvider(((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
}));

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);

  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required Ref ref,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.singInWithGoogle();
    state = false;
    user.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).update((state) => r));
  }

  Stream<UserModal> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
