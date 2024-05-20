import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'enumerations/business_types.dart';

class Favourites {
  String userEmail;
  List<String> businessesFavourites;
  List<String> hotelsFavourites;

  Favourites(this.userEmail, this.businessesFavourites, this.hotelsFavourites);

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'businessesFavourites': businessesFavourites,
      'hotelsFavourites': hotelsFavourites,
    };
  }

  static Favourites fromMap(Map<String, dynamic> map) {
    return Favourites(
      map['userEmail'],
      List<String>.from(map['businessesFavourites']),
      List<String>.from(map['hotelsFavourites']),
    );
  }

  static Future<void> saveFavourite(String businessName, BusinessTypes businessType) async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    final favouritesSnapshot = await FirebaseFirestore.instance
        .collection('favourites')
        .doc(currentUserEmail)
        .get();

    if (!favouritesSnapshot.exists) {
      Favourites favourites;
      List<String> selectedFavourites = [];
      selectedFavourites.add(businessName);
      if (businessType == BusinessTypes.hotel) {
        favourites = Favourites(currentUserEmail!, [], selectedFavourites);
      } else {
        favourites = Favourites(currentUserEmail!, selectedFavourites, []);
      }

      await FirebaseFirestore.instance
          .collection('favourites')
          .doc(currentUserEmail)
          .set(favourites.toMap());
    } else {
      Favourites favourites = Favourites('', [], []);

      final favouritesData = favouritesSnapshot.data();
      if (favouritesData != null) {
        favourites = Favourites.fromMap(favouritesData);
      }

      if (businessType == BusinessTypes.hotel) {
        List<String> hotelsFavourites = favourites.hotelsFavourites;
        hotelsFavourites.add(businessName);
        await FirebaseFirestore.instance
            .collection('favourites')
            .doc(currentUserEmail)
            .update({'hotelsFavourites': hotelsFavourites});
      } else {
        List<String> businessesFavourites = favourites.businessesFavourites;
        businessesFavourites.add(businessName);
        await FirebaseFirestore.instance
            .collection('favourites')
            .doc(currentUserEmail)
            .update({'businessesFavourites': businessesFavourites});
      }
    }
  }

  static Future<Favourites?> findByUserEmail(String userEmail) async {
    final favouritesSnapshot = await FirebaseFirestore.instance
        .collection('favourites')
        .doc(userEmail)
        .get();

    if (favouritesSnapshot.exists) {
      final favouritesData = favouritesSnapshot.data();
      if (favouritesData != null) {
        return Favourites.fromMap(favouritesData);
      }
    }
    return null;
  }

  static Future<void> deleteFavourite(String businessName, BusinessTypes businessType) async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    final favouritesSnapshot = await FirebaseFirestore.instance
        .collection('favourites')
        .doc(currentUserEmail)
        .get();

    Favourites favourites = Favourites('', [], []);

    final favouritesData = favouritesSnapshot.data();
    if (favouritesData != null) {
      favourites = Favourites.fromMap(favouritesData);
    }

    if (businessType == BusinessTypes.hotel) {
      List<String> hotelsFavourites = favourites.hotelsFavourites;
      hotelsFavourites.remove(businessName);
      await FirebaseFirestore.instance
          .collection('favourites')
          .doc(currentUserEmail)
          .update({'hotelsFavourites': hotelsFavourites});
    } else {
      List<String> businessesFavourites = favourites.businessesFavourites;
      businessesFavourites.remove(businessName);
      await FirebaseFirestore.instance
          .collection('favourites')
          .doc(currentUserEmail)
          .update({'businessesFavourites': businessesFavourites});
    }
  }

  static Future<void> removeBusinessFromAllFavourites(String businessName) async {
    final favouritesCollection = FirebaseFirestore.instance.collection('favourites');
    final querySnapshot = await favouritesCollection.get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      List<dynamic> businessesFavourites = data['businessesFavourites'];
      List<dynamic> hotelsFavourites = data['hotelsFavourites'];

      bool updated = false;

      if (businessesFavourites.contains(businessName)) {
        businessesFavourites.remove(businessName);
        updated = true;
      }

      if (hotelsFavourites.contains(businessName)) {
        hotelsFavourites.remove(businessName);
        updated = true;
      }

      if (updated) {
        await doc.reference.update({
          'businessesFavourites': businessesFavourites,
          'hotelsFavourites': hotelsFavourites,
        });
      }
    }
  }
}
