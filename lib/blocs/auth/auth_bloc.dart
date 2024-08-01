import 'dart:async';
import 'package:fb_auth_bloc/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late final StreamSubscription authSubscription;
  AuthBloc({required this.authRepository}) : super(AuthState.initial()) {
    authSubscription = authRepository.user.listen((fb.User? user) {
      add(AuthStateChangedEvent(user: user));
    });
    on<AuthStateChangedEvent>((event, emit) {
      if (event.user != null) {
        emit(state.copyWith(
          authStatus: AuthStatus.authenticated,
          user: event.user,
        ));
      } else {
        emit(state.copyWith(
          authStatus: AuthStatus.unAuthenticated,
          user: null,
        ));
      }
    });
    on<SignOutRequestedEvent>((event, emit) async {
      await authRepository.signout();
    });
  }
  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
