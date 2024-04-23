import 'package:flutter/material.dart';
import 'package:book_now/model/enumerations/business_types.dart';

class BusinessCheckoutDTO {
  String name;
  double price;
  Map<DateTime, int> businessBookings;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  int minPerSlot;
  int numberOfSlots;
  BusinessTypes businessType;

  BusinessCheckoutDTO(this.name, this.price, this.openingTime, this.closingTime,
      this.minPerSlot, this.numberOfSlots, this.businessBookings, this.businessType);
}
