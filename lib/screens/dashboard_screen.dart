import 'package:btih_andriod_app/screens/AppointmentsInfoScreen.dart';
import 'package:btih_andriod_app/screens/discharge_history_screen.dart';
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
                  builder: (_) => const LoginScreen(redirectAfterLogin: true,  // ✅ This shows the cancel button
      patientName: 'Patient',),
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
                            widget.patientName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                                fontSize: 20,
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
                            fontWeight: FontWeight.bold, // make bold
                            fontSize: 16,
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
                            Icons.report, 
                            'Summary', 
                            Colors.lightBlue,
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
             // _buildNavItem(Icons.home_outlined, 'Home', 0),
              _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 1),
              _buildNavItem(Icons.person_outline, 'Profile', 2),
            ],
          ),
        ),
      ),
    );
  }



//// ***************** Design one ******************
///
///
///
///

// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.grey[50],
//     body: SafeArea(
//       child: Column(
//         children: [
//           // Header with MR_NO and Patient Name - Enhanced Design
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   const Color(0xFF1FC9C0),
//                   const Color(0xFF1FC9C0).withOpacity(0.85),
//                   const Color(0xFF16A89F),
//                 ],
//                 stops: const [0.0, 0.6, 1.0],
//               ),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(32),
//                 bottomRight: Radius.circular(32),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF1FC9C0).withOpacity(0.3),
//                   blurRadius: 15,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     // Patient Avatar
//                     Container(
//                       width: 35,
//                       height: 35,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.4),
//                           width: 2,
//                         ),
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.person_outline,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Patient info
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.patientName,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.5,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 6),
//                           // Enhanced MR No display - Highly visible card
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                                 colors: [
//                                   Colors.white.withOpacity(0.25),
//                                   Colors.white.withOpacity(0.15),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(25),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.4),
//                                 width: 1,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.credit_card,
//                                   color: Colors.white.withOpacity(0.9),
//                                   size: 16,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   'MR No: ${widget.patientMrNo}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     letterSpacing: 1,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Container(
//                                   width: 4,
//                                   height: 4,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.6),
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 6),
//                                 const Icon(
//                                   Icons.verified,
//                                   color: Colors.white,
//                                   size: 14,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Icons
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (_isLoggedIn)
//                           _buildIconButton(
//                             icon: Icons.logout,
//                             onTap: _logout,
//                           )
//                         else
//                           _buildIconButton(
//                             icon: Icons.login,
//                             onTap: _showLoginScreen,
//                           ),
//                         // const SizedBox(width: 8),
//                         // _buildIconButton(
//                         //   icon: Icons.notifications_outlined,
//                         //   onTap: () {},
//                         //   hasBadge: true,
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Welcome Message with Animation
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         _isLoggedIn ? Icons.celebration : Icons.info_outline,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _isLoggedIn 
//                               ? '✨ Welcome back! Your health journey continues here'
//                               : '🔐 Please login to access all features & reports',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.95),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Doctors Bar
//          // Doctors Bar
// Padding(
//   padding: const EdgeInsets.all(20),
//   child: GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DoctorsListScreen(
//             patientMrNo: widget.patientMrNo,
//             patientName: widget.patientName,
//             isLoggedIn: _isLoggedIn,
//           ),
//         ),
//       );
//     },
//     child: Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           colors: [
//             const Color(0xFF1FC9C0),
//             const Color(0xFF16A89F),
//             const Color(0xFF1FC9C0),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1FC9C0).withOpacity(0.4),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(  // Removed 'const' keyword
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Row(  // This can stay const
//             children: [
//               Icon(Icons.search, color: Colors.white, size: 22),
//               SizedBox(width: 12),
//               Text(
//                 'Find a Doctor',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           Container(  // This cannot be const because of dynamic BorderRadius
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20), // Changed from BorderRadius.all
//             ),
//             child: const Row(
//               children: [
//                 Text(
//                   'View All',
//                   style: TextStyle(
//                     color: Color(0xFF1FC9C0),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(width: 6),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: Color(0xFF1FC9C0),
//                   size: 12,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
//           // Conditional content based on login status
//           Expanded(
//             child: _isLoggedIn 
//                 ? _buildLoggedInContent()
//                 : _buildLoginPromptMessage(),
//           ),
//         ],
//       ),
//     ),
//     bottomNavigationBar: BottomAppBar(
//       elevation: 10,
//       color: Colors.teal,
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 6,
//       shadowColor: const Color(0xFF1FC9C0).withOpacity(0.2),
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(Icons.home_outlined, 'Home', 0),
//             _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 1),
//             _buildNavItem(Icons.person_outline, 'Profile', 2),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// New method for logged-in content
Widget _buildLoggedInContent() {
  return SingleChildScrollView(
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
            childAspectRatio: 1.3,
            children: [
              _buildStatTile(
                Icons.folder, 
                'Reports', 
                Colors.blue,
                requiresLogin: true,
              ),
              _buildStatTile(
                Icons.calendar_today, 
                'Appoint', 
                Colors.green,
                //requiresLogin: true,
              ),
              _buildStatTile(
                Icons.medication, 
                'Billing History', 
                Colors.orange,
                requiresLogin: true,
              ),
              _buildStatTile(
                Icons.message, 
                'Summary', 
                Colors.purple,
                requiresLogin: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

// Beautiful login prompt message
Widget _buildLoginPromptMessage() {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1FC9C0).withOpacity(0.1),
                  const Color(0xFF1FC9C0).withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.health_and_safety,
              size: 60,
              color: const Color(0xFF1FC9C0).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          // Main message card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: const Color(0xFF1FC9C0).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Color(0xFF1FC9C0),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Unlock Full Access',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3B4E),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Please login to view your reports, appointments, and other health information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Login button
                ElevatedButton(
                  onPressed: _showLoginScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1FC9C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Login Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Helper text
          Text(
            'Your health data is secure and private',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper method for icon buttons
Widget _buildIconButton({

  required IconData icon,
  required VoidCallback onTap,
  bool hasBadge = false,
}) {
  return Stack(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      if (hasBadge)
        Positioned(
          top: 2,
          right: 2,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
    ],
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
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const HomeScreen()),
          //);
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentsInfoScreen(
                patientMrNo: widget.patientMrNo,
                patientName: widget.patientName,
              ),
            ),
          );
        } else if (title == 'Summary') {
          // Navigate to messages screen (you'll need to create this)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DischargeHistoryScreen(
                patientMrNo: widget.patientMrNo,
              ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // make bold
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

// Widget _buildStatTile(IconData icon, String title, Color color, {bool requiresLogin = false}) {
//   return GestureDetector(
//     onTap: () async {
//       if (requiresLogin) {
//         bool canNavigate = await _checkLoginAndNavigate(context, title.toLowerCase());
//         if (!canNavigate) return;
//       }

//       if (title == 'Reports') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ReportsScreen(
//               patientMrNo: widget.patientMrNo,
//               patientName: widget.patientName,
//               //isLoggedIn: _isLoggedIn,
//             ),
//           ),
//         );
//       } else if (title == 'Billing History') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PatientReportHistoryScreen(
//               patientMrNo: widget.patientMrNo,
//               patientName: widget.patientName,
//               isLoggedIn: _isLoggedIn,
//             ),
//           ),
//         );
//       } else if (title == 'Appointments') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AppointmentsInfoScreen(
//               patientMrNo: widget.patientMrNo,
//               patientName: widget.patientName,
//               isLoggedIn: _isLoggedIn,  // Pass the login status
//             ),
//           ),
//         );
//       } else if (title == 'Messages') {
//         // Navigate to messages screen (you'll need to create this)
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Messages feature coming soon'),
//             backgroundColor: Color(0xFF1FC9C0),
//           ),
//         );
//       }
//     },
//     child: Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           if (requiresLogin && !_isLoggedIn)
//             Positioned(
//               top: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.amber,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.lock_outline,
//                   color: Colors.white,
//                   size: 12,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     ),
//   );
// }}