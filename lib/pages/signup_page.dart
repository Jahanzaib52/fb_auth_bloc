import 'dart:io';

import 'package:fb_auth_bloc/blocs/signup/signup_cubit.dart';
import 'package:fb_auth_bloc/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/error_dialog.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = "signup_page";
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String name;
  late String email;
  late String password;
  late final TextEditingController passwordController = TextEditingController();
  XFile? image;
  Future<void> getImage() async {
    final ImagePicker imagePicker = ImagePicker();
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void submit() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    if (image == null && _formKey.currentState!.validate() == false) return null;
    _formKey.currentState!.save();
    context
        .read<SignupCubit>()
        .signup(
          name: name,
          email: email,
          password: password,
          image: image,
        )
        .whenComplete(
          () => image = null,
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.signupStatus == SignupStatus.error) {
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
                        GestureDetector(
                          onTap: state.signupStatus == SignupStatus.submitting
                              ? null
                              : getImage,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.blueGrey.shade200,
                            backgroundImage: image == null
                                ? null
                                : FileImage(File(image!.path)),
                            // child: image == null
                            //     ? Image.asset("assets/images/flutter_logo.png")
                            //     : null,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: "Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (String? input) {
                            if (input == null || input.trim().isEmpty) {
                              return "Name required";
                            }
                            return null;
                          },
                          onSaved: (String? input) {
                            name = input!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
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
                          controller: passwordController,
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
                            } else if (input.trim().length < 6) {
                              return "Password must be atleast 6 charater long";
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
                        TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: "Confirm Password",
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (String? input) {
                            if (passwordController.text != input) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          // onSaved: (String? input) {
                          //   passwordController.text = input!;
                          // },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed:
                              state.signupStatus == SignupStatus.submitting
                                  ? null
                                  : submit,
                          child: state.signupStatus == SignupStatus.submitting
                              ? const Text("Loading...")
                              : const Text("Sign Up"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed:
                              state.signupStatus == SignupStatus.submitting
                                  ? null
                                  : () {
                                      Navigator.pushNamed(
                                          context, SigninPage.routeName);
                                    },
                          child: const Text("Already a member? Sign In!"),
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
