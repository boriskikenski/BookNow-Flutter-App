import 'package:book_now/model/business.dart';
import 'package:book_now/model/dto/home_screen_dto.dart';
import 'package:book_now/model/hotel.dart';

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
}