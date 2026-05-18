import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/utils/firebase_error_handler.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:chat_app/core/utils/validators.dart';
import 'package:chat_app/core/widgets/app_button.dart';
import 'package:chat_app/core/widgets/app_rich_text.dart';
import 'package:chat_app/core/widgets/app_text_field.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (!_formKey.currentState!.validate()) {
        return;
      }

      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, Routes.mainScreen);
    } catch (e) {
      String errorMessage = FirebaseErrorHandler.getMessage(e.toString());

      showSnackBar(context, errorMessage);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,

          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Lottie.asset(
                    "assets/icons/Welcoming.json",
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20,),
                  Text("Welcome Back! Sign in to continue your journey.", style: AppTextStyles.messageText,),
                  SizedBox(height: 40),
                  AppTextField(
                    controller: emailController,
              
                    hintText: "Email",
              
                    keyboardType: TextInputType.emailAddress,
              
                    validator: Validators.email,
                  ),
              
                  const SizedBox(height: 20),
              
                  AppTextField(
                    controller: passwordController,
              
                    hintText: "Password",
              
                    obscureText: true,
              
                    validator: Validators.password,
                  ),
              
                  const SizedBox(height: 20),
              
                  AppButton(onPressed: login, text: "Sign In", isLoading: isLoading),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.registerScreen,
                    ),
                    child: AppRichText(
                      coloredText: 'Sign Up',
                      coloredTextStyle: AppTextStyles.primaryAction,
                      normalText: 'Don\'t have an account? ',
                      normalTextStyle: AppTextStyles.messageText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
