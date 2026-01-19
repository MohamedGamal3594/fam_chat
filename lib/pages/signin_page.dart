import 'package:chat_app/utilities/app_colors.dart';
import 'package:chat_app/utilities/constants.dart';
import 'package:chat_app/utilities/extensions/show_snackbar.dart';
import 'package:chat_app/utilities/services/auth_service.dart';
import 'package:chat_app/utilities/validators.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/user_notes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const .symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    const CircleAvatar(
                      backgroundImage: AssetImage(AppConstants.appLogoPath),
                      radius: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      AppConstants.appTitle,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: .bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 64),
                    const Align(
                      alignment: .centerLeft,
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 30, color: AppColors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Email',
                      controller: _emailController,
                      validator: Validators.emptyValidtor,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      labelText: 'Password',
                      controller: _passwordController,
                      validator: Validators.emptyValidtor,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await AuthService.instance
                                .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                            if (context.mounted) {
                              context.showSnackbar(
                                message: 'Sign in successful!',
                              );
                              context.go('/');
                            }
                          } catch (error) {
                            if (context.mounted) {
                              context.showSnackbar(message: error.toString());
                            }
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      text: 'Sign In',
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: .bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/register');
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const UserNotes(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
