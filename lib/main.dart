import 'package:chat_app/core/routes/chat_arguments.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/features/auth/login/view/login_screen.dart';
import 'package:chat_app/features/auth/register/view/register_screen.dart';
import 'package:chat_app/features/chat/view/chat_screen.dart';
import 'package:chat_app/features/home/view/home_screen.dart';
import 'package:chat_app/features/home/view/main_screen.dart';
import 'package:chat_app/features/home/view/settings_screen.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/splash_screen/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        Routes.splashScreen: (context) => const SplashScreen(),

        Routes.homeScreen: (context) => const HomeScreen(),

        Routes.loginScreen: (context) => const LoginScreen(),

        Routes.registerScreen: (context) => const RegisterScreen(),

        Routes.mainScreen: (context) => const MainScreen(),

        Routes.settingsScreen: (context) => const SettingsScreen(),
      },

      onGenerateRoute: (settings) {
        // CHAT SCREEN
        if (settings.name == Routes.chatScreen) {
          final args = settings.arguments as ChatArguments;

          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              receiverId: args.receiverId,
              receiverName: args.receiverName,
            ),
          );
        }

        return null;
      },

      initialRoute: Routes.splashScreen,
    );
  }
}
