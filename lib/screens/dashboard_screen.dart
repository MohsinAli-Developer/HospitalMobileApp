import 'package:btih_andriod_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:btih_andriod_app/screens/patient_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctors_list_screen.dart';
import 'reports_screen.dart';
import 'login_screen.dart';
import 'package:btih_andriod_app/screens/patient_report_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String patientMrNo;
  final String patientName;
  final bool isLoggedIn; // Add this parameter

  const DashboardScreen({
    super.key,
    required this.patientMrNo,
    required this.patientName,
    this.isLoggedIn = false, // Default to false
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1; // Dashboard selected
  bool _isLoggedIn = false; // Local login state

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.isLoggedIn;
  }

  // Method to check if user is logged in, if not show login dialog
  Future<bool> _checkLoginAndNavigate(BuildContext context, String destination){
    if (!_isLoggedIn) {
      _showLoginRequiredDialog(context, destination);
      return Future.value(false);
    }
    return Future.value(true);
  }

  // Show login required dialog
  void _showLoginRequiredDialog(BuildContext context, String destination) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Login Required',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1FC9C0),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1FC9C0).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF1FC9C0),
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'You need to login first to access this feature.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      redirectAfterLogin: true,
                      returnScreen: destination,
                      patientMrNo: widget.patientMrNo,
                      patientName: widget.patientName,
                    ),
                  ),
                ).then((loggedIn) {
                  if (loggedIn == true) {
                    setState(() {
                      _isLoggedIn = true;
                    });
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1FC9C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Login Now'),
            ),
          ],
        );
      },
    );
  }
Future<void> _logout() async {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {

              Navigator.pop(dialogContext); // close dialog

              // Clear stored session
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              if (!mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

  void _showLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          redirectAfterLogin: true,
          returnScreen: 'dashboard',
          patientMrNo: widget.patientMrNo,
          patientName: widget.patientName,
        ),
      ),
    ).then((loggedIn) {
      if (loggedIn == true) {
        setState(() {
          _isLoggedIn = true;
        });
      }
    });
  }
  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text, 
          style: TextStyle(color: Colors.red ),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          // Header with MR_NO and Patient Name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              color: Color(0xFF1FC9C0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Patient info - takes available space
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${widget.patientName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Enhanced MR No display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              'MR No: ${widget.patientMrNo}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icons - fixed width, won't be pushed out
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Show either Login or Logout based on state
                        if (_isLoggedIn)
                          GestureDetector(
                            onTap: _logout,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: _showLoginScreen,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.login,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        // Notification Icon (always visible)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoggedIn 
                      ? 'Welcome to your health dashboard'
                      : 'Please login to access all features',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          // Doctors Bar - Always accessible (no login required)
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorsListScreen(
                      patientMrNo: widget.patientMrNo,
                      patientName: widget.patientName,
                      isLoggedIn: _isLoggedIn,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1FC9C0),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1FC9C0).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Find a Doctor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
            // Four quick tiles (require login)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.4,
                        children: [
                          _buildStatTile(
                            Icons.folder, 
                            'Reports', 
                            Colors.blue,
                            requiresLogin: true,
                          ),
                          _buildStatTile(
                            Icons.calendar_today, 
                            'Appointments', 
                            Colors.green,
                            requiresLogin: true,
                          ),
                          _buildStatTile(
                            Icons.medication, 
                            'Billing History', 
                            Colors.orange,
                            requiresLogin: true,
                          ),
                          _buildStatTile(
                            Icons.message, 
                            'Messages', 
                            Colors.purple,
                            requiresLogin: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: const Color(0xFF1FC9C0),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', 0),
              _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 1),
              _buildNavItem(Icons.person_outline, 'Profile', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () async {
        setState(() {
          _currentIndex = index;
        });
        
        if (index == 0) {
          // Home screen - always accessible
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 1) {
          // Already on Dashboard
        } else if (index == 2) {
          // Profile - requires login
          bool canNavigate = await _checkLoginAndNavigate(context, 'profile');
          if (canNavigate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientProfilePage(
                  mrNo: widget.patientMrNo,
                  //isLoggedIn: _isLoggedIn,
                ),
              ),
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(IconData icon, String title, Color color, {bool requiresLogin = false}) {
    return GestureDetector(
      onTap: () async {
        if (requiresLogin) {
          bool canNavigate = await _checkLoginAndNavigate(context, title.toLowerCase());
          if (!canNavigate) return;
        }

        if (title == 'Reports') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportsScreen(
                patientMrNo: widget.patientMrNo,
                patientName: widget.patientName,
                //isLoggedIn: _isLoggedIn,
              ),
            ),
          );
        } else if (title == 'Billing History') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientReportHistoryScreen(
                patientMrNo: widget.patientMrNo,
                patientName: widget.patientName,
                isLoggedIn: _isLoggedIn,
              ),
            ),
          );
        } else if (title == 'Appointments') {
          // Navigate to appointments screen (you'll need to create this)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointments feature coming soon'),
              backgroundColor: Color(0xFF1FC9C0),
            ),
          );
        } else if (title == 'Messages') {
          // Navigate to messages screen (you'll need to create this)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Messages feature coming soon'),
              backgroundColor: Color(0xFF1FC9C0),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (requiresLogin && !_isLoggedIn)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}