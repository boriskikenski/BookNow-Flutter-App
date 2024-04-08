import 'package:cloud_firestore/cloud_firestore.dart';
import './hotel.dart';
import './business.dart';
import './reservation.dart';

class Costumer {
  String fullName;
  String username;
  String email;
  List<Hotel> hotels;
  List<Business> business;
  List<Reservation> reservationList;

  Costumer(this.fullName, this.username, this.email, this.hotels, this.business,
      this.reservationList);

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'hotels': hotels.map((hotel) => hotel.toMap()).toList(),
      'business': business.map((business) => business.toMap()).toList(),
      'reservationList': [], //TODO tobe implemented
    };
  }

  Future<void> saveCostumer() async {
    await FirebaseFirestore.instance.collection('customers').doc(email).set(toMap());
  }
}