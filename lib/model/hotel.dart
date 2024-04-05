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
}