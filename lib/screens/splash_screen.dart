import 'package:flutter/material.dart';
import 'package:btih_andriod_app/screens/create_account_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateToCreate(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF2CC3B8), Color(0xFF16A7A0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.local_hospital, color: Colors.white, size: 64),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1FC9C0) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 20),
                const Text(
                  'Bahria Town\nInternational\nHospital Karachi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700, height: 1.1),
                ),
                const SizedBox(height: 20),
                const Text('Hello!',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 20),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () => _navigateToCreate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 31, 201, 192),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 2,
                    ),
                    child: const Text('Get Started',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(false),
                    const SizedBox(width: 8),
                    _dot(true),
                    const SizedBox(width: 8),
                    _dot(false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
