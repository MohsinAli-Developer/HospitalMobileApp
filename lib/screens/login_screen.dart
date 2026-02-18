// import "package:btih_andriod_app/screens/dashboard_screen.dart";
// import "package:flutter/material.dart";
// import "package:btih_andriod_app/screens/create_account_screen.dart";
// import "package:btih_andriod_app/services/auth_service.dart";
// import "dart:convert";
// import 'package:http/http.dart' as http;

// class AuthService {
//   static const String baseUrl = 'https://172.16.40.10:8080';

//   Future<Map<String, dynamic>> login({
//     required String contactNo,
//     required String password,
//   }) async {
//     final url = Uri.parse('$baseUrl/api/Auth/login');

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'accept': '*/*',
//       },
//       body: jsonEncode({
//         "contactNo": contactNo,
//         "password": password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception(response.body);
//     }
//   }
// }

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _auth = AuthService();
//   bool _loading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _showSnack(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(text, style: const TextStyle(color: Colors.black)),
//       backgroundColor: Colors.white,
//       behavior: SnackBarBehavior.floating,
//     ));
//   }

//  Future<void> _login() async {
//   final contactNo = _emailController.text.trim();
//   final password = _passwordController.text;

//   if (contactNo.isEmpty || password.isEmpty) {
//     _showSnack('Please enter credentials');
//     return;
//   }

//   setState(() => _loading = true);

//   try {
//     final response = await _auth.login(
//       contactNo: contactNo,
//       password: password,
//     );

//     _showSnack(response['message'] ?? 'Login successful');

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const DashboardScreen(),
//       ),
//     );
//   } catch (e) {
//     _showSnack('Invalid username or password');
//   } finally {
//     setState(() => _loading = false);
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF16B2AC), Color(0xFF1FC9C0)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: const Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Text(
//                     'Login',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 28),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         labelText: 'Username',
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                         labelText: 'Password',
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     buildLoginButton(),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildLoginButton() {
//   return SizedBox(
//     width: 200,
//     child: ElevatedButton(
//       onPressed: _loading ? null : _login,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color.fromARGB(255, 31, 201, 192),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 40,
//           vertical: 14,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//       child: _loading
//           ? const SizedBox(
//               height: 16,
//               width: 16,
//               child: CircularProgressIndicator(
//                   strokeWidth: 2, color: Colors.white),
//             )
//           : const Text(
//               'Login',
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//     ),
//   );
// }


//   // Widget createAccount(BuildContext context) {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       const Text('Don\'t have an Account?'),
//   //       TextButton(
//   //         onPressed: () {
//   //           Navigator.pushReplacement(
//   //               context,
//   //               MaterialPageRoute(
//   //                   builder: (context) => const CreateAccountScreen()));
//   //         },
//   //         child: const Text(
//   //           'Register Now',
//   //           style: TextStyle(
//   //             color: Colors.red,
//   //             decoration: TextDecoration.underline,
//   //             decorationColor: Colors.red,
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/ip_file.dart';

import 'package:btih_andriod_app/screens/dashboard_screen.dart';

/// =====================
/// AUTH SERVICE
/// =====================
class AuthService {

  Future<Map<String, dynamic>> login({
    required String contactNo,
    required String password,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/Auth/login");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode({
        "contactNo": contactNo,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(response.body);
    }
  }
}

/// =====================
/// LOGIN SCREEN
/// =====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;

  @override
  void dispose() {
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _login() async {
    final contactNo = _contactController.text.trim();
    final password = _passwordController.text.trim();

    if (contactNo.isEmpty || password.isEmpty) {
      _showSnack('Please enter credentials');
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await _authService.login(
        contactNo: contactNo,
        password: password,
      );

      _showSnack(response['message'] ?? 'Login successful');
        var mrNoData = response['mR_NO'];
    String mrNo = mrNoData['mrNo'] ?? '';
    String patient = mrNoData['firstName'] ?? '';
      if (mrNo.isEmpty) {
        _showSnack('MR Number not found in response');
        setState(() => _loading = false);
        return;
      }
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => DashboardScreen(
      patientMrNo: mrNo, 
      patientName: patient,
    ),
  ),
);
    } catch (e) {
      _showSnack('Invalid username or password');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF16B2AC), Color(0xFF1FC9C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// FORM
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    TextField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Contact No',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    _buildLoginButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: _loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1FC9C0),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _loading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }
}
