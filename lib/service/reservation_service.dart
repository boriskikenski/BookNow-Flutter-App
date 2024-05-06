import 'dart:convert';

import 'package:book_now/model/business.dart';
import 'package:book_now/model/hotel.dart';
import 'package:book_now/model/hotel_reservation.dart';
import 'package:book_now/model/reservation.dart';
import 'package:book_now/model/dto/reservation_dto.dart';
import 'package:crypto/crypto.dart';

class ReservationService {

  static Future<String> createReservation (String currentCostumerEmail,
      String businessName, DateTime when) async {

    Business? business = await Business.findByName(businessName);
    String businessOwnerEmail = business!.ownerEmail;

    String qrGenerationString =
    _encodeQRString(when.toIso8601String() + currentCostumerEmail);

    Reservation reservation = Reservation(
        qrGenerationString,
        currentCostumerEmail,
        businessName,
        businessOwnerEmail,
        when
    );
    await reservation.saveReservation();

    return qrGenerationString;
  }

  static Future<String> createHotelReservation (String currentCostumerEmail,
      String hotelName, DateTime startDate, DateTime endDate, int roomCapacity) async {

    Hotel? hotel = await Hotel.findByName(hotelName);
    String hotelOwnerEmail = hotel!.ownerEmail;

    String qrGenerationString =
    _encodeQRString(startDate.toIso8601String() +
        endDate.toIso8601String() + currentCostumerEmail);

    HotelReservation hotelReservation = HotelReservation(
        qrGenerationString,
        currentCostumerEmail,
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

  static Future<List<ReservationDTO>> getAllReservationsForCostumer(String ownerFullName) async {
    List<ReservationDTO> allReservations = [];
    List<Reservation> reservations = await Reservation.getAllReservationsForCostumer(ownerFullName);
    List<HotelReservation> hotelReservations = await HotelReservation.getAllReservationsForCostumer(ownerFullName);

    for (Reservation reservation in reservations) {
      allReservations.add(ReservationDTO(
          reservation.qrGenerationString,
          reservation.reservationOwnerEmail,
          reservation.businessName,
          reservation.when)
      );
    }
    for (HotelReservation reservation in hotelReservations) {
      allReservations.add(ReservationDTO(
          reservation.qrGenerationString,
          reservation.reservationOwnerEmail,
          reservation.businessName,
          reservation.startDate)
      );
    }

    return allReservations;
  }
}