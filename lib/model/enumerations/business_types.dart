enum BusinessTypes {
  hotel,
  venue,
  gym,
  spa,
  event,
  barber,
  tour
}

extension BusinessTypesExtension on BusinessTypes {
  String get printName {
    switch (this) {
      case BusinessTypes.hotel:
        return 'Hotel';
      case BusinessTypes.venue:
        return 'Venue';
      case BusinessTypes.gym:
        return 'Gym';
      case BusinessTypes.spa:
        return 'Spa';
      case BusinessTypes.event:
        return 'Event';
      case BusinessTypes.barber:
        return 'Barber';
      case BusinessTypes.tour:
        return 'Tour';
      default:
        return '';
    }
  }
}