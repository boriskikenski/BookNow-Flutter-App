import 'package:book_now/components/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.yellow,
      appBar: CustomAppBar(
        title: 'BookNow',
        leadingOnPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: const Center(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 100.0),
            child:
            Text('Profile Screen')
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
