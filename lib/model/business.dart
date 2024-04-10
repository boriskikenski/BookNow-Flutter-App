import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './exception/business_already_exists_exception.dart';
import './appointment.dart';
import './review.dart';
import './location.dart';
import './enumerations/business_types.dart';

class Business {
  String businessName;
  String ownerEmail; // TODO ova neka bide samo mail, zachuvaj novokreiran biznis vo listata na strana na Costumer
  Location location;
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  Map<DateTime, List<Appointment>> appointments; //todo kreiraj za site dati do data za najdocna rezervacija i dovrshi go mesecot
  double reviewGrade;
  int reviewsSum;
  int reviewsCounter;
  List<Review> reviews;
  BusinessTypes filter;
  String website;
  String encodedImage;

  Business(this.businessName, this.ownerEmail, this.location, this.openingTime,
      this.closingTime, this.appointments, this.reviewGrade, this.reviewsSum,
      this.reviewsCounter, this.reviews, this.filter, this.website, this.encodedImage);

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'ownerEmail': ownerEmail,
      'location': location.toMap(),
      'openingTime': '${openingTime.hour}:${openingTime.minute}',
      'closingTime': '${closingTime.hour}:${closingTime.minute}',
      'appointments': _convertAppointmentsToMap(),
      'reviewGrade': reviewGrade,
      'reviewsSum': reviewsSum,
      'reviewsCounter': reviewsCounter,
      'reviews': reviews.map((review) => review.toMap()).toList(),
      'filter': filter.toString(),
      'website': website,
      'encodedImage': encodedImage,
    };
  }

  Map<String, dynamic> _convertAppointmentsToMap() {
    Map<String, dynamic> appointmentsMap = {};
    appointments.forEach((key, value) {
      appointmentsMap[key.toString()] = value.map((appointment) => appointment.toMap()).toList();
    });
    return appointmentsMap;
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
      _convertMapToAppointments(map['appointments']),
      map['reviewGrade'],
      map['reviewsSum'],
      map['reviewsCounter'],
      (map['reviews'] as List<dynamic>).map((review) => Review.fromMap(review)).toList(),
      BusinessTypes.values.firstWhere((e) => e.toString() == map['filter']),
      map['website'],
      map['encodedImage'],
    );
  }

  static Map<DateTime, List<Appointment>> _convertMapToAppointments(Map<String, dynamic> map) {
    Map<DateTime, List<Appointment>> appointmentsMap = {};
    map.forEach((key, value) {
      appointmentsMap[DateTime.parse(key)] = (value as List<dynamic>).map((e) => Appointment.fromMap(e)).toList();
    });
    return appointmentsMap;
  }

  Future<void> saveBusiness() async {
    final isExistingBusiness = await findByName(businessName);
    if (isExistingBusiness != null) {
      throw BusinessAlreadyExistException();
    }
    await FirebaseFirestore.instance.collection('businesses').doc(businessName).set(toMap());
  }

  Future<Business?> findByName(String businessName) async {
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
}