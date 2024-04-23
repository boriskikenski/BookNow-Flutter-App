import 'package:cloud_firestore/cloud_firestore.dart';

class HotelReservation {
  String qrGenerationString;
  String reservationOwnerFullName;
  String businessName;
  String businessOwnerEmail;
  DateTime startDate;
  DateTime endDate;
  int roomCapacity;

  HotelReservation(this.qrGenerationString, this.reservationOwnerFullName,
    this.businessName, this.businessOwnerEmail, this.startDate, this.endDate,
    this.roomCapacity);

  Map<String, dynamic> toMap() {
    return {
      'qrGenerationString': qrGenerationString,
      'reservationOwnerFullName': reservationOwnerFullName,
      'businessName': businessName,
      'businessOwnerEmail': businessOwnerEmail,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'roomCapacity': roomCapacity,
    };
  }

  static HotelReservation fromMap(Map<String, dynamic> map) {
    return HotelReservation(
      map['qrGenerationString'],
      map['reservationOwnerFullName'],
      map['businessName'],
      map['businessOwnerEmail'],
      DateTime.parse(map['startDate']),
      DateTime.parse(map['endDate']),
      map['roomCapacity'],
    );
  }

  Future<void> saveHotelReservation() async {
    await FirebaseFirestore.instance
        .collection('hotel-reservations')
        .doc(qrGenerationString)
        .set(toMap());
  }
}
