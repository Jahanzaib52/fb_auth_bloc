import 'package:equatable/equatable.dart';
import 'package:fb_auth_bloc/models/custom_error.dart';
import 'package:fb_auth_bloc/models/user_model.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final CustomUser user;
  final CustomError error;
  const ProfileState({
    required this.profileStatus,
    required this.user,
    required this.error,
  });
  factory ProfileState.initial() {
    return ProfileState(
      profileStatus: ProfileStatus.initial,
      user: CustomUser.initial(),
      error: const CustomError(),
    );
  }
  @override
  List<Object> get props => [profileStatus, user, error];
  ProfileState copyWith({
    ProfileStatus? profileStatus,
    CustomUser? user,
    CustomError? error,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
