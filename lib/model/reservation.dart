import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String qrGenerationString;
  String reservationOwnerEmail;
  String businessName;
  String businessOwnerEmail;
  DateTime when;

  Reservation(this.qrGenerationString, this.reservationOwnerEmail,
      this.businessName, this.businessOwnerEmail,this.when);

  Map<String, dynamic> toMap() {
    return {
      'qrGenerationString': qrGenerationString,
      'reservationOwnerEmail': reservationOwnerEmail,
      'businessName': businessName,
      'businessOwnerEmail': businessOwnerEmail,
      'when': when.toIso8601String(),
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      map['qrGenerationString'],
      map['reservationOwnerEmail'],
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

  static Future<List<Reservation>> getAllReservationsForCostumer(String ownerEmail) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('reservationOwnerEmail', isEqualTo: ownerEmail)
        .get();

    return querySnapshot.docs.map((doc) => Reservation.fromMap(doc.data())).toList();
  }
}
