import 'package:fb_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:fb_auth_bloc/blocs/profile/profile_cubit.dart';
import 'package:fb_auth_bloc/blocs/profile/profile_state.dart';
import 'package:fb_auth_bloc/constants/db_constants.dart';
import 'package:fb_auth_bloc/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = "profile_page";
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() {
    final String uid = context.read<AuthBloc>().state.user!.uid;
    context.read<ProfileCubit>().getProfile(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profie Page"),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.profileStatus == ProfileStatus.error) {
            return errorDialog(
              context: context,
              error: state.error,
            );
          }
        },
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.initial) {
            return const Center();
          } else if (state.profileStatus == ProfileStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.profileStatus == ProfileStatus.error) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/error.png',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 20.0),
                  const Text(
                    'Ooops!\nTry again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: "assets/images/loading.gif",
                  image: state.user.profileImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("-id: ${state.user.id}", style: style),
                const SizedBox(
                  height: 10,
                ),
                Text("-name: ${state.user.name}", style: style),
                const SizedBox(
                  height: 10,
                ),
                Text("-point: ${state.user.point}", style: style),
                const SizedBox(
                  height: 10,
                ),
                Text("-rank: ${state.user.rank}", style: style),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
