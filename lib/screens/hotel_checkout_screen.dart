import 'package:book_now/model/dto/hotel_checkout_dto.dart';
import 'package:book_now/model/hotel.dart';
import 'package:book_now/screens/reservation_confirmation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_drawer.dart';
import '../model/room.dart';
import '../service/payment_service.dart';
import '../service/reservation_service.dart';

class HotelCheckoutScreen extends StatefulWidget {
  final HotelCheckoutDTO hotel;

  const HotelCheckoutScreen({super.key, required this.hotel});

  @override
  State<HotelCheckoutScreen> createState() => _HotelCheckoutScreenState();
}

class _HotelCheckoutScreenState extends State<HotelCheckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? paymentIntent;
  int _selectedRoomCapacity = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final List<DateTime> _selectedDates = [];
  bool _canCheckout = false;

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedRoomCapacity == 0)
              Padding(
                padding: const EdgeInsets.only(top: 70.0, left: 40.0, right: 40.0),
                child: DropdownButton<Room>(
                  hint: const Text('Select Room Type'),
                  onChanged: (Room? newValue) {
                    setState(() {
                      _selectedRoomCapacity = newValue!.capacity;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  iconEnabledColor: Colors.black,
                  isExpanded: true,
                  items: widget.hotel.rooms.map<DropdownMenuItem<Room>>((Room value) {
                    return DropdownMenuItem<Room>(
                        value: value,
                        child: Text('${value.capacity} bed room')
                    );
                  }).toList(),
                ),
              ),
            if (_selectedRoomCapacity > 0)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selected Business: ${widget.hotel.name}, Room capacity: $_selectedRoomCapacity', //TODO stavi price
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
                    selectedDayPredicate: (day) {
                      if (_selectedDates.length == 2) {
                        return day.isAfter(_selectedDates[0]) && day.isBefore(_selectedDates[1]) ||
                            day.isAtSameMomentAs(_selectedDates[0]) || day.isAtSameMomentAs(_selectedDates[1]);
                      } else {
                        return _selectedDates.contains(day);
                      }
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        if (_selectedDates.length == 2) {
                          _selectedDates.clear();
                          _canCheckout = false;
                        }
                        _selectedDates.add(selectedDay);
                        _selectedDates.sort((a, b) => a.compareTo(b));
                        if (_selectedDates.length == 2) {
                          _canCheckout = _isSelectedRangeAvailable();
                        }
                      });
                    },
                  ),
                  if (_selectedDates.isNotEmpty && _canCheckout)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'Selected dates are available',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10.0),
                          child: ElevatedButton(
                            child: const Text('BookNow'),
                            onPressed: () async {
                              try {
                                Hotel? hotel = await Hotel.findByName(widget.hotel.name);
                                Map<int, Map<DateTime, int>> updatedBookings = widget.hotel.bookings;
                                DateTime start = _selectedDates[0];
                                DateTime end = _selectedDates[1].add(const Duration(days: 1));

                                PaymentService paymentService = PaymentService();
                                await paymentService.makePayment(context, paymentIntent, _calculateBill());

                                Map<DateTime, int> dateAvailability = {};
                                if (!updatedBookings.containsKey(_selectedRoomCapacity)) {
                                  for (DateTime date = start; date.isBefore(end); date = date.add(const Duration(days: 1))) {
                                    dateAvailability[date] = _getSelectedRoom(_selectedRoomCapacity)!.numberOfUnits - 1;
                                    updatedBookings[_selectedRoomCapacity] = dateAvailability;
                                  }
                                } else {
                                  for (DateTime date = start; date.isBefore(end); date = date.add(const Duration(days: 1))) {
                                    if (!updatedBookings[_selectedRoomCapacity]!.containsKey(date)) {
                                      dateAvailability[date] = _getSelectedRoom(_selectedRoomCapacity)!.numberOfUnits - 1;
                                      updatedBookings[_selectedRoomCapacity] = dateAvailability;
                                    } else {
                                      updatedBookings[_selectedRoomCapacity]![date] = updatedBookings[_selectedRoomCapacity]![date] !- 1;
                                    }
                                  }
                                }
                                await hotel!.updateBookings(updatedBookings);

                                String? currentCostumerEmail = FirebaseAuth.instance.currentUser?.email;
                                String qrGenerationData = await ReservationService.createHotelReservation(
                                    currentCostumerEmail!,
                                    widget.hotel.name,
                                    _selectedDates[0],
                                    _selectedDates[1],
                                    _selectedRoomCapacity
                                );

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReservationConfirmationScreen(qrGenerationData: qrGenerationData),
                                    )
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
                          ),
                        )
                      ],
                    ),
                  if (_selectedDates.isNotEmpty && !_canCheckout) //todo prikazhi info deka za izbranoto vreme ne e slobodno, mozhe i da se napisht koi denovi ne e slobodno
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Selected Dates: ${_selectedDates[0].toString()} - ${_selectedDates[_selectedDates.length - 1].toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }

  bool _isSelectedRangeAvailable () {
    bool isRangeAvailable = true;
    DateTime start = _selectedDates[0];
    DateTime end = _selectedDates[1].add(const Duration(days: 1));
    Map<int, Map<DateTime, int>> bookings = widget.hotel.bookings;

    if (bookings.containsKey(_selectedRoomCapacity)) {
      for (DateTime date = start; date.isBefore(end); date = date.add(const Duration(days: 1))) {
        if (bookings[_selectedRoomCapacity]!.containsKey(date)) {
          if (bookings[_selectedRoomCapacity]![date] == 0) {
            isRangeAvailable = false;
          }
        }
      }
    }
    return isRangeAvailable;
  }

  Room? _getSelectedRoom (int roomCapacity) {
    Room? selectedRoom;
    List<Room> allRooms = widget.hotel.rooms;
    for (int i = 0; i < allRooms.length; i++) {
      Room room = allRooms[i];
      if (room.capacity == roomCapacity) {
        selectedRoom = room;
      }
    }
    return selectedRoom;
  }

  int _calculateBill() {
    int pricePerNight = _getSelectedRoom(_selectedRoomCapacity)!.pricePerNight.toInt();
    int nights = _selectedDates[1].difference(_selectedDates[0]).inDays + 1;
    return nights * pricePerNight;
  }
}
