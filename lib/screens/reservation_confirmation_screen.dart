import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import '../components/qr_code_image.dart';

class ReservationConfirmationScreen extends StatefulWidget {
  const ReservationConfirmationScreen({super.key, required this.qrGenerationData});

  final String qrGenerationData;

  @override
  State<ReservationConfirmationScreen> createState() => _ReservationConfirmationScreenState();
}

class _ReservationConfirmationScreenState extends State<ReservationConfirmationScreen> {
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
      body: Column(
        children: [
          const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Text('Your reservation QR confirmation',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                  ),
              )
          ),
          Center(child: QRImage(widget.qrGenerationData)),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }
}
