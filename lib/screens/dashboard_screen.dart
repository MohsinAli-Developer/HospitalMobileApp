// import 'package:btih_andriod_app/models/doctors_model.dart';
// import 'package:btih_andriod_app/screens/home_screen.dart';
// import 'package:btih_andriod_app/services/doctors_service.dart';
// import 'package:flutter/material.dart';
// import 'doctor_schedule_screen.dart';
// import 'package:btih_andriod_app/screens/patient_profile_screen.dart';

// class DashboardScreen extends StatefulWidget {
//     final String patientMrNo; // Make it required, not optional

//   const DashboardScreen({super.key,
//       required this.patientMrNo, // Now required
// });

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
// class _DashboardScreenState extends State<DashboardScreen> {
//   int _currentIndex = 1; // Dashboard selected

//   final DoctorService _doctorService = DoctorService();
//   List<Doctor> doctors = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadDoctors();
//   }
//   void loadDoctors() async {
//   try {
//     final data = await _doctorService.getDoctors();

//     print("Doctors Count: ${data.length}");

//     setState(() {
//       doctors = data;
//       isLoading = false;
//     });
//   } catch (e) {
//     print("Doctor Load Error: $e");
//     setState(() {
//       isLoading = false;
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF1FC9C0),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(28),
//                     bottomRight: Radius.circular(28),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Hello, Ali',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     const Text(
//                       'We will help you find the best doctor',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 14),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: const TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Search doctor, category...',
//                           prefixIcon: Icon(Icons.search),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: SizedBox(
//                   height: 120,
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 20,
//                     physics: const NeverScrollableScrollPhysics(),
//                     childAspectRatio: 3.4,
//                     children: [
//                       _quickTile(Icons.folder, 'Records'),
//                       _quickTile(
//                         Icons.calendar_today,
//                         'Appointments',
//                         onTap: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (_) => const AppointmentsScreen(),
//                           //   ),
//                           // );
//                         },
//                       ),
//                       _quickTile(Icons.medication, 'Medications'),
//                       _quickTile(Icons.message, 'Messages'),
//                     ],
//                   ),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   'Categories',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: SizedBox(
//                   height: 42,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       _categoryChip('Psychology'),
//                       _categoryChip('Cardiology'),
//                       _categoryChip('Dermatology'),
//                       _categoryChip('Pediatrics'),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//   height: 190,
//   child: isLoading
//       ? const Center(child: CircularProgressIndicator())
//       : ListView.builder(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.only(left: 20),
//           itemCount: doctors.length,
//           itemBuilder: (context, index) {
//             final doctor = doctors[index];
//             return Padding(
//               padding: const EdgeInsets.only(right: 14),
//               child: GestureDetector(
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => DoctorScheduleScreen(
//           doctorId: doctor.id,
//           doctorName: doctor.doctorName,
//         ),
//       ),
//     );
//   },
//   child: DoctorCardHorizontal(
//     name: doctor.doctorName,
//     specialty: doctor.specializationName,
//       imagePath: doctor.doctorImagePath,

//   ),
// ),
//             );
//           },
//         ),
// ),

//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Material(
//   elevation: 10,
//   child: ClipRRect(
//     borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//     child: BottomNavigationBar(
//       backgroundColor: const Color(0xFF1FC9C0),
//       currentIndex: _currentIndex,
//       selectedItemColor: Colors.white,
//       unselectedItemColor: Colors.grey,
//       type: BottomNavigationBarType.fixed,
//       onTap: (index) {
//         setState(() {
//           _currentIndex = index;
//         });
//         if (index == 0) {
//           // Home
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//           );
//         } else if (index == 1) {
//           // Dashboard (current) - Pass MR_NO
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DashboardScreen(
//                 patientMrNo: widget.patientMrNo, // Pass MR_NO, remove const
//               ),
//             ),
//           );
//         } else if (index == 2) {
//           // Profile - Pass MR_NO
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PatientProfilePage(
//                 mrNo: widget.patientMrNo, // Pass MR_NO, remove const
//               ),
//             ),
//           );
//         }
//       },
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.dashboard_outlined),
//           label: 'Dashboard',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           label: 'Profile',
//         ),
//       ],
//     ),
//   ),
// ),    );
//   }

//   static Widget _categoryChip(String title) {
//     return Container(
//       margin: const EdgeInsets.only(right: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 18),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F4F6),
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Text(title),
//     );
//   }

//   static Widget _quickTile(IconData icon, String title, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF3F4F6),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 44,
//               height: 64,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: const Color(0xFF1FC9C0), size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DoctorCardHorizontal extends StatelessWidget {
//   final String name;
//   final String specialty;
//   final String? imagePath;

//   const DoctorCardHorizontal({
//     super.key,
//     required this.name,
//     required this.specialty,
//     this.imagePath,
//   });

//   @override
//   Widget build(BuildContext context) {
//   return Container(
//     width: 200,
//     padding: const EdgeInsets.all(12),
//     decoration: BoxDecoration(
//       color: const Color(0xFFF3F4F6),
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: const [
//         BoxShadow(
//           color: Color(0x11000000),
//           blurRadius: 8,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Fixed doctor image container - clean error handling
//         Container(
//           width: double.infinity,
//           height: 90,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: imagePath != null && imagePath!.isNotEmpty
//                 ? Image.network(
//                     imagePath!,
//                     fit: BoxFit.contain,
//                     width: double.infinity,
//                     height: 90,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                         child: const Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Color(0xFF1FC9C0),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                         child: const Icon(
//                           Icons.person,
//                           size: 50,
//                           color: Color(0xFF1FC9C0),
//                         ),
//                       );
//                     },
//                   )
//                 : Container(
//                     color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                     child: const Icon(
//                       Icons.person,
//                       size: 50,
//                       color: Color(0xFF1FC9C0),
//                     ),
//                   ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         // Rest of your widget...

//           /// Doctor Name
//           Text(
//             name,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),

//           const SizedBox(height: 6),

//           /// Specialization
//           Text(
//             specialty,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:btih_andriod_app/models/doctors_model.dart';
import 'package:btih_andriod_app/screens/home_screen.dart';
import 'package:btih_andriod_app/services/doctors_service.dart';
import 'package:flutter/material.dart';
import 'doctor_schedule_screen.dart';
import 'package:btih_andriod_app/screens/patient_profile_screen.dart';
import 'doctors_list_screen.dart'; // You'll need to create this screen
import 'reports_screen.dart';
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
                          _buildStatTile(Icons.folder, 'Reports', '12 Reports', Colors.blue),
                          _buildStatTile(Icons.calendar_today, 'Appointments', '3 Upcoming', Colors.green),
                          _buildStatTile(Icons.medication, 'Medications', '5 Active', Colors.orange),
                          _buildStatTile(Icons.message, 'Messages', '2 Unread', Colors.purple),
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

  Widget _buildStatTile(IconData icon, String title, String subtitle, Color color) {
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
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}