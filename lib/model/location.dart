class Location {
  String country;
  String city;
  String street;
  int streetNumber;
  //todo google maps ?

  Location(this.country, this.city, this.street, this.streetNumber);

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'city': city,
      'street': street,
      'streetNumber': streetNumber,
    };
  }
}