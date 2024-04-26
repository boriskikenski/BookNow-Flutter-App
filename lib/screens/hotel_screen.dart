import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';

class HotelScreen extends StatefulWidget {

  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
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
          child: const Text('Hotel screen - TO BE IMPLEMENTED')
      ),
      drawer: const CustomDrawer(),
    );
  }
}
