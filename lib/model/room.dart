class Room {
  int capacity;
  int numberOfUnits;
  double pricePerNight;

  Room(this.capacity, this.numberOfUnits, this.pricePerNight);

  Map<String, dynamic> toMap() {
    return {
      'capacity': capacity,
      'numberOfUnits': numberOfUnits,
      'pricePerNight': pricePerNight,
    };
  }

  static Room fromMap(Map<String, dynamic> map) {
    return Room(
      map['capacity'],
      map['numberOfUnits'],
      map['pricePerNight'],
    );
  }
}