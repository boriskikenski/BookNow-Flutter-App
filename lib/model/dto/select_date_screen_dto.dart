import 'package:flutter/material.dart';

class SelectDateScreenDTO {
  String name;
  double price;
  Map<DateTime, int>? businessBookings;
  Map<DateTime, Map<int, int>>? hotelBookings;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  int minPerSlot;
  int numberOfSlots;

  SelectDateScreenDTO({required this.name, required this.price,
    required this.openingTime, required this.closingTime, required this.minPerSlot,
    required this.numberOfSlots, this.businessBookings, this.hotelBookings});
}
