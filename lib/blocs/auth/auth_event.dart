part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthStateChangedEvent extends AuthEvent {
  final fb.User? user;
  const AuthStateChangedEvent({this.user});
  @override
  List<Object?> get props => [user];
}

class SignOutRequestedEvent extends AuthEvent {}
