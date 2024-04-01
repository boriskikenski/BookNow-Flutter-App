import 'package:book_now/screens/home_screen.dart';
import 'package:book_now/screens/initial_screen.dart';
import 'package:book_now/screens/login_screen.dart';
import 'package:book_now/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNow',
      home: const InitialScreen(),
      routes: {
        '/login/': (BuildContext context) => const LoginScreen(),
        '/register/': (BuildContext context) => const RegisterScreen(),
        '/home/': (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
