import 'package:fb_auth_bloc/blocs/profile/profile_state.dart';
import 'package:fb_auth_bloc/models/custom_error.dart';
import 'package:fb_auth_bloc/models/user_model.dart';
import 'package:fb_auth_bloc/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;
  ProfileCubit({required this.authRepository}) : super(ProfileState.initial());
  Future<void> getProfile({required String uid}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      final CustomUser user = await authRepository.getProfile(uid: uid);
      emit(state.copyWith(profileStatus: ProfileStatus.loaded, user: user));
    } on CustomError catch (e) {
      emit(state.copyWith(profileStatus: ProfileStatus.error, error: e));
    }
  }
}
