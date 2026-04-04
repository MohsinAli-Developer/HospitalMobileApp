// import 'package:btih_andriod_app/models/doctors_model.dart';
// import 'package:btih_andriod_app/models/specialization_model.dart';
// import 'package:btih_andriod_app/services/doctors_service.dart';
// import 'package:btih_andriod_app/services/specialization_service.dart';
// import 'package:flutter/material.dart';
// import 'doctor_schedule_screen.dart';

// class DoctorsListScreen extends StatefulWidget {
//   final String patientMrNo;
//   final String patientName;
//   final bool isLoggedIn;

//   const DoctorsListScreen({
//     super.key,
//     required this.patientMrNo,
//     required this.patientName,
//     this.isLoggedIn = false,
//   });

//   @override
//   State<DoctorsListScreen> createState() => _DoctorsListScreenState();
// }

// class _DoctorsListScreenState extends State<DoctorsListScreen> {
//   final DoctorService _doctorService = DoctorService();
//   final SpecializationService _specializationService = SpecializationService();
  
//   List<Specialization> specializations = [];
//   List<Doctor> allDoctors = [];
//   List<Doctor> filteredDoctors = [];
  
//   String? selectedSpecialization;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     try {
//       // Load both specializations and doctors in parallel
//       final results = await Future.wait([
//         _specializationService.getSpecializations(),
//         _doctorService.getDoctors(),
//       ]);
      
