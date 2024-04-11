class Room {
  int capacity;
  int numberOfUnits;
  int availableUnits;
  double pricePerNight;

  Room(this.capacity, this.numberOfUnits, this.availableUnits,
      this.pricePerNight);

  Map<String, dynamic> toMap() {
    return {
      'capacity': capacity,
      'numberOfUnits': numberOfUnits,
      'availableUnits': availableUnits,
      'pricePerNight': pricePerNight,
    };
  }

  static Room fromMap(Map<String, dynamic> map) {
    return Room(
      map['capacity'],
      map['numberOfUnits'],
      map['availableUnits'],
      map['pricePerNight'],
    );
  }
}