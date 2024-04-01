import './business.dart';
import './reservation.dart';

class Costumer {
  String fullName;
  String username;
  String email;
  String password;
  List<Business> businessList;
  List<Reservation> reservationList;

  Costumer(this.fullName, this.username, this.email, this.password,
      this.businessList, this.reservationList);
}