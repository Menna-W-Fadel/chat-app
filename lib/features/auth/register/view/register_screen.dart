import 'package:chat_app/core/resources/app_text_styles.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/utils/validators.dart';
import 'package:chat_app/core/widgets/app_button.dart';
import 'package:chat_app/core/widgets/app_text_field.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (!_formKey.currentState!.validate()) {
        return;
      }
      await _authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginScreen,
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Lottie.asset(
                    "assets/icons/Share.json",
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20,),
                  Text("Hi there! Sign up to connect with friends.", style: AppTextStyles.messageText,),
                  SizedBox(height: 40),
                AppTextField(
                  controller: nameController,
            
                  hintText: "Name",
            
                  validator: Validators.requiredField,
                ),
            
                const SizedBox(height: 20),
            
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
                AppButton(
                  onPressed: register,
            
                  text: "Sign Up",
            
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
