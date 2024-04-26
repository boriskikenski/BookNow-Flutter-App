class Review {
  String reviewerEmail;
  int grade;
  String comment;
  DateTime date;

  Review(this.reviewerEmail, this.grade, this.comment, this.date);

  Map<String, dynamic> toMap() {
    return {
      'reviewerEmail': reviewerEmail,
      'grade': grade,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  static Review fromMap(Map<String, dynamic> map) {
    return Review(
      map['reviewerEmail'],
      map['grade'],
      map['comment'],
      DateTime.parse(map['date']),
    );
  }
}