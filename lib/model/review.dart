class Review {
  String reviewerUsername;
  int grade;
  String comment;
  DateTime date;

  Review(this.reviewerUsername, this.grade, this.comment, this.date);

  Map<String, dynamic> toMap() {
    return {
      'reviewerUsername': reviewerUsername,
      'grade': grade,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  static Review fromMap(Map<String, dynamic> map) {
    return Review(
      map['reviewerUsername'],
      map['grade'],
      map['comment'],
      DateTime.parse(map['date']),
    );
  }
}