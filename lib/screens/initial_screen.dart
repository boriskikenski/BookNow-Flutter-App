import 'package:book_now/screens/home_screen.dart';
import 'package:book_now/screens/login_screen.dart';
import 'package:book_now/screens/verify_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              if (user.emailVerified) {
                return const HomeScreen();
              } else {
                return const VerifyEmailScreen();
              }
            } else {
              return const LoginScreen();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
