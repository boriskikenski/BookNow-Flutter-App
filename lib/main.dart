import 'package:book_now/screens/create_business_screen.dart';
import 'package:book_now/screens/home_screen.dart';
import 'package:book_now/screens/initial_screen.dart';
import 'package:book_now/screens/login_screen.dart';
import 'package:book_now/screens/my_businesses_screen.dart';
import 'package:book_now/screens/profile_screen.dart';
import 'package:book_now/screens/register_screen.dart';
import 'package:book_now/screens/reservations_screen.dart';
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
        '/create-business/': (BuildContext context) => const CreateBusinessScreen(),
        '/profile/': (BuildContext context) => const ProfileScreen(),
        '/reservations/': (BuildContext context) => const ReservationsScreen(),
        '/my-businesses/': (BuildContext context) => const BusinessesScreen(),
      },
    );
  }
}
