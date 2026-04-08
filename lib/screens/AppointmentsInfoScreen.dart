import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/ip_file.dart';

class AppointmentsInfoScreen extends StatefulWidget {
  final String patientMrNo;
  final String patientName;

  const AppointmentsInfoScreen({
    super.key,
    required this.patientMrNo,
    required this.patientName,
  });

  @override
  State<AppointmentsInfoScreen> createState() => _AppointmentsInfoScreenState();
}

class _AppointmentsInfoScreenState extends State<AppointmentsInfoScreen> {
  List<Appointment> _allAppointments = [];
  List<Appointment> _pastAppointments = [];
  List<Appointment> _currentAppointments = [];
  bool _isLoading = true;
  String? _error;
  int _selectedTabIndex = 0; // 0 for Current, 1 for Past

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/api/Patient/appointments/${widget.patientMrNo}");
      
      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allAppointments = data.map((json) => Appointment.fromJson(json)).toList();
          _filterAppointments();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterAppointments() {
    _pastAppointments = [];
    _currentAppointments = [];
    
    for (var appointment in _allAppointments) {
      // If status is pending, it's a past appointment
      // Otherwise, it's a current appointment
      if (appointment.status.toLowerCase() == 'pending') {
        _currentAppointments.add(appointment);
      } else {
                _pastAppointments.add(appointment);
      }
    }
    
    // Optional: Sort appointments by date (newest first)
    _currentAppointments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _pastAppointments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  String _formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateTimeStr.split('T')[0];
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Appointment> _getCurrentDisplayAppointments() {
    return _selectedTabIndex == 0 ? _currentAppointments : _pastAppointments;
  }

  String _getCurrentTabTitle() {
    return _selectedTabIndex == 0 ? 'Current Appointments' : 'Past Appointments';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1FC9C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.patientName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'MR No: ${widget.patientMrNo}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_allAppointments.length} Total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Tab Bar
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTabIndex = 0;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedTabIndex == 0
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Current',
                                style: TextStyle(
                                  color: _selectedTabIndex == 0
                                      ? const Color(0xFF1FC9C0)
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTabIndex = 1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedTabIndex == 1
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Past',
                                style: TextStyle(
                                  color: _selectedTabIndex == 1
                                      ? const Color(0xFF1FC9C0)
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1FC9C0),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading appointments',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                            _fetchAppointments();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1FC9C0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _getCurrentDisplayAppointments().isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedTabIndex == 0 ? Icons.event_available : Icons.history,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedTabIndex == 0 
                                ? 'No Current Appointments'
                                : 'No Past Appointments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedTabIndex == 0
                                ? 'Your active appointments will appear here'
                                : 'Your completed or pending appointments will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _getCurrentDisplayAppointments().length,
                      itemBuilder: (context, index) {
                        final appointment = _getCurrentDisplayAppointments()[index];
                        final isLatest = _selectedTabIndex == 0 && index == 0;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              if (isLatest && _selectedTabIndex == 0 && index == 0)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1FC9C0).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF1FC9C0),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.fiber_new,
                                        size: 14,
                                        color: Color(0xFF1FC9C0),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Latest Appointment',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1FC9C0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: isLatest && _selectedTabIndex == 0
                                        ? Border.all(
                                            color: const Color(0xFF1FC9C0),
                                            width: 1.5,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      // Header with status
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF1FC9C0)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                  child: const Icon(
                                                    Icons.calendar_today,
                                                    size: 20,
                                                    color: Color(0xFF1FC9C0),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Appointment #${appointment.appointmentId}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      _formatDate(
                                                          appointment.createdAt),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                        appointment.status)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: _getStatusColor(
                                                      appointment.status),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                appointment.status,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: _getStatusColor(
                                                      appointment.status),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Body
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            _buildInfoRow(
                                              Icons.access_time,
                                              'Appointment Time',
                                              appointment.appointmentTime,
                                            ),
                                            const SizedBox(height: 12),
                                            _buildInfoRow(
                                              Icons.person,
                                              'Patient Name',
                                              appointment.name,
                                            ),
                                            const SizedBox(height: 12),
                                            if (appointment.phoneNo != '0')
                                              _buildInfoRow(
                                                Icons.phone,
                                                'Phone Number',
                                                appointment.phoneNo,
                                              ),
                                            if (appointment.phoneNo == '0')
                                              const SizedBox(height: 12),
                                            if (appointment.purpose != 'NILL' &&
                                                appointment.purpose != '')
                                              _buildInfoRow(
                                                Icons.description,
                                                'Purpose',
                                                appointment.purpose,
                                              ),
                                            if (appointment.purpose == 'NILL')
                                              const SizedBox(height: 12),
                                            _buildInfoRow(
                                              Icons.medical_services,
                                              'Doctor Name',
                                              appointment.doctorName,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF1FC9C0),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Appointment {
  final String appointmentId;
  final String name;
  final String phoneNo;
  final String mrNo;
  final String email;
  final int weekId;
  final String appointmentTime;
  final String status;
  final String doctorName;
  final String purpose;
  final String createdAt;

  Appointment({
    required this.appointmentId,
    required this.name,
    required this.phoneNo,
    required this.mrNo,
    required this.email,
    required this.weekId,
    required this.appointmentTime,
    required this.status,
    required this.doctorName,
    required this.purpose,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId']?.toString() ?? '',
      name: json['name'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      mrNo: json['mrNo'] ?? '',
      email: json['email'] ?? '',
      weekId: json['weekId'] ?? 0,
      appointmentTime: json['appointmentTime'] ?? '',
      status: json['status'] ?? '',
      doctorName: json['doctorName'] ?? '',
      purpose: json['purpose'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}


// Updated AppointmentsInfoScreen with local storage support
// import 'dart:convert';
// import 'package:btih_andriod_app/services/apointment_service.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../utils/ip_file.dart';
// import '../utils/database_helper.dart';
// import '../models/local_appointment.dart';

// class AppointmentsInfoScreen extends StatefulWidget {
//   final String patientMrNo;
//   final String patientName;
//   final bool isLoggedIn; // Add this parameter

//   const AppointmentsInfoScreen({
//     super.key,
//     required this.patientMrNo,
//     required this.patientName,
//     this.isLoggedIn = false, // Default to false for guests
//   });

//   @override
//   State<AppointmentsInfoScreen> createState() => _AppointmentsInfoScreenState();
// }

// class _AppointmentsInfoScreenState extends State<AppointmentsInfoScreen> {
//   List<Appointment> _allAppointments = [];
//   List<LocalAppointment> _localAppointments = [];
//   List<dynamic> _pastAppointments = [];
//   List<dynamic> _currentAppointments = [];
//   bool _isLoading = true;
//   String? _error;
//   int _selectedTabIndex = 0; // 0 for Current, 1 for Past

//   @override
//   void initState() {
//     super.initState();
//     _fetchAppointments();
//   }

//   Future<void> _fetchAppointments() async {
//     try {
//       List<Appointment> serverAppointments = [];
//       List<LocalAppointment> localGuestAppointments = [];

//       // Fetch local guest appointments first
//       if (!widget.isLoggedIn) {
//         localGuestAppointments = await DatabaseHelper().getGuestAppointments();
//         setState(() {
//           _localAppointments = localGuestAppointments;
//         });
//       }

//       // If logged in, fetch from server
//       if (widget.isLoggedIn && widget.patientMrNo.isNotEmpty) {
//         final url = Uri.parse("${ApiConfig.baseUrl}/api/Patient/appointments/${widget.patientMrNo}");
        
//         final response = await http.get(
//           url,
//           headers: {
//             'accept': '*/*',
//           },
//         );

//         if (response.statusCode == 200) {
//           final List<dynamic> data = jsonDecode(response.body);
//           serverAppointments = data.map((json) => Appointment.fromJson(json)).toList();
//         } else {
//           throw Exception('Failed to load server appointments');
//         }
//       }

//       setState(() {
//         _allAppointments = serverAppointments;
//         _filterAppointments();
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }
// void _filterAppointments() {
//   _pastAppointments = [];
//   _currentAppointments = [];
  
//   // Process server appointments (now using the updated Appointment model)
//   for (var appointment in _allAppointments) {
//     // Convert Appointment object to a displayable map
//     final displayAppointment = {
//       'appointmentId': appointment.appointmentId,
//       'name': appointment.name,
//       'phoneNo': appointment.phoneNo,
//       'mrNo': appointment.mrNo,
//       'email': appointment.email,
//       'weekId': appointment.weekId,
//       'appointmentTime': appointment.appointmentTime,
//       'status': appointment.status,
//       'doctorName': appointment.doctorName,
//       'purpose': appointment.purpose,
//       'createdAt': appointment.createdAt,
//       'isLocal': false,
//     };
    
//     if (appointment.status.toLowerCase() == 'pending') {
//       _currentAppointments.add(displayAppointment);
//     } else {
//       _pastAppointments.add(displayAppointment);
//     }
//   }
  
//   // Process local guest appointments (only for guest users)
//   if (!widget.isLoggedIn) {
//     for (var localAppointment in _localAppointments) {
//       final displayAppointment = {
//         'appointmentId': localAppointment.appointmentId,
//         'name': localAppointment.name,
//         'phoneNo': localAppointment.phoneNo,
//         'mrNo': localAppointment.mrNo,
//         'email': localAppointment.email,
//         'weekId': localAppointment.weekId,
//         'appointmentTime': localAppointment.appointmentTime,
//         'status': localAppointment.status,
//         'doctorName': localAppointment.doctorName,
//         'purpose': localAppointment.purpose,
//         'createdAt': localAppointment.createdAt,
//         'isLocal': true,
//       };
      
//       // All guest appointments are considered "current" since they're pending
//       _currentAppointments.add(displayAppointment);
//     }
//   }
  
//   // Sort appointments by createdAt (newest first)
//   _currentAppointments.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
//   _pastAppointments.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
// }
//   // void _filterAppointments() {
//   //   _pastAppointments = [];
//   //   _currentAppointments = [];
    
//   //   // Process server appointments
//   //   for (var appointment in _allAppointments) {
//   //     if (appointment.status.toLowerCase() == 'pending') {
//   //       _currentAppointments.add(appointment);
//   //     } else {
//   //       _pastAppointments.add(appointment);
//   //     }
//   //   }
    
//   //   // Process local guest appointments (only for guest users)
//   //   if (!widget.isLoggedIn) {
//   //     for (var localAppointment in _localAppointments) {
//   //       // Convert LocalAppointment to a displayable format
//   //       final displayAppointment = {
//   //         'appointmentId': localAppointment.appointmentId,
//   //         'name': localAppointment.name,
//   //         'phoneNo': localAppointment.phoneNo,
//   //         'mrNo': localAppointment.mrNo,
//   //         'email': localAppointment.email,
//   //         'weekId': localAppointment.weekId,
//   //         'appointmentTime': localAppointment.appointmentTime,
//   //         'status': localAppointment.status,
//   //         'doctorName': localAppointment.doctorName,
//   //         'purpose': localAppointment.purpose,
//   //         'createdAt': localAppointment.createdAt,
//   //         'isLocal': true,
//   //       };
        
//   //       // All guest appointments are considered "current" since they're pending
//   //       _currentAppointments.add(displayAppointment);
//   //     }
//   //   }
    
//   //   // Sort appointments by date (newest first)
//   //   _currentAppointments.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
//   //   _pastAppointments.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
//   // }

//   String _formatDate(String dateTimeStr) {
//     try {
//       final dateTime = DateTime.parse(dateTimeStr);
//       return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
//     } catch (e) {
//       return dateTimeStr.split('T')[0];
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'confirmed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   List<dynamic> _getCurrentDisplayAppointments() {
//     return _selectedTabIndex == 0 ? _currentAppointments : _pastAppointments;
//   }

//   String _getCurrentTabTitle() {
//     return _selectedTabIndex == 0 ? 'Current Appointments' : 'Past Appointments';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'My Appointments',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color(0xFF1FC9C0),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(100),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.patientName,
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           widget.isLoggedIn 
//                               ? 'MR No: ${widget.patientMrNo}'
//                               : 'Guest User',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.white24,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         '${_allAppointments.length + _localAppointments.length} Total',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Tab Bar
//                 Container(
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white24,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _selectedTabIndex = 0;
//                             });
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: _selectedTabIndex == 0
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Current',
//                                 style: TextStyle(
//                                   color: _selectedTabIndex == 0
//                                       ? const Color(0xFF1FC9C0)
//                                       : Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _selectedTabIndex = 1;
//                             });
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: _selectedTabIndex == 1
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Past',
//                                 style: TextStyle(
//                                   color: _selectedTabIndex == 1
//                                       ? const Color(0xFF1FC9C0)
//                                       : Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF1FC9C0),
//               ),
//             )
//           : _error != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 64,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Error loading appointments',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         _error!,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _isLoading = true;
//                             _error = null;
//                             _fetchAppointments();
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF1FC9C0),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : _getCurrentDisplayAppointments().isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             _selectedTabIndex == 0 ? Icons.event_available : Icons.history,
//                             size: 64,
//                             color: Colors.grey[400],
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             _selectedTabIndex == 0 
//                                 ? 'No Current Appointments'
//                                 : 'No Past Appointments',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             _selectedTabIndex == 0
//                                 ? 'Your active appointments will appear here'
//                                 : 'Your completed or pending appointments will appear here',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[500],
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _getCurrentDisplayAppointments().length,
//                       itemBuilder: (context, index) {
//                         final appointment = _getCurrentDisplayAppointments()[index];
//                         final isLatest = _selectedTabIndex == 0 && index == 0;
//                         final isLocal = appointment['isLocal'] == true;
                        
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           child: Column(
//                             children: [
//                               if (isLatest && _selectedTabIndex == 0 && index == 0)
//                                 Container(
//                                   margin: const EdgeInsets.only(bottom: 8),
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                       color: const Color(0xFF1FC9C0),
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.fiber_new,
//                                         size: 14,
//                                         color: const Color(0xFF1FC9C0),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         isLocal ? 'Local Appointment' : 'Latest Appointment',
//                                         style: const TextStyle(
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w600,
//                                           color: Color(0xFF1FC9C0),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               Card(
//                                 elevation: 2,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(16),
//                                     border: isLatest && _selectedTabIndex == 0
//                                         ? Border.all(
//                                             color: const Color(0xFF1FC9C0),
//                                             width: 1.5,
//                                           )
//                                         : null,
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       // Header with status
//                                       Container(
//                                         padding: const EdgeInsets.all(16),
//                                         decoration: BoxDecoration(
//                                           color: isLocal ? Colors.orange[50] : Colors.grey[50],
//                                           borderRadius: const BorderRadius.only(
//                                             topLeft: Radius.circular(16),
//                                             topRight: Radius.circular(16),
//                                           ),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   padding: const EdgeInsets.all(8),
//                                                   decoration: BoxDecoration(
//                                                     color: const Color(0xFF1FC9C0)
//                                                         .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(12),
//                                                   ),
//                                                   child: Icon(
//                                                     isLocal ? Icons.offline_bolt : Icons.calendar_today,
//                                                     size: 20,
//                                                     color: const Color(0xFF1FC9C0),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 12),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         // Text(
//                                                         //   //'Appointment #${appointment['appointmentId']}',
//                                                         //   style: const TextStyle(
//                                                         //     fontSize: 16,
//                                                         //     fontWeight: FontWeight.bold,
//                                                         //   ),
//                                                         // ),
//                                                         if (isLocal) ...[
//                                                           const SizedBox(width: 8),
//                                                           Container(
//                                                             padding: const EdgeInsets.symmetric(
//                                                               horizontal: 6,
//                                                               vertical: 2,
//                                                             ),
//                                                             decoration: BoxDecoration(
//                                                               color: Colors.orange,
//                                                               borderRadius: BorderRadius.circular(4),
//                                                             ),
//                                                             child: const Text(
//                                                               'Local',
//                                                               style: TextStyle(
//                                                                 fontSize: 10,
//                                                                 color: Colors.white,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ],
//                                                     ),
//                                                     const SizedBox(height: 4),
//                                                     Text(
//                                                       _formatDate(appointment['createdAt']),
//                                                       style: TextStyle(
//                                                         fontSize: 12,
//                                                         color: Colors.grey[600],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                             Container(
//                                               padding: const EdgeInsets.symmetric(
//                                                 horizontal: 12,
//                                                 vertical: 6,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: _getStatusColor(appointment['status'])
//                                                     .withOpacity(0.1),
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                                 border: Border.all(
//                                                   color: _getStatusColor(appointment['status']),
//                                                   width: 1,
//                                                 ),
//                                               ),
//                                               child: Text(
//                                                 appointment['status'],
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: _getStatusColor(appointment['status']),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       // Body
//                                       Padding(
//                                         padding: const EdgeInsets.all(16),
//                                         child: Column(
//                                           children: [
//                                             _buildInfoRow(
//                                               Icons.access_time,
//                                               'Appointment Time',
//                                               appointment['appointmentTime'],
//                                             ),
//                                             const SizedBox(height: 12),
//                                             _buildInfoRow(
//                                               Icons.person,
//                                               'Patient Name',
//                                               appointment['name'],
//                                             ),
//                                             const SizedBox(height: 12),
//                                             if (appointment['phoneNo'] != '0')
//                                               _buildInfoRow(
//                                                 Icons.phone,
//                                                 'Phone Number',
//                                                 appointment['phoneNo'],
//                                               ),
//                                             if (appointment['phoneNo'] == '0')
//                                               const SizedBox(height: 12),
//                                             if (appointment['purpose'] != 'NILL' &&
//                                                 appointment['purpose'] != '')
//                                               _buildInfoRow(
//                                                 Icons.description,
//                                                 'Purpose',
//                                                 appointment['purpose'],
//                                               ),
//                                             if (appointment['purpose'] == 'NILL')
//                                               const SizedBox(height: 12),
//                                             _buildInfoRow(
//                                               Icons.medical_services,
//                                               'Doctor Name',
//                                               appointment['doctorName'],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: const Color(0xFF1FC9C0),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }