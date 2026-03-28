import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/ip_file.dart';
import 'package:btih_andriod_app/screens/dashboard_screen.dart';

/// =====================
/// AUTH SERVICE
/// =====================
class AuthService {
  // Add this method to clear any stored auth data
  static void clearAuthData() {
    // Clear any static variables or cached data
  }

  Future<Map<String, dynamic>> login({
    required String contactNo,
    required String password,
  }) async {
    // Clear any previous state
    clearAuthData();
    
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

  // Verify phone number exists
  Future<Map<String, dynamic>> verifyPhoneNumber(String contactNo) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/Auth/verifyPhoneNo?ContactNo=$contactNo");

    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Phone number verification failed');
    }
  }

  // Send OTP
  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/Auth/send-otp?phoneNumber=$phoneNumber");

    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/Auth/verify-otp?phoneNumber=$phoneNumber&otp=$otp");

    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('OTP verification failed');
    }
  }

  // Update password
  Future<Map<String, dynamic>> updatePassword({
    required String mrno,
    required String patientPassword,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/Patient/updatePassword?mrno=$mrno&patientPassword=$patientPassword");

    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Password update failed');
    }
  }
}

/// =====================
/// FORGOT PASSWORD DIALOG
/// =====================
class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final AuthService _authService = AuthService();
  
  int _step = 1; // 1: Enter Phone, 2: Enter OTP, 3: Update Password
  bool _isLoading = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  String? _verifiedMrNo;
  
  // OTP Timer
  int _start = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      _canResend = false;
    });
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // Send OTP using API
  Future<void> _sendOtp() async {
    setState(() => _isSendingOtp = true);

    try {
      final response = await _authService.sendOtp(_phoneController.text.trim());
      
      if (response['success'] == true) {
        _startTimer();
        _showSnack(response['message'] ?? 'OTP sent successfully');
      } else {
        _showSnack('Failed to send OTP', isError: true);
      }
    } catch (e) {
      _showSnack('Error sending OTP: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isSendingOtp = false);
    }
  }

  // Verify phone number with API
  Future<void> _verifyPhoneNumber() async {
    final phoneNo = _phoneController.text.trim();
    
    if (phoneNo.isEmpty || phoneNo.length < 10) {
      _showSnack('Please enter a valid phone number', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.verifyPhoneNumber(phoneNo);
      
      setState(() {
        _verifiedMrNo = response['mr_no'];
        _isLoading = false;
      });
      
      _showSnack(response['message'] ?? 'Phone number verified');
      
      // Send OTP after successful verification
      await _sendOtp();
      
      // Move to OTP step
      setState(() {
        _step = 2;
      });
      
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Phone number not found', isError: true);
    }
  }

  // Verify OTP
  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showSnack('Please enter OTP', isError: true);
      return;
    }

    if (otp.length != 6) {
      _showSnack('Please enter a valid 6-digit OTP', isError: true);
      return;
    }

    setState(() => _isVerifyingOtp = true);

    try {
      final response = await _authService.verifyOtp(
        phoneNumber: _phoneController.text.trim(),
        otp: otp,
      );

      if (response['success'] == true) {
        setState(() {
          _step = 3;
          _isVerifyingOtp = false;
        });

        _timer?.cancel();
        _showSnack(response['message'] ?? "OTP verified successfully");
      } else {
        setState(() => _isVerifyingOtp = false);
        _showSnack(response['message'] ?? "Invalid OTP", isError: true);
      }

    } catch (e) {
      setState(() => _isVerifyingOtp = false);
      _showSnack("OTP verification failed", isError: true);
    }
  }

  // Resend OTP
  Future<void> _resendOtp() async {
    if (!_canResend) return;
    await _sendOtp();
  }

  // Update password
  Future<void> _updatePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnack('Please enter new password', isError: true);
      return;
    }

    if (newPassword.length < 6) {
      _showSnack('Password must be at least 6 characters', isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnack('Passwords do not match', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.updatePassword(
        mrno: _verifiedMrNo!,
        patientPassword: newPassword,
      );

      _showSnack(response['message'] ?? 'Password updated successfully');

      // Close dialog after success
      Navigator.pop(context);

    } catch (e) {
      _showSnack('Failed to update password: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text, 
          style: TextStyle(color: isError ? Colors.red : Colors.black),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1FC9C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1FC9C0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _step == 1 ? Icons.phone : 
                      _step == 2 ? Icons.sms : 
                      Icons.lock_reset,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _step == 1 ? 'Verify Phone' :
                          _step == 2 ? 'Enter OTP' :
                          'Reset Password',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1FC9C0),
                          ),
                        ),
                        Text(
                          _step == 1 ? 'Step 1 of 3' :
                          _step == 2 ? 'Step 2 of 3' :
                          'Step 3 of 3',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Step 1: Enter Phone Number
            if (_step == 1) ...[
              const Text(
                'Enter your registered phone number',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                enabled: !_isLoading && !_isSendingOtp,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '03xxxxxxxxx',
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF1FC9C0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1FC9C0), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isLoading || _isSendingOtp) ? null : _verifyPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1FC9C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Verify & Send OTP'),
                ),
              ),
            ],

            // Step 2: Enter OTP
            if (_step == 2) ...[
              const Text(
                'Enter the 6-digit OTP sent to',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                _phoneController.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1FC9C0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                enabled: !_isVerifyingOtp,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter 6-digit OTP',
                  prefixIcon: const Icon(Icons.sms, color: Color(0xFF1FC9C0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1FC9C0), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time remaining: $_start seconds',
                    style: TextStyle(
                      color: _start < 10 ? Colors.red : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  if (_canResend)
                    TextButton(
                      onPressed: _isSendingOtp ? null : _resendOtp,
                      child: _isSendingOtp
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FC9C0)),
                              ),
                            )
                          : const Text(
                              'Resend OTP',
                              style: TextStyle(color: Color(0xFF1FC9C0)),
                            ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _step = 1;
                          _timer?.cancel();
                        });
                      },
                      child: const Text('Back', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isVerifyingOtp ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1FC9C0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isVerifyingOtp
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Verify OTP'),
                    ),
                  ),
                ],
              ),
            ],

            // Step 3: Update Password
            if (_step == 3) ...[
              const Text(
                'Enter your new password',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1FC9C0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1FC9C0), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1FC9C0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1FC9C0), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _step = 2;
                        });
                      },
                      child: const Text('Back', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1FC9C0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Update Password'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================
/// LOGIN SCREEN
/// =====================
class LoginScreen extends StatefulWidget {
  final bool redirectAfterLogin;
  final String returnScreen;
  final String? patientMrNo;
  final String? patientName;

  const LoginScreen({
    super.key,
    this.redirectAfterLogin = false,
    this.returnScreen = '',
    this.patientMrNo,
    this.patientName,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _clearControllers(); // Clear any previous data
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Clear controllers when app returns to foreground
      _clearControllers();
    }
  }

  void _clearControllers() {
    _contactController.clear();
    _passwordController.clear();
    setState(() {
      _loading = false;
      _obscurePassword = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text, 
          style: TextStyle(color: isError ? Colors.red : Colors.black),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ForgotPasswordDialog();
      },
    );
  }

  Future<void> _login() async {
    if (_loading) return;

    final contactNo = _contactController.text.trim();
    final password = _passwordController.text.trim();

    if (contactNo.isEmpty || password.isEmpty) {
      _showSnack('Please enter both contact number and password', isError: true);
      return;
    }

    if (contactNo.length < 10) {
      _showSnack('Please enter a valid contact number', isError: true);
      return;
    }

    setState(() => _loading = true);

    try {
      print('Attempting login for: $contactNo'); // Debug log
      
      final response = await _authService.login(
        contactNo: contactNo,
        password: password,
      );

      print('Login response: $response'); // Debug log

      final mrData = response['mR_NO'] ?? response['mrNo'];

      String mrNo = '';
      String patientName = widget.patientName ?? 'Patient';

      if (mrData is Map) {
        mrNo = mrData['mrNo']?.toString() ?? '';
        patientName = mrData['firstName']?.toString() ?? patientName;
      } 
      else if (mrData is String) {
        mrNo = mrData;
      }

      if (mrNo.isEmpty) {
        _showSnack('MR Number not found', isError: true);
        return;
      }

      if (!mounted) return;

      _showSnack(response['message'] ?? 'Login successful');

      if (widget.redirectAfterLogin) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              patientMrNo: mrNo,
              patientName: patientName,
              isLoggedIn: true,
            ),
          ),
          (route) => false,
        );
      } else {
        // Navigator.pop(context, {
        //   'success': true,
        //   'mrNo': mrNo,
        //   'patientName': patientName,
        //   'returnScreen': widget.returnScreen,
        // });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              patientMrNo: mrNo,
              patientName: patientName,
              isLoggedIn: true,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print('Login error: $e'); // Debug log
      if (mounted) {
        _showSnack('Invalid username or password', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.redirectAfterLogin)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Please login to access ${widget.returnScreen}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// FORM
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    // Contact Number Field
                    TextField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Contact Number',
                        hintText: 'Enter your 10-digit mobile number',
                        prefixIcon: const Icon(Icons.phone, color: Color(0xFF1FC9C0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1FC9C0), width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password Field with visibility toggle
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1FC9C0)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF1FC9C0), width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF1FC9C0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Button
                    _buildLoginButton(),

                    const SizedBox(height: 20),

                    // Cancel button for redirect flow
                    if (widget.redirectAfterLogin)
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, {'success': false});
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
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
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1FC9C0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}

/// =====================
/// LOGOUT FUNCTION
/// =====================
