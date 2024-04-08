import 'package:flutter/material.dart';

import './appointment.dart';
import './review.dart';
import './costumer.dart';
import './location.dart';
import './enumerations/business_types.dart';

class Business {
  String businessName;
  Costumer owner;
  Location location;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  Map<DateTime, List<Appointment>> appointments; //todo kreiraj za site dati do data za najdocna rezervacija i dovrshi go mesecot
  double reviewGrade;
  int reviewsSum;
  int reviewsCounter;
  Review review;
  BusinessTypes filter;
  String website;

  Business(this.businessName, this.owner, this.location, this.openingTime,
      this.closingTime, this.appointments, this.reviewGrade, this.reviewsSum,
      this.reviewsCounter, this.review, this.filter, this.website);

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'owner': owner.toMap(),
      'location': location.toMap(),
      'openingTime': '${openingTime.hour}:${openingTime.minute}',
      'closingTime': '${closingTime.hour}:${closingTime.minute}',
      'appointments': _convertAppointmentsToMap(),
      'reviewGrade': reviewGrade,
      'reviewsSum': reviewsSum,
      'reviewsCounter': reviewsCounter,
      'review': review != null ? review.toMap() : null,
      'filter': filter.toString(),
      'website': website,
    };
  }

  Map<String, dynamic> _convertAppointmentsToMap() {
    Map<String, dynamic> appointmentsMap = {};
    appointments.forEach((key, value) {
      appointmentsMap[key.toString()] = value.map((appointment) => appointment.toMap()).toList();
    });
    return appointmentsMap;
  }
}