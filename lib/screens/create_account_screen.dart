// import 'package:flutter/material.dart';
// import 'package:btih_andriod_app/screens/dashboard_screen.dart';
// import 'package:btih_andriod_app/screens/login_screen.dart';
// import 'package:btih_andriod_app/services/auth_service.dart';
// import 'package:btih_andriod_app/utils/validation_mixin.dart';

// class CreateAccountScreen extends StatefulWidget {
//   const CreateAccountScreen({super.key});

//   @override
//   State<CreateAccountScreen> createState() => _CreateAccountScreenState();
// }

// class _CreateAccountScreenState extends State<CreateAccountScreen>
//     with ValidationMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();
//   //final _auth = AuthService();
//   bool _loading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmController.dispose();
//     super.dispose();
//   }

//   void _showSnack(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(text, style: const TextStyle(color: Colors.black)),
//       backgroundColor: Colors.white,
//       behavior: SnackBarBehavior.floating,
//     ));
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);
//     final email = _emailController.text.trim();
//     final pwd = _passwordController.text;
//     final ok = await _auth.saveAccount(email: email, password: pwd);
//     setState(() => _loading = false);
//     if (ok) {
//       print(await _auth.getSavedAccount());

//       _showSnack('Account created');
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const DashboardScreen()),
//       );
//     } else {
//       _showSnack('Failed to create account');
//     }
//   }

// //   Future<void> _submit() async {
// //   if (!_formKey.currentState!.validate()) return;
// //   setState(() => _loading = true);
// //   final ok = await _auth.signUp(
// //     email: _emailController.text.trim(),
// //     password: _passwordController.text,
// //   );
// //   setState(() => _loading = false);

// //   if (ok) {
// //     _showSnack('Account created');
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (_) => const LoginScreen()),
// //     );
// //   } else {
// //     _showSnack('Failed to create account');
// //   }
// // }

//   Future<void> _socialSign(Future<bool> Function() fn, String provider) async {
//     setState(() => _loading = true);
//     final ok = await fn();
//     setState(() => _loading = false);
//     _showSnack(
//         ok ? '$provider sign-in successful' : '$provider sign-in failed');
//     if (ok) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const DashboardScreen()),
//       );
//     }
//   }

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
//                     'Create an\naccount',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 28),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email or Phone number',
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                           prefixIcon: const Icon(Icons.person),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         validator: validateEmail,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                           labelText: 'Password',
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         validator: validatePassword,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _confirmController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                           labelText: 'Confirm Password',
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         validator: (v) => validateConfirmPassword(
//                             _passwordController.text, v),
//                       ),
//                       const SizedBox(height: 24),
//                       RichText(
//                         text: const TextSpan(
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                           children: [
//                             TextSpan(text: 'By clicking the '),
//                             TextSpan(
//                               text: 'Register',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'button, you agree to the public offer.',
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text('Or continue with'),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           InkWell(
//                             onTap: _loading
//                                 ? null
//                                 : () => _socialSign(
//                                     _auth.signInWithGoogle, 'Google'),
//                             child: const CircleAvatar(
//                               radius: 20,
//                               backgroundColor: Color(0xFFF5F6FA),
//                               child: Icon(
//                                 Icons.g_mobiledata,
//                                 color: Color(0xFF1FC9C0),
//                                 size: 36,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           InkWell(
//                             onTap: _loading
//                                 ? null
//                                 : () =>
//                                     _socialSign(_auth.signInWithApple, 'Apple'),
//                             child: const CircleAvatar(
//                               radius: 20,
//                               backgroundColor: Color(0xFFF5F6FA),
//                               child: Icon(
//                                 Icons.apple,
//                                 color: Color(0xFF1FC9C0),
//                                 size: 28,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           InkWell(
//                             onTap: _loading
//                                 ? null
//                                 : () => _socialSign(
//                                     _auth.signInWithFacebook, 'Facebook'),
//                             child: const CircleAvatar(
//                               radius: 20,
//                               backgroundColor: Color(0xFFF5F6FA),
//                               child: Icon(
//                                 Icons.facebook,
//                                 color: Color(0xFF1FC9C0),
//                                 size: 28,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: 200,
//                         child: ElevatedButton(
//                           onPressed: _loading ? null : _submit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 31, 201, 192),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: _loading
//                               ? const SizedBox(
//                                   height: 16,
//                                   width: 16,
//                                   child: CircularProgressIndicator(
//                                       strokeWidth: 2, color: Colors.white),
//                                 )
//                               : const Text(
//                                   'Create Account',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.white),
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('Already have an Account'),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const LoginScreen(),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               'Login',
//                               style: TextStyle(
//                                   color: Colors.red,
//                                   decoration: TextDecoration.underline,
//                                   decorationColor: Colors.red),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
