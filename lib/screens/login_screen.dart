import "package:btih_andriod_app/screens/dashboard_screen.dart";
import "package:flutter/material.dart";
import "package:btih_andriod_app/screens/create_account_screen.dart";
import "package:btih_andriod_app/services/auth_service.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text, style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
    ));
  }

// Future<void> _login() async {
//   setState(() => _loading = true);
//   String? identifier = _emailController.text.trim();
//   if (identifier.isEmpty) {
//     identifier = _phoneNumberController.text.trim();
//   }
//   final mrNo = await _auth.signIn(
//     email: identifier.contains('@') ? identifier : null,
//     phoneNumber: identifier.contains('@') ? null : identifier,
//     password: _passwordController.text,
//   );
//   setState(() => _loading = false);

//   if (mrNo != null) {
//     // store the mrNo securely
//     final user = await _auth.getUser(mrNo);
//     if (user != null) {
//       // navigate to dashboard with user data
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => DashboardScreen(user: user)),
//       );
//     } else {
//       _showSnack('Failed to fetch user data');
//     }
//   } else {
//     _showSnack('Invalid credentials');
//   }
// }

  Future<void> _login() async {
  setState(() => _loading = true);

  final saved = await _auth.getSavedAccount();

  setState(() => _loading = false);

  if (saved == null) {
    _showSnack('No account found. Please register.');
    return;
  }

  final inputEmail = _emailController.text.trim();
  final inputPwd = _passwordController.text;

  if (inputEmail == saved['email'] &&
      inputPwd == saved['password']) {
    _showSnack('Login successful');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  } else {
    _showSnack('Invalid username or password');
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
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(16.0),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.email_outlined),
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
                    buildLoginButton(),
                    const SizedBox(height: 20),
                    createAccount(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildLoginButton() {
  //   return SizedBox(
  //     width: 200,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => const DashboardScreen()));
  //       },
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

  Widget buildLoginButton() {
  return SizedBox(
    width: 200,
    child: ElevatedButton(
      onPressed: _loading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 31, 201, 192),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: _loading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Text(
              'Login',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
    ),
  );
}


  Widget createAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an Account?'),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen()));
          },
          child: const Text(
            'Register Now',
            style: TextStyle(
              color: Colors.red,
              decoration: TextDecoration.underline,
              decorationColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
