class Location {
  String country;
  String city;
  String street;
  int streetNumber;

  Location(this.country, this.city, this.street, this.streetNumber);

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'city': city,
      'street': street,
      'streetNumber': streetNumber,
    };
  }

  static Location fromMap(Map<String, dynamic> map) {
    return Location(
      map['country'],
      map['city'],
      map['street'],
      map['streetNumber'],
    );
  }
}