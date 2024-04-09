class BusinessAlreadyExistException implements Exception {

  @override
  String toString() {
    return 'Business name already in use. Choose different business name!';
  }
}