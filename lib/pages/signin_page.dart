import 'package:fb_auth_bloc/blocs/signin/signin_cubit.dart';
import 'package:fb_auth_bloc/pages/signup_page.dart';
import 'package:fb_auth_bloc/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage extends StatefulWidget {
  static const String routeName = "signin_page";
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email;
  late String password;
  void submit() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    if (!_formKey.currentState!.validate()) return null;
    _formKey.currentState!.save();
    context.read<SigninCubit>().signin(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            if (state.signinStatus == SigninStatus.error) {
              return errorDialog(
                context: context,
                error: state.error,
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: autovalidateMode,
                    child: ListView(
                      children: [
                        Image.asset(
                          "assets/images/flutter_logo.png",
                          width: 250,
                          height: 250,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (String? input) {
                            if (input == null || input.trim().isEmpty) {
                              return "Email required";
                            }
                            return null;
                          },
                          onSaved: (String? input) {
                            email = input!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (String? input) {
                            if (input == null || input.trim().isEmpty) {
                              return "Password required";
                            }
                            return null;
                          },
                          onSaved: (String? input) {
                            password = input!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed:
                              state.signinStatus == SigninStatus.submitting
                                  ? null
                                  : submit,
                          child: state.signinStatus == SigninStatus.submitting
                              ? const Text("Loading...")
                              : const Text("Sign In"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed:
                              state.signinStatus == SigninStatus.submitting
                                  ? null
                                  : () {
                                      Navigator.pushNamed(
                                          context, SignupPage.routeName);
                                    },
                          child: const Text("Not a member? Sign Up!"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
