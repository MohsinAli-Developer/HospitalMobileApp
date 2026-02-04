import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _kEmail = 'user_email';
  static const _kPassword = 'user_password';

  Future<bool> saveAccount(
      {required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kPassword, base64Encode(utf8.encode(password)));
    return true;
  }

  Future<Map<String, String>?> getSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kEmail);
    final pwdEncoded = prefs.getString(_kPassword);
    if (email == null || pwdEncoded == null) return null;
    final password = utf8.decode(base64Decode(pwdEncoded));
    return {'email': email, 'password': password};
  }

  Future<bool> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  Future<bool> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  Future<bool> signInWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
