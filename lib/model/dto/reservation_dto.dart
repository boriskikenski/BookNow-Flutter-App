class ReservationDTO {
  String qrGenerationString;
  String reservationOwnerFullName;
  String businessName;
  DateTime when;

  ReservationDTO(this.qrGenerationString, this.reservationOwnerFullName,
      this.businessName, this.when);
}