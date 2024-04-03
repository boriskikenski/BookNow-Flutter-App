import './hotel.dart';
import './business.dart';
import './reservation.dart';

class Costumer {
  String fullName;
  String username;
  String email;
  String password;
  List<Hotel> hotels;
  List<Business> business;
  List<Reservation> reservationList;

  Costumer(this.fullName, this.username, this.email, this.password,
      this.hotels, this.business, this.reservationList);
}