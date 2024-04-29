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
          business.location.city,
          business.appointment.pricePerAppointment)
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
          hotel.location.city,
          hotel.rooms[0].pricePerNight)
      );
    }
    return homeScreenItems;
  }

  static Future<BusinessCheckoutDTO> getBusinessCheckoutDTO(
      String businessName, {Business? businessEntity}) async {
    BusinessCheckoutDTO businessCheckoutDTO;
    Business? business;
    if (businessEntity != null) {
      business = businessEntity;
    } else {
      business = await Business.findByName(businessName);
    }

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

  static Future<HotelCheckoutDTO> getHotelCheckoutDTO(String hotelName,
      {Hotel? hotelEntity}) async {
    HotelCheckoutDTO hotelCheckoutDTO;
    Hotel? hotel = await Hotel.findByName(hotelName);
    if (hotelEntity != null) {
      hotel = hotelEntity;
    } else {
      hotel = await Hotel.findByName(hotelName);
    }

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