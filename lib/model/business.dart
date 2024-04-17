import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './exception/business_already_exists_exception.dart';
import './appointment.dart';
import './review.dart';
import './location.dart';
import './enumerations/business_types.dart';

class Business {
  String businessName;
  String ownerEmail;
  Location location;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  Appointment appointment;
  Map<DateTime, int> bookings;
  /*
  Map<DateTime, counter>
  -> counter--, counter is numberOfSlots
  -> mozhni DateTime soodvetno od Appointment i openingTime kje bidat def na FE
  * */
  double reviewGrade;
  int reviewsSum;
  int reviewsCounter;
  List<Review> reviews;
  BusinessTypes filter;
  String website;
  String encodedImage;

  Business(this.businessName, this.ownerEmail, this.location, this.openingTime,
      this.closingTime, this.appointment, this.bookings, this.reviewGrade,
      this.reviewsSum, this.reviewsCounter, this.reviews, this.filter,
      this.website, this.encodedImage);

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'ownerEmail': ownerEmail,
      'location': location.toMap(),
      'openingTime': '${openingTime.hour}:${openingTime.minute}',
      'closingTime': '${closingTime.hour}:${closingTime.minute}',
      'appointment': appointment.toMap(),
      'bookings': _convertDateTimeKeysToString(bookings),
      'reviewGrade': reviewGrade,
      'reviewsSum': reviewsSum,
      'reviewsCounter': reviewsCounter,
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'filter': filter.toString(),
      'website': website,
      'encodedImage': encodedImage,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      map['businessName'],
      map['ownerEmail'],
      Location.fromMap(map['location']),
      TimeOfDay(
        hour: int.parse(map['openingTime'].split(':')[0]),
        minute: int.parse(map['openingTime'].split(':')[1]),
      ),
      TimeOfDay(
        hour: int.parse(map['closingTime'].split(':')[0]),
        minute: int.parse(map['closingTime'].split(':')[1]),
      ),
      Appointment.fromMap(map['appointment']),
      _convertStringKeysToDateTime(Map<String, int>.from(map['bookings'])),
      map['reviewGrade'],
      map['reviewsSum'],
      map['reviewsCounter'],
      (map['reviews'] as List<dynamic>).map((review) => Review.fromMap(review)).toList(),
      BusinessTypes.values.firstWhere((e) => e.toString() == map['filter']),
      map['website'],
      map['encodedImage'],
    );
  }

  Future<void> saveBusiness() async {
    final isExistingBusiness = await findByName(businessName);
    if (isExistingBusiness != null) {
      throw BusinessAlreadyExistException();
    }
    await FirebaseFirestore.instance.collection('businesses').doc(businessName).set(toMap());
  }

  static Future<List<Business>> fetchAllBusinesses() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('businesses')
        .get();

    final List<Business> businesses = querySnapshot.docs.map((doc) {
      final businessData = doc.data();
      return Business.fromMap(businessData);
    }).toList();

    return businesses;
  }

  static Future<Business?> findByName(String businessName) async {
    final businessSnapshot = await FirebaseFirestore.instance
        .collection('businesses')
        .doc(businessName)
        .get();

    if (businessSnapshot.exists) {
      final businessData = businessSnapshot.data();
      if (businessData != null) {
        return Business.fromMap(businessData);
      }
    }
    return null;
  }

  Future<void> updateBookings(Map<DateTime, int> updatedBookings) async {
    Map<String, int> bookingsStringKeys = _convertDateTimeKeysToString(updatedBookings);
    await FirebaseFirestore.instance
        .collection('businesses')
        .doc(businessName)
        .update({'bookings': bookingsStringKeys});
  }

  static Map<String, int> _convertDateTimeKeysToString(Map<DateTime, int> dateTimeMap) {
    Map<String, int> stringKeysMap = {};
    dateTimeMap.forEach((key, value) {
      stringKeysMap[key.toIso8601String()] = value;
    });
    return stringKeysMap;
  }

  static Map<DateTime, int> _convertStringKeysToDateTime(Map<String, int> stringKeysMap) {
    Map<DateTime, int> dateTimeMap = {};
    stringKeysMap.forEach((key, value) {
      dateTimeMap[DateTime.parse(key)] = value;
    });
    return dateTimeMap;
  }
}
