import 'dart:convert';

import 'package:book_now/model/business.dart';
import 'package:book_now/model/costumer.dart';
import 'package:book_now/model/hotel.dart';
import 'package:book_now/model/hotel_reservation.dart';
import 'package:book_now/model/reservation.dart';
import 'package:crypto/crypto.dart';

class ReservationService {

  static Future<String> createReservation (String currentCostumerEmail,
      String businessName, DateTime when) async {

    Costumer? costumer = await Costumer.findByEmail(currentCostumerEmail);
    String costumerFullName = costumer!.fullName;

    Business? business = await Business.findByName(businessName);
    String businessOwnerEmail = business!.ownerEmail;

    String qrGenerationString =
    _encodeQRString(when.toIso8601String() + currentCostumerEmail);

    Reservation reservation = Reservation(
        qrGenerationString,
        costumerFullName,
        businessName,
        businessOwnerEmail,
        when
    );
    await reservation.saveReservation();

    return qrGenerationString;
  }

  static Future<String> createHotelReservation (String currentCostumerEmail,
      String hotelName, DateTime startDate, DateTime endDate, int roomCapacity) async {

    Costumer? costumer = await Costumer.findByEmail(currentCostumerEmail);
    String costumerFullName = costumer!.fullName;

    Hotel? hotel = await Hotel.findByName(hotelName);
    String hotelOwnerEmail = hotel!.ownerEmail;

    String qrGenerationString =
    _encodeQRString(startDate.toIso8601String() +
        endDate.toIso8601String() + currentCostumerEmail);

    HotelReservation hotelReservation = HotelReservation(
        qrGenerationString,
        costumerFullName,
        hotelName,
        hotelOwnerEmail,
        startDate,
        endDate,
        roomCapacity
    );
    await hotelReservation.saveHotelReservation();

    return qrGenerationString;
  }

  static String _encodeQRString(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}