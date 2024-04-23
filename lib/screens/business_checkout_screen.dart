import 'package:book_now/model/business.dart';
import 'package:book_now/screens/reservation_confirmation_screen.dart';
import 'package:book_now/service/reservation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import 'package:book_now/model/dto/business_checkout_dto.dart';

import '../service/payment_service.dart';

class BusinessCheckoutScreen extends StatefulWidget {
  final BusinessCheckoutDTO business;

  const BusinessCheckoutScreen({super.key, required this.business});

  @override
  State<BusinessCheckoutScreen> createState() => _BusinessCheckoutScreenState();
}

class _BusinessCheckoutScreenState extends State<BusinessCheckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? paymentIntent;

  CalendarFormat _calendarFormat = CalendarFormat.month;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected Business: ${widget.business.name}, Price: ${widget.business.price}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                _showTimeSlotBottomSheet(selectedDay, getAvailableAppointments(selectedDay, widget.business));
              },
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }

  void _showTimeSlotBottomSheet(DateTime selectedDay, List<DateTime> availableAppointments) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Available appointments for: ${selectedDay.day}.${selectedDay.month}.${selectedDay.year}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: availableAppointments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final appointmentTime = availableAppointments[index];
                    return _buildAppointmentRow(appointmentTime);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentRow(DateTime appointmentTime) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 35.0),
            child: Text(
              '${appointmentTime.hour}:${appointmentTime.minute}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
            onPressed: () async {
              try {
                PaymentService paymentService = PaymentService();
                await paymentService.makePayment(context, paymentIntent, widget.business.price.toInt());
                Business? business = await Business.findByName(widget.business.name);
                Map<DateTime, int> updatedBookings = widget.business.businessBookings;
                if (updatedBookings.containsKey(appointmentTime)){
                  updatedBookings[appointmentTime] = updatedBookings[appointmentTime] !- 1;
                } else {
                  updatedBookings[appointmentTime] = widget.business.numberOfSlots - 1;
                }
                await business!.updateBookings(updatedBookings);
                String? currentCostumerEmail = FirebaseAuth.instance.currentUser?.email;
                String qrGenerationData = await ReservationService.createReservation(
                    currentCostumerEmail!,
                    widget.business.name,
                    appointmentTime
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationConfirmationScreen(qrGenerationData: qrGenerationData),
                  ),
                );
                showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              Text("Successful booking"),
                            ],
                          ),
                        ],
                      ),
                    )
                );
              } catch (e) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              Text("Canceled"),
                            ],
                          ),
                        ],
                      ),
                    )
                );
                return;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('BookNow'),
            ),
          ),
        ),
      ],
    );
  }

  List<DateTime> getAvailableAppointments(DateTime selectedDay, BusinessCheckoutDTO businessData) {
    List<DateTime> appointments = [];

    DateTime openingTime = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, businessData.openingTime.hour, businessData.openingTime.minute);
    DateTime closingTime = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, businessData.closingTime.hour, businessData.closingTime.minute);

    DateTime workingTime = openingTime;
    while (workingTime.isBefore(closingTime)) {
      if (!businessData.businessBookings.containsKey(workingTime)) {
        appointments.add(workingTime);
      } else if (businessData.businessBookings.containsKey(workingTime) && businessData.businessBookings[workingTime]! > 0){
        appointments.add(workingTime);
      }
      workingTime = workingTime.add(Duration(minutes: businessData.minPerSlot));
    }

    return appointments;
  }
}
