import 'package:flutter/material.dart';

import './costumer.dart';
import './location.dart';
import './review.dart';
import './room.dart';
import './enumerations/business_types.dart';

class Hotel {
  String businessName;
  Costumer owner;
  Location location;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  Map<DateTime, List<Room>> rooms;
  double reviewGrade;
  int reviewsSum;
  int reviewsCounter;
  Review review;
  BusinessTypes filter;
  String website;

  Hotel(this.businessName, this.owner, this.location, this.openingTime,
      this.closingTime, this.rooms, this.reviewGrade, this.reviewsSum,
      this.reviewsCounter, this.review, this.filter, this.website);

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'owner': owner.toMap(),
      'location': location.toMap(),
      'openingTime': '${openingTime.hour}:${openingTime.minute}',
      'closingTime': '${closingTime.hour}:${closingTime.minute}',
      'rooms': _convertRoomsToMap(),
      'reviewGrade': reviewGrade,
      'reviewsSum': reviewsSum,
      'reviewsCounter': reviewsCounter,
      'review': review != null ? review.toMap() : null,
      'filter': filter.toString(),
      'website': website,
    };
  }

  Map<String, dynamic> _convertRoomsToMap() {
    Map<String, dynamic> roomsMap = {};
    rooms.forEach((key, value) {
      roomsMap[key.toString()] = value.map((room) => room.toMap()).toList();
    });
    return roomsMap;
  }
}