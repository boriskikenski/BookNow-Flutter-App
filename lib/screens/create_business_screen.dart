import 'package:book_now/components/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<CreateBusinessScreen> {
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
            Text('Create Business Screen')
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
