import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './location.dart';
import './review.dart';
import './room.dart';
import './enumerations/business_types.dart';
import 'exception/business_already_exists_exception.dart';

class Hotel {
  String hotelName;
  String ownerEmail;
  Location location;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  List<Room> rooms;
  Map<int, Map<DateTime, int>> bookings;
  double reviewGrade;
  int reviewsSum;
  int reviewsCounter;
  List<Review> reviews;
  BusinessTypes filter;
  String website;
  String encodedImage;

  Hotel(this.hotelName, this.ownerEmail, this.location, this.openingTime,
      this.closingTime, this.rooms, this.bookings, this.reviewGrade,
      this.reviewsSum, this.reviewsCounter, this.reviews, this.filter,
      this.website, this.encodedImage);

  Map<String, dynamic> toMap() {
    return {
      'hotelName': hotelName,
      'ownerEmail': ownerEmail,
      'location': location.toMap(),
      'openingTime': '${openingTime.hour}:${openingTime.minute}',
      'closingTime': '${closingTime.hour}:${closingTime.minute}',
      'rooms': rooms.map((room) => room.toMap()).toList(),
      'bookings': _bookingsToString(bookings),
      'reviewGrade': reviewGrade,
      'reviewsSum': reviewsSum,
      'reviewsCounter': reviewsCounter,
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'filter': filter.toString(),
      'website': website,
      'encodedImage': encodedImage,
    };
  }

  static Hotel fromMap(Map<String, dynamic> map) {
    return Hotel(
      map['hotelName'],
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
      (map['rooms'] as List<dynamic>).map((room) => Room.fromMap(room)).toList(),
      _stringToBookings(map['bookings']),
      map['reviewGrade'],
      map['reviewsSum'],
      map['reviewsCounter'],
      (map['reviews'] as List<dynamic>).map((review) => Review.fromMap(review)).toList(),
      BusinessTypes.values.firstWhere((e) => e.toString() == map['filter']),
      map['website'],
      map['encodedImage'],
    );
  }

  Future<void> saveHotel() async {
    final isExistingHotel = await findByName(hotelName);
    if (isExistingHotel != null) {
      throw BusinessAlreadyExistException();
    }
    await FirebaseFirestore.instance.collection('hotels').doc(hotelName).set(toMap());
  }

  static Future<List<Hotel>> fetchAllHotels() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('hotels')
        .get();

    final List<Hotel> hotels = querySnapshot.docs.map((doc) {
      final hotelData = doc.data();
      return Hotel.fromMap(hotelData);
    }).toList();

    return hotels;
  }

  static Future<Hotel?> findByName(String hotelName) async {
    final hotelSnapshot = await FirebaseFirestore.instance
        .collection('hotels')
        .doc(hotelName)
        .get();

    if (hotelSnapshot.exists) {
      final hotelData = hotelSnapshot.data();
      if (hotelData != null) {
        return Hotel.fromMap(hotelData);
      }
    }
    return null;
  }

  Future<void> updateBookings(Map<int, Map<DateTime, int>> updatedBookings) async {
    String bookingsStringKeys = _bookingsToString(updatedBookings);
    await FirebaseFirestore.instance
        .collection('hotels')
        .doc(hotelName)
        .update({'bookings': bookingsStringKeys});
  }

  String _bookingsToString(Map<int, Map<DateTime, int>> bookings) {
    List<Map<String, dynamic>> jsonList = [];
    bookings.forEach((roomCapacity, dateMap) {
      List<Map<String, dynamic>> roomList = [];
      dateMap.forEach((roomDate, availableUnits) {
        roomList.add({
          "date": roomDate.toIso8601String(),
          "availableUnits": availableUnits,
        });
      });
      jsonList.add({
        "roomCapacity": roomCapacity,
        "roomsMap": roomList,
      });
    });
    return jsonEncode(jsonList);
  }

  static Map<int, Map<DateTime, int>> _stringToBookings(String json) {
    List<dynamic> jsonList = jsonDecode(json);
    Map<int, Map<DateTime, int>> bookings = {};
    jsonList.forEach((entry) {
      int roomCapacity = entry['roomCapacity'];
      List<dynamic> roomList = entry['roomsMap'];
      Map<DateTime, int> dateMap = {};
      roomList.forEach((roomEntry) {
        DateTime date = DateTime.parse(roomEntry['date']);
        int availableUnits = roomEntry['availableUnits'];
        dateMap[date] = availableUnits;
      });
      bookings[roomCapacity] = dateMap;
    });
    return bookings;
  }
}
