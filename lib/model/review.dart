import 'package:book_now/model/costumer.dart';

class Review {
  Costumer reviewer;
  int grade;
  String comment;
  DateTime date;

  Review(this.reviewer, this.grade, this.comment, this.date);
}