import 'package:flutter/material.dart';

import '../room.dart';

class HotelCheckoutDTO {
  String name;
  List<Room> rooms;
  Map<int, Map<DateTime, int>> bookings;
  TimeOfDay openingTime;
  TimeOfDay closingTime;

  HotelCheckoutDTO(this.name, this.rooms, this.bookings, this.openingTime,
      this.closingTime);
}