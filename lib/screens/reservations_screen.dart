import 'package:book_now/components/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
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
            Text('Reservations Screen')
          ),
        ),
      drawer: const CustomDrawer(),
    );
  }
}
