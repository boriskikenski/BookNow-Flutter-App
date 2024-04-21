import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';

class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen({super.key});

  @override
  State<ReservationDetailsScreen> createState() => _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
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
      body: Center(
          child: const Text('Reservation Details screen - TO BE IMPLEMENTED')
      ),
      drawer: const CustomDrawer(),
    );
  }
}
