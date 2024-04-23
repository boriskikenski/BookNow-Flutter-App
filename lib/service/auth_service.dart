import 'package:book_now/model/dto/login_dto.dart';
import 'package:book_now/model/dto/register_dto.dart';
import 'package:book_now/model/exception/password_creation_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/costumer.dart';

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

    Costumer c = Costumer(
      costumer.fullName,
      costumer.username,
      costumer.email,
      [], [],
    );
    c.saveCostumer();
  }

  login(LoginDTO user) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Costumer?> getCurrentCostumer() async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail != null) {
      return await Costumer.findByEmail(currentUserEmail);
    } else {
      return null;
    }
  }
}
