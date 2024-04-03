import './costumer.dart';
import './location.dart';
import './review.dart';
import './room.dart';
import './enumerations/business_types.dart';

class Hotel {
  String businessName;
  Costumer owner;
  Location location;
  DateTime openingTime;
  DateTime closingTime;
  Map<DateTime, List<Room>> units;
  double reviewGrade;
  int reviewsSum;
  int reviewsCounter;
  Review review;
  BusinessTypes filter;
  //todo website

  Hotel(this.businessName, this.owner, this.location, this.openingTime,
      this.closingTime, this.units, this.reviewGrade, this.reviewsSum,
      this.reviewsCounter, this.review, this.filter);
}