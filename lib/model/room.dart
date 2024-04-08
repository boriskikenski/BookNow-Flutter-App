class Room {
  int capacity;
  int numberOfUnits;
  int availableUnits;

  Room(this.capacity, this.numberOfUnits, this.availableUnits);

  Map<String, dynamic> toMap() {
    return {
      'capacity': capacity,
      'numberOfUnits': numberOfUnits,
      'availableUnits': availableUnits,
    };
  }
}