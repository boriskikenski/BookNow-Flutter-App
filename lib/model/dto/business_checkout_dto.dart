import 'package:flutter/material.dart';

class BusinessCheckoutDTO {
  String name;
  double price;
  Map<DateTime, int> businessBookings;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  int minPerSlot;
  int numberOfSlots;

  BusinessCheckoutDTO(this.name, this.price, this.openingTime, this.closingTime,
      this.minPerSlot, this.numberOfSlots, this.businessBookings);
}
