import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String qrGenerationString;
  String reservationOwnerFullName;
  String businessName;
  String businessOwnerEmail;
  DateTime when;

  Reservation(this.qrGenerationString, this.reservationOwnerFullName,
      this.businessName, this.businessOwnerEmail,this.when);

  Map<String, dynamic> toMap() {
    return {
      'qrGenerationString': qrGenerationString,
      'reservationOwnerFullName': reservationOwnerFullName,
      'businessName': businessName,
      'businessOwnerEmail': businessOwnerEmail,
      'when': when.toIso8601String(),
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      map['qrGenerationString'],
      map['reservationOwnerFullName'],
      map['businessName'],
      map['businessOwnerEmail'],
      DateTime.parse(map['when']),
    );
  }

  Future<void> saveReservation() async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(qrGenerationString)
        .set(toMap());
  }
}
