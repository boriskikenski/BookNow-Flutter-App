import 'package:book_now/components/custom_drawer.dart';
import 'package:book_now/model/dto/reservation_dto.dart';
import 'package:book_now/screens/reservation_confirmation_screen.dart';
import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';

class ReservationsScreen extends StatefulWidget {
  final List<ReservationDTO> reservations;

  const ReservationsScreen({super.key, required this.reservations});

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 15, bottom: 15),
            child: Text(
              'Reservations:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.reservations.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: const Color.fromRGBO(255, 228, 0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '${widget.reservations[index].businessName} - '
                              '${widget.reservations[index].when.day}.${widget.reservations[index].when.month}.${widget.reservations[index].when.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReservationConfirmationScreen(qrGenerationData: widget.reservations[index].qrGenerationString)),
                                  );
                            },
                            child: const Text('Show QR verification code')),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }
}
