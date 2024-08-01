part of 'auth_bloc.dart';

enum AuthStatus {
  unKnown,
  authenticated,
  unAuthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final fb.User? user;
  const AuthState({required this.authStatus, this.user});
  factory AuthState.initial() {
    return const AuthState(
      authStatus: AuthStatus.unKnown,
      user: null,
    );
  }
  @override
  List<Object?> get props => [authStatus, user];
  AuthState copyWith({AuthStatus? authStatus, fb.User? user}) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }
}
