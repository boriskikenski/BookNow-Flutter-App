import 'package:book_now/model/dto/loginDTO.dart';
import 'package:book_now/model/dto/registerDTO.dart';
import 'package:book_now/model/exception/password_creation_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  register(RegisterDTO costumer) async {
    try {
      if (costumer.password != costumer.confirmPassword) {
        throw PasswordsNotMatchException();
      }
      await _auth.createUserWithEmailAndPassword(
        email: costumer.email,
        password: costumer.password,
      );
      _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      rethrow;
    }

    //TODO username and other data
  }

  login(LoginDTO user) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: user.username,
          password: user.password
      );
    } catch (e) {
      rethrow;
    }
  }
}
