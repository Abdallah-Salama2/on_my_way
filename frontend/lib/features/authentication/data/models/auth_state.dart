import 'package:equatable/equatable.dart';
import 'package:on_my_way/core/utils/enums.dart';
import 'package:on_my_way/features/authentication/data/models/auth_entity.dart';

class AuthState extends Equatable {
  final AuthEntity? authEntity;
  final RequestState requestState;
  final String authMessage;

  const AuthState({
    this.authEntity,
    this.requestState = RequestState.initial,
    this.authMessage = '',
  });

  AuthState copyWith({
    AuthEntity? authEntity,
    RequestState? requestState,
    String? authMessage,
  }) {
    return AuthState(
      authEntity: authEntity ?? this.authEntity,
      requestState: requestState ?? this.requestState,
      authMessage: authMessage ?? this.authMessage,
    );
  }

  @override
  List<Object?> get props => [authEntity, requestState, authMessage];
}