//       setState(() {
//         specializations = results[0] as List<Specialization>;
//         allDoctors = results[1] as List<Doctor>;
//         filteredDoctors = allDoctors; // Initially show all doctors
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Data Load Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void filterDoctorsBySpecialization(String? specializationName) {
//     setState(() {
//       selectedSpecialization = specializationName;
//       if (specializationName == null || specializationName.isEmpty) {
//         filteredDoctors = allDoctors;
//       } else {
//         filteredDoctors = allDoctors
//             .where((doctor) => doctor.specializationName == specializationName)
//             .toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1FC9C0),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Find a Doctor',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Specialization Dropdown
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border(
//                       bottom: BorderSide(
//                         color: Colors.grey.shade200,
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                   child: DropdownButtonFormField<String>(
//                     value: selectedSpecialization,
//                     decoration: InputDecoration(
//                       labelText: 'Select Specialization',
//                       labelStyle: TextStyle(color: Colors.grey.shade600),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Color(0xFF1FC9C0)),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.shade50,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                     hint: const Text('All Specializations'),
//                     items: [
//                       const DropdownMenuItem<String>(
//                         value: null,
//                         child: Text('All Specializations'),
//                       ),
//                       ...specializations.map((specialization) {
//                         return DropdownMenuItem<String>(
//                           value: specialization.specializationName,
//                           child: Text(specialization.specializationName),
//                         );
//                       }),
//                     ],
//                     onChanged: filterDoctorsBySpecialization,
//                     icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1FC9C0)),
//                     dropdownColor: Colors.white,
//                     isExpanded: true,
//                   ),
//                 ),
                
//                 // Doctors Grid
//                 Expanded(
//                   child: filteredDoctors.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.medical_services,
//                                 size: 64,
//                                 color: Colors.grey.shade400,
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 'No doctors found in this specialization',
//                                 style: TextStyle(
//                                   color: Colors.grey.shade600,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : GridView.builder(
//                           padding: EdgeInsets.only(
//                             left: 16,
//                             right: 16,
//                             top: 16,
//                             bottom: MediaQuery.of(context).padding.bottom + 16,
//                           ),
//                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 16,
//                             mainAxisSpacing: 16,
//                             childAspectRatio: 0.68,
//                           ),
//                           itemCount: filteredDoctors.length,
//                           itemBuilder: (context, index) {
//                             final doctor = filteredDoctors[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => DoctorScheduleScreen(
//                                       doctorId: doctor.id,
//                                       doctorName: doctor.doctorName,
//                                       patientMrNo: widget.patientMrNo,
//                                       patientName: widget.patientName,
//                                       departmentId: doctor.departmentId,
//                                       isLoggedIn: widget.isLoggedIn,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF3F4F6),
//                                   borderRadius: BorderRadius.circular(16),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Color(0x11000000),
//                                       blurRadius: 8,
//                                       offset: Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     // Image
//                                     Container(
//                                       height: 95,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(12),
//                                         child: doctor.doctorImagePath != null &&
//                                                 doctor.doctorImagePath!.isNotEmpty
//                                             ? Image.network(
//                                                 doctor.doctorImagePath!,
//                                                 fit: BoxFit.contain,
//                                                 errorBuilder: (context, error, stackTrace) {
//                                                   return Container(
//                                                     color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                                                     child: const Icon(
//                                                       Icons.person,
//                                                       size: 40,
//                                                       color: Color(0xFF1FC9C0),
//                                                     ),
//                                                   );
//                                                 },
//                                               )
//                                             : Container(
//                                                 color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                                                 child: const Icon(
//                                                   Icons.person,
//                                                   size: 40,
//                                                   color: Color(0xFF1FC9C0),
//                                                 ),
//                                               ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     // Expanded Text Section
//                                     Expanded(
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             doctor.doctorName,
//                                             textAlign: TextAlign.center,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 13,
//                                             ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             doctor.specializationName,
//                                             textAlign: TextAlign.center,
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 11,
//                                             ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'package:btih_andriod_app/models/doctors_model.dart';
import 'package:btih_andriod_app/models/specialization_model.dart';
import 'package:btih_andriod_app/services/doctors_service.dart';
import 'package:btih_andriod_app/services/specialization_service.dart';
import 'package:flutter/material.dart';
import 'doctor_schedule_screen.dart';

class DoctorsListScreen extends StatefulWidget {
  final String patientMrNo;
  final String patientName;
  final bool isLoggedIn;

  const DoctorsListScreen({
    super.key,
    required this.patientMrNo,
    required this.patientName,
    this.isLoggedIn = false,
  });

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final DoctorService _doctorService = DoctorService();
  final SpecializationService _specializationService = SpecializationService();
  
  List<Specialization> specializations = [];
  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];
  
  String? selectedSpecialization;
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Load both specializations and doctors in parallel
      final results = await Future.wait([
        _specializationService.getSpecializations(),
        _doctorService.getDoctors(),
      ]);
      
      setState(() {
        specializations = results[0] as List<Specialization>;
        allDoctors = results[1] as List<Doctor>;
        filteredDoctors = allDoctors; // Initially show all doctors
        isLoading = false;
      });
    } catch (e) {
      print("Data Load Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterDoctors() {
    setState(() {
      filteredDoctors = allDoctors.where((doctor) {
        // Filter by specialization
        if (selectedSpecialization != null && 
            selectedSpecialization!.isNotEmpty &&
            doctor.specializationName != selectedSpecialization) {
          return false;
        }
        
        // Filter by search query
        if (searchQuery.isNotEmpty) {
          return doctor.doctorName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                 doctor.specializationName.toLowerCase().contains(searchQuery.toLowerCase());
        }
        
        return true;
      }).toList();
    });
  }

  void filterDoctorsBySpecialization(String? specializationName) {
    selectedSpecialization = specializationName;
    filterDoctors();
  }

  void searchDoctors(String query) {
    searchQuery = query;
    filterDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1FC9C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find a Doctor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FC9C0)),
              ),
            )
          : Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: searchDoctors,
                        decoration: InputDecoration(
                          hintText: 'Search by doctor name or specialization...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF1FC9C0)),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    searchDoctors('');
                                    setState(() {
                                      searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFF1FC9C0), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Specialization Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedSpecialization,
                        decoration: InputDecoration(
                          labelText: 'Select Specialization',
                          labelStyle: TextStyle(color: Colors.grey.shade600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1FC9C0)),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        hint: const Text('All Specializations'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Specializations'),
                          ),
                          ...specializations.map((specialization) {
                            return DropdownMenuItem<String>(
                              value: specialization.specializationName,
                              child: Text(specialization.specializationName),
                            );
                          }),
                        ],
                        onChanged: filterDoctorsBySpecialization,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1FC9C0)),
                        dropdownColor: Colors.white,
                        isExpanded: true,
                      ),
                    ],
                  ),
                ),
                
                // Results count
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredDoctors.length} doctors available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1FC9C0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.list,
                              size: 14,
                              color: Color(0xFF1FC9C0),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'List View',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1FC9C0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Doctors List
                Expanded(
                  child: filteredDoctors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.medical_services,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No doctors found',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search or filters',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor = filteredDoctors[index];
                            return _buildDoctorListItem(doctor);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildDoctorListItem(Doctor doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorScheduleScreen(
              doctorId: doctor.id,
              doctorName: doctor.doctorName,
              patientMrNo: widget.patientMrNo,
              patientName: widget.patientName,
              departmentId: doctor.departmentId,
              isLoggedIn: widget.isLoggedIn,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Image
            Container(
              width: 85,
              height: 105,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1FC9C0).withOpacity(0.1),
                    const Color(0xFF1FC9C0).withOpacity(0.05),
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: doctor.doctorImagePath != null && doctor.doctorImagePath!.isNotEmpty
                    ? Image.network(
                        doctor.doctorImagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF1FC9C0).withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF1FC9C0),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFF1FC9C0).withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF1FC9C0),
                        ),
                      ),
              ),
            ),
            
            // Doctor Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   // Row(
                     // children: [
                        //Expanded(
                           Text(
                            doctor.doctorName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1FC9C0).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                       crossAxisAlignment: CrossAxisAlignment.start, // Changed to start

                        children: [
                          const Icon(
                            Icons.medical_services,
                            size: 14,
                            color: Color(0xFF1FC9C0),
                          ),
                          const SizedBox(width: 4),
                          Expanded( // Added Expanded to allow text wrapping
                          child: Text(
                            doctor.specializationName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1FC9C0),
                            ),
                            maxLines: 2, // Allow up to 2 lines
                        overflow: TextOverflow.ellipsis, // Show ellipsis if more than 2 lines
                        softWrap: true, // Allow text wrapping
                          ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Icon(
                        //   Icons.schedule,
                        //   size: 14,
                        //   color: Colors.grey.shade500,
                        // ),
                        const SizedBox(width: 4),
                        // Text(
                        //   'Available Today',
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.grey.shade600,
                        //   ),
                        // ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1FC9C0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Schedule Appointment',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}