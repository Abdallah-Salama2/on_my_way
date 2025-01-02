import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_my_way/core/shared/helpers/ftoast_helper.dart';

import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/authentication/data/models/auth_state.dart';
import 'package:on_my_way/features/authentication/data/repos/auth_repo.dart';
import 'package:on_my_way/features/go_food/providers/categories/categories_provider.dart';
import 'package:on_my_way/features/go_food/providers/restaurants/restaurants_provider.dart';

final authStateProvider = NotifierProvider<AuthProvider, AuthState>(
  AuthProvider.new,
  name: "AuthProvider",
);

class AuthProvider extends Notifier<AuthState> {
  late final _authRepo = ref.read(authRepoProvider);

  @override
  AuthState build() {
    return AuthState(authEntity: _authRepo.tryAutoLogin());
  }

  void cacheAuthEntity() {
    if (state.authEntity != null) {
      _authRepo.cacheAuthEntity(state.authEntity!);
      log('Cached');
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
    required bool stayLoggedIn,
  }) async {
    state = state.copyWith(requestState: RequestState.loading);
    final result = await _authRepo.logIn(
      email: email,
      password: password,
      remember: stayLoggedIn,
    );

    try {
      result.fold(
        (l) {
          state = state.copyWith(
            requestState: RequestState.error,
            authMessage: l.message,
          );
        },
        (r) {
          state = state.copyWith(
            authEntity: r,
            requestState: RequestState.loaded,
            authMessage: '',
          );
          if (stayLoggedIn) {
            cacheAuthEntity();
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        requestState: RequestState.error,
        authMessage: e.toString(),
      );
      log("${e.runtimeType}: ${e.toString()}");
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String address,
  }) async {
    state = state.copyWith(requestState: RequestState.loading);
    final result = await _authRepo.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phoneNumber,
      address: address,
    );
    try {
      result.fold(
        (l) {
          state = state.copyWith(
            requestState: RequestState.error,
            authMessage: l.message,
          );
        },
        (r) {
          state = state.copyWith(
            authEntity: r,
            requestState: RequestState.loaded,
            authMessage: '',
          );
          cacheAuthEntity();
        },
      );
    } catch (e) {
      state = state.copyWith(
        requestState: RequestState.error,
        authMessage: e.toString(),
      );
      log("${e.runtimeType}: ${e.toString()}");
    }
  }

  Future<void> logOut() async {
    final token = state.authEntity?.data.token;

    final result = await _authRepo.logOut(token);

    result.fold(
      (l) {
        state = state.copyWith(
          requestState: RequestState.error,
          authMessage: l.message,
        );
      },
      (r) {
        // Log out was successful
        FtoastHelper.showSuccessToast('Logged out');
      },
    );

    _authRepo.unCacheAuthEntity();
    ref.invalidateSelf();
    ref.invalidate(categoriesProvider);
    ref.invalidate(storesProvider);
    log('Cache cleared, logged out successfully');
  }

  Future<void> sendEmail(String email) async {
    state = state.copyWith(requestState: RequestState.loading);
    final result = await _authRepo.sendEmail(email);

    result.fold(
      (l) {
        state = state.copyWith(
          requestState: RequestState.error,
          authMessage: l.message,
        );
      },
      (r) {
        state = state.copyWith(
          requestState: RequestState.loaded,
          authMessage: r,
        );
      },
    );
  }
}
