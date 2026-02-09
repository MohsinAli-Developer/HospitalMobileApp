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

// class AuthService {
//   static const String _baseUrl = 'your_backend_api_url';

//   Future<bool> signUp({
//     String? email,
//     String? phoneNumber,
//     required String password,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/signup'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': email,
//         'phoneNumber': phoneNumber,
//         'password': password,
//       }),
//     );

//     return response.statusCode == 201;
//   }

//   Future<String?> signIn({
//     String? email,
//     String? phoneNumber,
//     required String password,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': email,
//         'phoneNumber': phoneNumber,
//         'password': password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return response.body; // assuming this returns the mrNo
//     } else {
//       return null;
//     }
//   }

//   Future<User?> getUser(String mrNo) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/user/$mrNo'),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       return User.fromJson(jsonDecode(response.body));
//     } else {
//       return null;
//     }
//   }
//   Future<bool> signInWithGoogle() async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     return true;
//   }

//   Future<bool> signInWithApple() async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     return true;
//   }

//   Future<bool> signInWithFacebook() async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     return true;
//   }
// }
