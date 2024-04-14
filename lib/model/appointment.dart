class Appointment {
  int minPerSlot;
  int peoplePerSlot;
  int numberOfSlots;
  double pricePerAppointment;

  Appointment(this.minPerSlot, this.peoplePerSlot, this.numberOfSlots,
      this.pricePerAppointment);

  Map<String, dynamic> toMap() {
    return {
      'minPerSlot': minPerSlot,
      'peoplePerSlot': peoplePerSlot,
      'numberOfSlots': numberOfSlots,
      'pricePerAppointment': pricePerAppointment,
    };
  }

  static Appointment fromMap(Map<String, dynamic> map) {
    return Appointment(
      map['minPerSlot'],
      map['peoplePerSlot'],
      map['numberOfSlots'],
      map['pricePerAppointment'],
    );
  }
}