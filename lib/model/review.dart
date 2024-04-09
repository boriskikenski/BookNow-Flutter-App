import 'package:book_now/model/costumer.dart';

class Review {
  Costumer reviewer;
  int grade;
  String comment;
  DateTime date;

  Review(this.reviewer, this.grade, this.comment, this.date);

  Map<String, dynamic> toMap() {
    return {
      'reviewer': reviewer.toMap(),
      'grade': grade,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  static Review fromMap(Map<String, dynamic> map) {
    return Review(
      Costumer.fromMap(map['reviewer']),
      map['grade'],
      map['comment'],
      DateTime.parse(map['date']),
    );
  }
}