import 'package:book_now/model/business.dart';
import 'package:book_now/model/dto/home_screen_dto.dart';
import 'package:book_now/model/dto/business_checkout_dto.dart';
import 'package:book_now/model/dto/hotel_checkout_dto.dart';
import 'package:book_now/model/enumerations/business_types.dart';
import 'package:book_now/model/hotel.dart';
import 'package:flutter/material.dart';

class BHService {

  static Future<List<HomeScreenDTO>> fetchAllBusinessesAndHotels() async {
    List<HomeScreenDTO> homeScreenItems = [];
    List<Hotel> hotelList = await Hotel.fetchAllHotels();
    List<Business> businessList = await Business.fetchAllBusinesses();

    for (Business business in businessList) {
      homeScreenItems.add(HomeScreenDTO(
          business.filter,
          business.reviewGrade,
          business.reviewsCounter,
          business.businessName,
          business.encodedImage,
          business.location.country,
          business.location.city)
      );
    }
    for (Hotel hotel in hotelList) {
      homeScreenItems.add(HomeScreenDTO(
          hotel.filter,
          hotel.reviewGrade,
          hotel.reviewsCounter,
          hotel.hotelName,
          hotel.encodedImage,
          hotel.location.country,
          hotel.location.city)
      );
    }
    return homeScreenItems;
  }

  static Future<BusinessCheckoutDTO> getBusinessAvailability(
      String businessName) async {
    BusinessCheckoutDTO businessCheckoutDTO;
    Business? business = await Business.findByName(businessName);

    businessCheckoutDTO = BusinessCheckoutDTO(
      business?.businessName ?? '',
      business?.appointment.pricePerAppointment ?? 0,
      business?.openingTime ?? TimeOfDay.now(),
      business?.closingTime ?? TimeOfDay.now(),
      business?.appointment.minPerSlot ?? 0,
      business?.appointment.numberOfSlots ?? 0,
      business?.bookings ?? {},
      business?.filter ?? BusinessTypes.gym,
    );
    return businessCheckoutDTO;
  }

  static Future<HotelCheckoutDTO> getHotelAvailability(String hotelName) async {
    HotelCheckoutDTO hotelCheckoutDTO;
    Hotel? hotel = await Hotel.findByName(hotelName);

    hotelCheckoutDTO = HotelCheckoutDTO(
      hotel?.hotelName ?? '',
      hotel?.rooms ?? [],
      hotel?.bookings ?? {},
      hotel?.openingTime ?? TimeOfDay.now(),
      hotel?.closingTime ?? TimeOfDay.now(),
    );
    return hotelCheckoutDTO;
  }
}