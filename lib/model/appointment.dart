class Appointment {
  int minPerSlot;
  int peoplePerSlot;
  int numberOfSlots;
  DateTime startingTime;

  Appointment(this.minPerSlot, this.peoplePerSlot, this.numberOfSlots,
      this.startingTime);

  Map<String, dynamic> toMap() {
    return {
      'minPerSlot': minPerSlot,
      'peoplePerSlot': peoplePerSlot,
      'numberOfSlots': numberOfSlots,
      'startingTime': startingTime.toIso8601String(),
    };
  }
}