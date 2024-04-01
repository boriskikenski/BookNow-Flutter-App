class PasswordsNotMatchException implements Exception {

  @override
  String toString() {
    return 'Enter same password twice!';
  }
}