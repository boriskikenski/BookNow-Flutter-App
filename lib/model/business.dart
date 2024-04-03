import './appointment.dart';
import './review.dart';
import './costumer.dart';
import './location.dart';
import './enumerations/business_types.dart';

class Business {
  String businessName;
  Costumer owner;
  Location location;
  DateTime openingTime;
  DateTime closingTime;
  Map<DateTime, List<Appointment>> appointments; //todo kreiraj za site dati do data za najdocna rezervacija i dovrshi go mesecot
  double reviewGrade;
  int reviewsSum;
  int reviewsCounter;
  Review review;
  BusinessTypes filter;
  //todo website

  Business(this.businessName, this.owner, this.location, this.openingTime,
      this.closingTime, this.appointments, this.reviewGrade, this.reviewsSum,
      this.reviewsCounter, this.review, this.filter);
}