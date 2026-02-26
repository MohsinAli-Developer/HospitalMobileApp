// import 'package:btih_andriod_app/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:btih_andriod_app/screens/patient_profile_screen.dart';
// import 'doctors_list_screen.dart'; // You'll need to create this screen
// import 'reports_screen.dart';
// import 'login_screen.dart'; // Add this import for the login screen

// class DashboardScreen extends StatefulWidget {
//   final String patientMrNo;
//   final String patientName;

//   const DashboardScreen({
//     super.key,
//     required this.patientMrNo,
//     required this.patientName,
//   });

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _currentIndex = 1; // Dashboard selected
// // Logout function
//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                 );
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.red,
//               ),
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with MR_NO and Patient Name
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF1FC9C0),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(28),
//                   bottomRight: Radius.circular(28),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Hello, ${widget.patientName}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'MR No: ${widget.patientMrNo}',
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
                      
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.notifications_outlined,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Welcome to your health dashboard',
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),

//             // Doctors Bar - Clickable to navigate to Doctors screen
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DoctorsListScreen(
//                         patientMrNo: widget.patientMrNo,
//                         patientName: widget.patientName,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1FC9C0),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF1FC9C0).withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Find a Doctor',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'View All',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Four quick tiles
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     children: [
//                       GridView.count(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                         childAspectRatio: 1.4,
//                         children: [
//                           _buildStatTile(Icons.folder, 'Reports', Colors.blue),
//                           _buildStatTile(Icons.calendar_today, 'Appointments', Colors.green),
//                           _buildStatTile(Icons.medication, 'Medications',  Colors.orange),
//                           _buildStatTile(Icons.message, 'Messages',  Colors.purple),
//                         ],
//                       ),
//                       const SizedBox(height: 20), // Extra space at bottom
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 10,
//         color: const Color(0xFF1FC9C0),
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 6,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(Icons.home_outlined, 'Home', 0),
//               _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 1),
//               _buildNavItem(Icons.person_outline, 'Profile', 2),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     final isSelected = _currentIndex == index;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentIndex = index;
//         });
        
//         if (index == 0) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         } else if (index == 1) {
//           // Already on Dashboard
//         } else if (index == 2) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PatientProfilePage(
//                 mrNo: widget.patientMrNo,
//               ),
//             ),
//           );
//         }
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? Colors.white : Colors.white70,
//             size: 24,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.white70,
//               fontSize: 12,
//               fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatTile(IconData icon, String title, Color color) {
//   return GestureDetector(
//     onTap: () {
//       if (title == 'Reports') {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ReportsScreen(
//               patientMrNo: widget.patientMrNo,
//               patientName: widget.patientName,
//             ),
//           ),
//         );
//       }
//       // Add other navigation for different tiles here
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: color, size: 24),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               //Text(
//                 //subtitle,
//                 //style: const TextStyle(
//                 //  fontSize: 16,
//                //   fontWeight: FontWeight.bold,
//                // ),
// //),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }

import 'package:btih_andriod_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:btih_andriod_app/screens/patient_profile_screen.dart';
import 'doctors_list_screen.dart'; // You'll need to create this screen
import 'reports_screen.dart';
import 'login_screen.dart'; // Add this import for the login screen

class DashboardScreen extends StatefulWidget {
  final String patientMrNo;
  final String patientName;

  const DashboardScreen({
    super.key,
    required this.patientMrNo,
    required this.patientName,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1; // Dashboard selected

  // Logout function
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${widget.patientName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MR No: ${widget.patientMrNo}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Logout Button
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
                          ),
                          // Notification Icon
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
                  const Text(
                    'Welcome to your health dashboard',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Doctors Bar - Clickable to navigate to Doctors screen
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

            // Four quick tiles
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
                          _buildStatTile(Icons.folder, 'Reports', Colors.blue),
                          _buildStatTile(Icons.calendar_today, 'Appointments', Colors.green),
                          _buildStatTile(Icons.medication, 'Medications', Colors.orange),
                          _buildStatTile(Icons.message, 'Messages', Colors.purple),
                        ],
                      ),
                      const SizedBox(height: 20), // Extra space at bottom
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
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 1) {
          // Already on Dashboard
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientProfilePage(
                mrNo: widget.patientMrNo,
              ),
            ),
          );
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

  Widget _buildStatTile(IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'Reports') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportsScreen(
                patientMrNo: widget.patientMrNo,
                patientName: widget.patientName,
              ),
            ),
          );
        }
        // Add other navigation for different tiles here
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
        child: Column(
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
                const SizedBox(height: 4),
                // Text(
                //   subtitle,
                //   style: const TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}