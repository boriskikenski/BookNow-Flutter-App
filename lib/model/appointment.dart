class Appointment {
  int minPerSlot;
  int peoplePerSlot;
  int numberOfSlots;
  DateTime startingTime;
  double pricePerAppointment;

  Appointment(this.minPerSlot, this.peoplePerSlot, this.numberOfSlots,
      this.startingTime, this.pricePerAppointment);

  Map<String, dynamic> toMap() {
    return {
      'minPerSlot': minPerSlot,
      'peoplePerSlot': peoplePerSlot,
      'numberOfSlots': numberOfSlots,
      'startingTime': startingTime.toIso8601String(),
      'pricePerAppointment': pricePerAppointment,
    };
  }

  static Appointment fromMap(Map<String, dynamic> map) {
    return Appointment(
      map['minPerSlot'],
      map['peoplePerSlot'],
      map['numberOfSlots'],
      DateTime.parse(map['startingTime']),
      map['pricePerAppointment'],
    );
  }
}