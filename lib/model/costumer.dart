import 'package:cloud_firestore/cloud_firestore.dart';

class Costumer {
  String fullName;
  String username;
  String email;
  List<String> hotelList;
  List<String> businessList;

  Costumer(this.fullName, this.username, this.email, this.hotelList,
      this.businessList);

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'hotelList': hotelList,
      'businessList': businessList,
    };
  }

  static Costumer fromMap(Map<String, dynamic> map) {
    return Costumer(
      map['fullName'],
      map['username'],
      map['email'],
      List<String>.from(map['hotelList']),
      List<String>.from(map['businessList']),
    );
  }

  Future<void> saveCostumer() async {
    await FirebaseFirestore.instance.collection('customers').doc(email).set(toMap());
  }

  static Future<Costumer?> findByEmail(String email) async {
    final costumerSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(email)
        .get();

    if (costumerSnapshot.exists) {
      final costumerData = costumerSnapshot.data();
      if (costumerData != null) {
        return Costumer.fromMap(costumerData);
      }
    }
    return null;
  }

  Future<void> addBusiness(String newBusiness) async {
    final customerRef = FirebaseFirestore.instance.collection('customers').doc(email);
    final customerDoc = await customerRef.get();

    if (customerDoc.exists) {
      final customerData = customerDoc.data();
      if (customerData != null) {
        final List<dynamic> existingBusinesses = customerData['businessList'];
        final updatedBusinessList = [...existingBusinesses, newBusiness];
        await customerRef.update({'businessList': updatedBusinessList});
      }
    }
  }

  Future<void> addHotel(String newHotel) async {
    final customerRef = FirebaseFirestore.instance.collection('customers').doc(email);
    final customerDoc = await customerRef.get();

    if (customerDoc.exists) {
      final customerData = customerDoc.data();
      if (customerData != null) {
        final List<dynamic> existingHotels = customerData['hotelList'];
        final updatedHotelList = [...existingHotels, newHotel];
        await customerRef.update({'hotelList': updatedHotelList});
      }
    }
  }
}