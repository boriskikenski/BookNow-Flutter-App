import 'package:book_now/model/enumerations/business_types.dart';

class HomeScreenDTO {
  BusinessTypes filter;
  double reviewGrade;
  int reviewsCounter;
  String name;
  String encodedImage;
  String country;
  String city;
  double price;

  HomeScreenDTO(this.filter, this.reviewGrade, this.reviewsCounter, this.name,
      this.encodedImage, this.country, this.city, this.price);
}