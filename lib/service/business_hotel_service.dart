import 'package:book_now/model/business.dart';
import 'package:book_now/model/dto/home_screen_dto.dart';
import 'package:book_now/model/dto/select_date_screen_dto.dart';
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

  static Future<SelectDateScreenDTO> getBusinessAvailability(
      String businessName) async {
    SelectDateScreenDTO selectDateScreenDTO;
    Business? business = await Business.findByName(businessName);

    selectDateScreenDTO = SelectDateScreenDTO(
        name: business?.businessName ?? '',
        price: business?.appointment.pricePerAppointment ?? 0,
        openingTime: business?.openingTime ?? TimeOfDay.now(),
        closingTime: business?.closingTime ?? TimeOfDay.now(),
        minPerSlot: business?.appointment.minPerSlot ?? 0,
        businessBookings: business?.bookings ?? {},
        numberOfSlots:  business?.appointment.numberOfSlots ?? 0,
    );
    return selectDateScreenDTO;
  }
}