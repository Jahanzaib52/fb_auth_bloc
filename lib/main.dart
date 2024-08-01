import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:fb_auth_bloc/blocs/profile/profile_cubit.dart';
import 'package:fb_auth_bloc/blocs/signin/signin_cubit.dart';
import 'package:fb_auth_bloc/blocs/signup/signup_cubit.dart';
import 'package:fb_auth_bloc/firebase_options.dart';
import 'package:fb_auth_bloc/pages/home_page.dart';
import 'package:fb_auth_bloc/pages/signin_page.dart';
import 'package:fb_auth_bloc/pages/signup_page.dart';
import 'package:fb_auth_bloc/pages/splash_page.dart';
import 'package:fb_auth_bloc/repositories/auth_repository.dart';
import 'package:fb_auth_bloc/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            firebaseServices: FirebaseServices(
              firebaseAuth: FirebaseAuth.instance,
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseStorage: FirebaseStorage.instance,
            ),
          ),
        ),
        // RepositoryProvider(
        //   create: (context) => SubjectRepository(),
        // ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SigninCubit>(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Firebase Auth',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            // useMaterial3: true,
          ),
          home: const SplashPage(),
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            SigninPage.routeName: (context) => const SigninPage(),
            SignupPage.routeName: (context) => const SignupPage(),
          },
        ),
      ),
    );
  }
}
