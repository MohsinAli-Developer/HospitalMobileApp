// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/patient_model.dart';

// class PatientProfilePage extends StatefulWidget {
//   final String mrNo;
  
//   const PatientProfilePage({Key? key, required this.mrNo}) : super(key: key);

//   @override
//   _PatientProfilePageState createState() => _PatientProfilePageState();
// }

// class _PatientProfilePageState extends State<PatientProfilePage> {
//   List<PatientVisit> patientVisits = [];
//   PatientInfo? patientInfo;
//   bool isLoading = true;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchPatientData();
//   }

//   Future<void> fetchPatientData() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       final response = await http.get(
//         Uri.parse('http://172.16.40.10:8080/api/Patient?MR_NO=${widget.mrNo}'),
//         headers: {'accept': '*/*'},
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           patientVisits = data.map((json) => PatientVisit.fromJson(json)).toList();
//           if (patientVisits.isNotEmpty) {
//             patientInfo = PatientInfo(
//               firstName: patientVisits.first.firstName,
//               lastName: patientVisits.first.lastName,
//               gender: patientVisits.first.gender,
//               dateOfBirth: patientVisits.first.dateOfBirth,
//               cnic: patientVisits.first.cnic,
//               contactNo: patientVisits.first.contactNo,
//               bloodGroup: patientVisits.first.bloodGroup,
//             );
//           }
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Failed to load patient data';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Error: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Patient Profile - ${widget.mrNo}'),
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
//                       const SizedBox(height: 16),
//                       Text(
//                         errorMessage,
//                         style: const TextStyle(fontSize: 16, color: Colors.red),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: fetchPatientData,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // Patient Header Card
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[50],
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(30),
//                             bottomRight: Radius.circular(30),
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             CircleAvatar(
//                               radius: 50,
//                               backgroundColor: Colors.blue[800],
//                               child: Text(
//                                 patientInfo?.firstName.substring(0, 1) ?? 'P',
//                                 style: const TextStyle(
//                                   fontSize: 40,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               '${patientInfo?.firstName} ${patientInfo?.lastName ?? ''}',
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue[800],
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 'MR No: ${widget.mrNo}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Personal Information Section
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Personal Information',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Card(
//                               elevation: 2,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16),
//                                 child: Column(
//                                   children: [
//                                     _buildInfoRow(Icons.person, 'Gender', 
//                                         patientInfo?.gender == 'M' ? 'Male' : 
//                                         patientInfo?.gender == 'F' ? 'Female' : 'Not Specified'),
//                                     _buildDivider(),
//                                     _buildInfoRow(Icons.cake, 'Date of Birth', 
//                                         _formatDate(patientInfo?.dateOfBirth ?? '')),
//                                     _buildDivider(),
//                                     _buildInfoRow(Icons.phone, 'Contact', 
//                                         patientInfo?.contactNo ?? 'Not provided'),
//                                     _buildDivider(),
//                                     _buildInfoRow(Icons.credit_card, 'CNIC', 
//                                         patientInfo?.cnic?.isNotEmpty == true 
//                                             ? patientInfo!.cnic! 
//                                             : 'Not provided'),
//                                     _buildDivider(),
//                                     _buildInfoRow(Icons.bloodtype, 'Blood Group', 
//                                         patientInfo?.bloodGroup?.isNotEmpty == true 
//                                             ? patientInfo!.bloodGroup! 
//                                             : 'Not specified'),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             // Visit History Section
//                             const SizedBox(height: 24),
//                             const Text(
//                               'Visit History',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: patientVisits.length,
//                               itemBuilder: (context, index) {
//                                 final visit = patientVisits[index];
//                                 return Card(
//                                   margin: const EdgeInsets.only(bottom: 12),
//                                   elevation: 1,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     side: BorderSide(color: Colors.grey[300]!),
//                                   ),
//                                   child: ListTile(
//                                     leading: CircleAvatar(
//                                       backgroundColor: Colors.blue[100],
//                                       child: Text(
//                                         '${visit.serialNumber}',
//                                         style: TextStyle(
//                                           color: Colors.blue[800],
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     title: Text(
//                                       'Visit Date: ${_formatDate(visit.visitDate)}',
//                                       style: const TextStyle(fontWeight: FontWeight.w500),
//                                     ),
//                                     subtitle: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(height: 4),
//                                         Text('Contact: ${visit.contactNo}'),
//                                       ],
//                                     ),
//                                     isThreeLine: true,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.blue[800]),
//           const SizedBox(width: 12),
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Divider(
//       height: 1,
//       color: Colors.grey[300],
//     );
//   }

//   String _formatDate(String dateTimeString) {
//     if (dateTimeString.isEmpty) return 'Not available';
//     try {
//       DateTime date = DateTime.parse(dateTimeString);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return dateTimeString;
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/patient_model.dart';
import '../utils/date_formatter.dart';
import '../utils/ip_file.dart';

class PatientProfilePage extends StatefulWidget {
  final String mrNo;
  
  const PatientProfilePage({Key? key, required this.mrNo}) : super(key: key);

  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  List<PatientVisit> patientVisits = [];
  PatientInfo? patientInfo;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // First show empty page, then load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPatientData();
    });
  }

  Future<void> fetchPatientData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/Patient?MR_NO=${widget.mrNo}"),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          patientVisits = data.map((json) => PatientVisit.fromJson(json)).toList();
          if (patientVisits.isNotEmpty) {
            patientInfo = PatientInfo(
              firstName: patientVisits.first.firstName,
              lastName: patientVisits.first.lastName,
              gender: patientVisits.first.gender,
              dateOfBirth: patientVisits.first.dateOfBirth,
              cnic: patientVisits.first.cnic,
              contactNo: patientVisits.first.contactNo,
              bloodGroup: patientVisits.first.bloodGroup,
            );
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load patient data';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Patient Profile',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1FC9C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchPatientData,
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingShimmer()
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : _buildProfileContent(),
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Shimmer
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
                Container(
                  width: 200,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Content Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(6, (index) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Oops!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: fetchPatientData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1FC9C0),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Header - Dashboard Style
          _buildPatientHeader(),
          
          const SizedBox(height: 24),
          
          // Personal Information Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),
                _buildPersonalInfoCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Visit History'),
                const SizedBox(height: 16),
                _buildVisitHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF1FC9C0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                patientInfo?.firstName.isNotEmpty == true 
                    ? patientInfo!.firstName[0].toUpperCase()
                    : 'P',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1FC9C0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Patient Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${patientInfo?.firstName} ${patientInfo?.lastName ?? ''}'.trim(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'MR No: ${widget.mrNo}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        if (title == 'Visit History' && patientVisits.isNotEmpty)
          Text(
            '${patientVisits.length} visits',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoTile(
              icon: Icons.person_outline,
              label: 'Gender',
              value: patientInfo?.gender == 'M' ? 'Male' : 
                     patientInfo?.gender == 'F' ? 'Female' : 'Not Specified',
              iconColor: const Color(0xFF1FC9C0),
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.cake_outlined,
              label: 'Date of Birth',
              value: _formatDate(patientInfo?.dateOfBirth ?? ''),
              iconColor: const Color(0xFF1FC9C0),
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.phone_outlined,
              label: 'Contact',
              value: patientInfo?.contactNo.isNotEmpty == true 
                  ? patientInfo!.contactNo 
                  : 'Not provided',
              iconColor: const Color(0xFF1FC9C0),
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.credit_card_outlined,
              label: 'CNIC',
              value: patientInfo?.cnic?.isNotEmpty == true 
                  ? patientInfo!.cnic! 
                  : 'Not provided',
              iconColor: const Color(0xFF1FC9C0),
            ),
            _buildDivider(),
            _buildInfoTile(
              icon: Icons.bloodtype_outlined,
              label: 'Blood Group',
              value: patientInfo?.bloodGroup?.isNotEmpty == true 
                  ? patientInfo!.bloodGroup! 
                  : 'Not specified',
              iconColor: const Color(0xFF1FC9C0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildVisitHistory() {
    if (patientVisits.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No visit history found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patientVisits.length,
      itemBuilder: (context, index) {
        final visit = patientVisits[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1FC9C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${visit.serialNumber}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1FC9C0),
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(visit.visitDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    visit.contactNo.isNotEmpty ? visit.contactNo : 'No contact',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateTimeString) {
    if (dateTimeString.isEmpty) return 'Not available';
    try {
      DateTime date = DateTime.parse(dateTimeString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateTimeString;
    }
  }
}