// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class ReportsScreen extends StatefulWidget {
//   final String patientMrNo;
//   final String patientName;

//   const ReportsScreen({
//     super.key,
//     required this.patientMrNo,
//     required this.patientName,
//   });

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   List<Map<String, dynamic>> laboratoryReports = [];
//   List<Map<String, dynamic>> gastroReports = [];
//   List<Map<String, dynamic>> radiologyReports = [];
//   List<Map<String, dynamic>> prescriptionReports = [];

//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     fetchAllReports();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchAllReports() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       // Fetch all reports concurrently
//       await Future.wait([
//         fetchLaboratoryReports(),
//         fetchGastroReports(),
//         fetchRadiologyReports(),
//         fetchPrescriptionReports(),
//       ]);

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error fetching reports: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchLaboratoryReports() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/labReports'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           laboratoryReports = data.map((item) => {
//             'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
//             'date': item['dT_SAMPLECOLLECTION'] ?? '',
//             'pat_diag_id': item['paT_DIAG_ID'],
//             'status': 'Completed',
//             'modality': item['modalitY_NM'] ?? '',
//             'testtype': item['testtype'] ?? '',
//             'icon': _getIconForTest(item['diagnostiC_NAME'] ?? ''),
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching laboratory reports: $e');
//     }
//   }

//   Future<void> fetchGastroReports() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/gastroReports'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           gastroReports = data.map((item) => {
//             'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
//             'date': item['dT_SAMPLECOLLECTION'] ?? '',
//             'pat_diag_id': item['paT_DIAG_ID'],
//             'status': 'Completed',
//             'modality': item['modalitY_NM'] ?? '',
//             'testtype': item['testtype'] ?? '',
//             'icon': Icons.medical_services, // Icon for gastro reports
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching gastro reports: $e');
//     }
//   }

//   Future<void> fetchRadiologyReports() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/radiologyReports'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           radiologyReports = data.map((item) => {
//             'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
//             'date': item['dT_SAMPLECOLLECTION'] ?? '',
//             'pat_diag_id': item['paT_DIAG_ID'],
//             'status': 'Completed',
//             'modality': item['modalitY_NM'] ?? '',
//             'testtype': item['testtype'] ?? '',
//             'icon': Icons.radio, // Icon for radiology reports
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching radiology reports: $e');
//     }
//   }

// Future<void> fetchPrescriptionReports() async {
//   try {
//     final response = await http.get(
//       Uri.parse(
//           'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/prescriptionReports'),
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       setState(() {
//         prescriptionReports = data.map((item) => {
//           'name': 'Prescription - ${item['doctor'] ?? 'Dr. Unknown'}',
//           'date': item['visiT_DATE'] ?? '',
//           'pat_visit_id': item['paT_VISIT_ID'], // Note: using pat_visit_id instead of pat_diag_id
//           'doctor': item['doctor'] ?? 'Unknown Doctor',
//           'department': item['department'] ?? 'Unknown Department',
//           'status': 'Completed',
//           'icon': Icons.assignment, // Icon for prescription reports
//           'visit_date': item['visiT_DATE'] ?? '',
//         }).toList();
//       });
//     }
//   } catch (e) {
//     print('Error fetching prescription reports: $e');
//   }
// }

//   IconData _getIconForTest(String testName) {
//     String name = testName.toLowerCase();
//     if (name.contains('glucose')) return Icons.bloodtype;
//     if (name.contains('lipid')) return Icons.opacity;
//     if (name.contains('liver')) return Icons.healing;
//     if (name.contains('thyroid')) return Icons.monitor_heart;
//     if (name.contains('urine')) return Icons.water_drop;
//     if (name.contains('vitamin')) return Icons.wb_sunny;
//     if (name.contains('x-ray')) return Icons.medical_services;
//     if (name.contains('mri')) return Icons.monitor_heart;
//     if (name.contains('ct')) return Icons.view_in_ar;
//     return Icons.science;
//   }

//   String _formatDateFromAPI(String dateString) {
//     if (dateString.isEmpty) return '';
//     try {
//       DateTime dateTime = DateTime.parse(dateString);
//       return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return dateString;
//     }
//   }

// void _openReport(Map<String, dynamic> report) async {
//   final patDiagId = report['pat_diag_id'];
//   if (patDiagId == null) return;

//   String reportName = '';
//   String rptId = '';
//   String parameters = patDiagId.toString(); // default

//   final testType = report['testtype']?.toString().toUpperCase() ?? '';
//   final modality = report['modality']?.toString().toUpperCase() ?? '';

//   // ✅ Decide report type + correct rptId
//   if (testType == 'LABORATORY' || modality.contains('LAB')) {
//     reportName = 'Labrpt';
//     rptId = '19';
//   } 
//   else if (testType == 'GASTRO' || modality.contains('GASTRO')) {
//     reportName = 'GastRpt';
//     rptId = '64';
//   } 
//   else if (testType == 'RADIOLOGY' || modality.contains('RADIOLOGY')) {
//     reportName = 'RadRpt';
//     rptId = '22';
//   } 
//   else {
//     reportName = 'Prescrpt';
//     rptId = '19';
//   }

//   final pdfUrl =
//       'http://172.16.40.10:8080/api/PatientReport/GenerateReport'
//       '?rptId=$rptId'
//       '&reportName=$reportName'
//       '&parameters=$parameters'
//       '&user=MobileApp';

//   try {
//     // Show loader
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );

//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = '${dir.path}/${reportName}_$parameters.pdf';

//     final dio = Dio();
//     dio.options.connectTimeout = const Duration(seconds: 30);
//     dio.options.receiveTimeout = const Duration(seconds: 30);

//     final response = await dio.get(
//       pdfUrl,
//       options: Options(responseType: ResponseType.bytes),
//     );

//     final contentType = response.headers.value("content-type");

//     if (contentType == null || !contentType.contains("application/pdf")) {
//       Navigator.pop(context);
//       throw Exception("Server did not return a valid PDF");
//     }

//     final file = File(filePath);
//     await file.writeAsBytes(response.data, flush: true);

//     Navigator.pop(context);

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text(report['name'] ?? 'Report'),
//             backgroundColor: const Color(0xFF1FC9C0),
//           ),
//           body: SfPdfViewer.file(
//             File(filePath),
//           ),
//         ),
//       ),
//     );
//   } catch (e) {
//     Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error opening report: $e")),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1FC9C0),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Medical Reports',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//             ),
//             Text(
//               'MR No: ${widget.patientMrNo}',
//               style: const TextStyle(color: Colors.white70, fontSize: 12),
//             ),
//           ],
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           indicatorWeight: 3,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           isScrollable: true,
//           tabs: const [
//             Tab(text: 'Laboratory'),
//             Tab(text: 'Gastro'),
//             Tab(text: 'Radiology'),
//             Tab(text: 'Prescription'),
//           ],
//         ),
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: Color(0xFF1FC9C0)))
//           : errorMessage != null
//               ? Center(child: Text(errorMessage!))
//               : TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildReportsGrid(laboratoryReports),
//                     _buildReportsGrid(gastroReports),
//                     _buildReportsGrid(radiologyReports),
//                     _buildReportsGrid(prescriptionReports),
//                   ],
//                 ),
//     );
//   }

//   // Widget _buildReportsGrid(List<Map<String, dynamic>> reports) {
//   //   if (reports.isEmpty) {
//   //     return const Center(child: Text('No reports available'));
//   //   }

//   //   return Padding(
//   //     padding: const EdgeInsets.all(12),
//   //     child: GridView.builder(
//   //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //         crossAxisCount: 2,
//   //         crossAxisSpacing: 12,
//   //         mainAxisSpacing: 12,
//   //         childAspectRatio: 1.3,
//   //       ),
//   //       itemCount: reports.length,
//   //       itemBuilder: (context, index) {
//   //         final report = reports[index];
//   //         String formattedDate = _formatDateFromAPI(report['date'] ?? '');
//   //         return GestureDetector(
//   //           onTap: () => _openReport(report),
//   //           child: Container(
//   //             decoration: BoxDecoration(
//   //               color: Colors.white,
//   //               borderRadius: BorderRadius.circular(16),
//   //               boxShadow: [
//   //                 BoxShadow(
//   //                   color: Colors.grey.withOpacity(0.1),
//   //                   spreadRadius: 1,
//   //                   blurRadius: 4,
//   //                   offset: const Offset(0, 2),
//   //                 ),
//   //               ],
//   //             ),
//   //             child: Padding(
//   //               padding: const EdgeInsets.all(10),
//   //               child: Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Row(
//   //                     children: [
//   //                       Container(
//   //                         padding: const EdgeInsets.all(6),
//   //                         decoration: BoxDecoration(
//   //                           color: const Color(0xFF1FC9C0).withOpacity(0.1),
//   //                           borderRadius: BorderRadius.circular(8),
//   //                         ),
//   //                         child: Icon(
//   //                           report['icon'] ?? Icons.description,
//   //                           color: const Color(0xFF1FC9C0),
//   //                           size: 18,
//   //                         ),
//   //                       ),
//   //                       const SizedBox(width: 6),
//   //                       Expanded(
//   //                         child: Text(
//   //                           formattedDate,
//   //                           style: TextStyle(
//   //                             fontSize: 10,
//   //                             color: Colors.grey[600],
//   //                           ),
//   //                           maxLines: 1,
//   //                           overflow: TextOverflow.ellipsis,
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 8),
//   //                   Text(
//   //                     report['name'] ?? '',
//   //                     style: const TextStyle(
//   //                       fontWeight: FontWeight.bold,
//   //                       fontSize: 13,
//   //                     ),
//   //                     maxLines: 2,
//   //                     overflow: TextOverflow.ellipsis,
//   //                   ),
//   //                   const SizedBox(height: 6),
//   //                   Container(
//   //                     padding:
//   //                         const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//   //                     decoration: BoxDecoration(
//   //                       color: Colors.green.withOpacity(0.1),
//   //                       borderRadius: BorderRadius.circular(10),
//   //                     ),
//   //                     child: Text(
//   //                       report['status'] ?? 'Completed',
//   //                       style: const TextStyle(
//   //                         color: Colors.green,
//   //                         fontSize: 10,
//   //                         fontWeight: FontWeight.w600,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }

//  Widget _buildReportsGrid(List<Map<String, dynamic>> reports) {
//   if (reports.isEmpty) {
//     return const Center(child: Text('No reports available'));
//   }

//   return Padding(
//     padding: const EdgeInsets.all(12),
//     child: GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 1.2, // 👈 Changed from 1.3 to 1.2 to give more vertical space
//       ),
//       itemCount: reports.length,
//       itemBuilder: (context, index) {
//         final report = reports[index];
//         String formattedDate = _formatDateFromAPI(report['date'] ?? '');
        
//         return GestureDetector(
//           onTap: () => _openReport(report),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8), // 👈 Reduced from 10 to 8
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min, // 👈 Added to minimize column height
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           report['icon'] ?? Icons.description,
//                           color: const Color(0xFF1FC9C0),
//                           size: 16, // 👈 Reduced from 18 to 16
//                         ),
//                       ),
//                       const SizedBox(width: 4), // 👈 Reduced from 6 to 4
//                       Expanded(
//                         child: Text(
//                           formattedDate,
//                           style: TextStyle(
//                             fontSize: 9, // 👈 Reduced from 10 to 9
//                             color: Colors.grey[600],
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6), // 👈 Reduced from 8 to 6
//                   Text(
//                     report['name'] ?? '',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12, // 👈 Reduced from 13 to 12
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   if (report['doctor'] != null) ...[
//                     const SizedBox(height: 2), // 👈 Reduced from 4 to 2
//                     Text(
//                       report['doctor'],
//                       style: TextStyle(
//                         fontSize: 10, // 👈 Reduced from 11 to 10
//                         color: Colors.grey[600],
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                   if (report['department'] != null) ...[
//                     const SizedBox(height: 2),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), // 👈 Reduced padding
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8), // 👈 Reduced from 10 to 8
//                       ),
//                       child: Text(
//                         report['department'],
//                         style: const TextStyle(
//                           color: Colors.blue,
//                           fontSize: 8, // 👈 Reduced from 9 to 8
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 4), // 👈 Reduced from 6 to 4
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // 👈 Reduced horizontal padding
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8), // 👈 Reduced from 10 to 8
//                     ),
//                     child: Text(
//                       report['status'] ?? 'Completed',
//                       style: const TextStyle(
//                         color: Colors.green,
//                         fontSize: 9, // 👈 Reduced from 10 to 9
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart'; // For clipboard functionality if needed

class ReportsScreen extends StatefulWidget {
  final String patientMrNo;
  final String patientName;

  const ReportsScreen({
    super.key,
    required this.patientMrNo,
    required this.patientName,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> laboratoryReports = [];
  List<Map<String, dynamic>> gastroReports = [];
  List<Map<String, dynamic>> radiologyReports = [];
  List<Map<String, dynamic>> prescriptionReports = [];

  bool isLoading = true;
  String? errorMessage;

  // Color scheme
  final Color primaryColor = const Color(0xFF1FC9C0);
  final Color accentColor = const Color(0xFF2E3B4E);
  final Color backgroundColor = Colors.white;
  final Color cardBackgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchAllReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchAllReports() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Future.wait([
        fetchLaboratoryReports(),
        fetchGastroReports(),
        fetchRadiologyReports(),
        fetchPrescriptionReports(),
      ]);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching reports: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchLaboratoryReports() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/labReports'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          laboratoryReports = data.map((item) => {
            'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
            'date': item['dT_SAMPLECOLLECTION'] ?? '',
            'pat_diag_id': item['paT_DIAG_ID'],
            'modality': item['modalitY_NM'] ?? '',
            'testtype': item['testtype'] ?? '',
            'icon': _getIconForTest(item['diagnostiC_NAME'] ?? ''),
            'type': 'Laboratory',
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching laboratory reports: $e');
    }
  }

  Future<void> fetchGastroReports() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/gastroReports'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          gastroReports = data.map((item) => {
            'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
            'date': item['dT_SAMPLECOLLECTION'] ?? '',
            'pat_diag_id': item['paT_DIAG_ID'],
            'modality': item['modalitY_NM'] ?? '',
            'testtype': item['testtype'] ?? '',
            'icon': Icons.medical_services,
            'type': 'Gastro',
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching gastro reports: $e');
    }
  }

  Future<void> fetchRadiologyReports() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/radiologyReports'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          radiologyReports = data.map((item) => {
            'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
            'date': item['dT_SAMPLECOLLECTION'] ?? '',
            'pat_diag_id': item['paT_DIAG_ID'],
            'modality': item['modalitY_NM'] ?? '',
            'testtype': item['testtype'] ?? '',
            'icon': Icons.radio,
            'type': 'Radiology',
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching radiology reports: $e');
    }
  }

  Future<void> fetchPrescriptionReports() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/prescriptionReports'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          prescriptionReports = data.map((item) => {
            'name': 'Prescription',
            'date': item['visiT_DATE'] ?? '',
            'pat_visit_id': item['paT_VISIT_ID'],
            'doctor': item['doctor'] ?? 'Unknown Doctor',
            'department': item['department'] ?? 'Unknown Department',
            'icon': Icons.description_outlined,
            'visit_date': item['visiT_DATE'] ?? '',
            'type': 'Prescription',
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching prescription reports: $e');
    }
  }

  IconData _getIconForTest(String testName) {
    String name = testName.toLowerCase();
    if (name.contains('glucose')) return Icons.bloodtype_outlined;
    if (name.contains('lipid')) return Icons.opacity_outlined;
    if (name.contains('liver')) return Icons.healing_outlined;
    if (name.contains('thyroid')) return Icons.monitor_heart_outlined;
    if (name.contains('urine')) return Icons.water_drop_outlined;
    if (name.contains('vitamin')) return Icons.wb_sunny_outlined;
    if (name.contains('x-ray')) return Icons.medical_services_outlined;
    if (name.contains('mri')) return Icons.monitor_heart_outlined;
    if (name.contains('ct')) return Icons.view_in_ar_outlined;
    return Icons.science_outlined;
  }

  String _formatDateFromAPI(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return dateString;
    }
  }
Future<void> _downloadReport(String url, String fileName, String reportName) async {
  // Show download progress dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                reportName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3B4E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Downloading report',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  try {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    // For Android 10 and above, we need to use the Downloads folder
    Directory? downloadsDir;
    
    if (Platform.isAndroid) {
      // Try to get the Downloads directory
      downloadsDir = Directory('/storage/emulated/0/Download');
      
      // Check if directory exists, if not try alternative paths
      if (!await downloadsDir.exists()) {
        downloadsDir = Directory('/sdcard/Download');
      }
      if (!await downloadsDir.exists()) {
        downloadsDir = Directory('/storage/self/primary/Download');
      }
      
      // If still not found, fallback to app documents
      if (!await downloadsDir.exists()) {
        downloadsDir = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    // If we couldn't get downloads directory, fallback to app documents
    if (downloadsDir == null || !await downloadsDir.exists()) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    // Create a clean filename
    String cleanFileName = fileName.replaceAll(' ', '_');
    String filePath = '${downloadsDir.path}/$cleanFileName';
    
    File file = File(filePath);
    
    // If file exists, add number to avoid overwriting
    if (await file.exists()) {
      int counter = 1;
      final nameWithoutExt = cleanFileName.substring(0, cleanFileName.lastIndexOf('.'));
      final ext = cleanFileName.substring(cleanFileName.lastIndexOf('.'));
      
      // Generate new filename with counter
      String newFileName;
      do {
        newFileName = '${nameWithoutExt}_$counter$ext';
        filePath = '${downloadsDir.path}/$newFileName';
        file = File(filePath);
        counter++;
      } while (await file.exists());
      
      cleanFileName = newFileName;
    }

    await file.writeAsBytes(response.data, flush: true);

    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close download dialog
    }

    // Show success message with option to open
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Download Complete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Saved to: $cleanFileName',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OPEN',
          textColor: Colors.white,
          onPressed: () {
            _openPDF(filePath, cleanFileName);
          },
        ),
      ),
    );
  } catch (e) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close download dialog
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text("Download failed: ${e.toString()}")),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
  void _openPDF(String filePath, String fileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              fileName,
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: primaryColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Share functionality can be added here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon')),
                  );
                },
              ),
            ],
          ),
          body: SfPdfViewer.file(
            File(filePath),
          ),
        ),
      ),
    );
  }

  // void _openReport(Map<String, dynamic> report) async {
  //   final patDiagId = report['pat_diag_id'];
  //   final patVisitId = report['pat_visit_id'];
    
  //   String reportName = '';
  //   String rptId = '';
  //   String parameters = '';
    
  //   if (patVisitId != null) {
  //     parameters = patVisitId.toString();
  //     reportName = 'Prescrpt';
  //     rptId = '19';
  //   } else if (patDiagId != null) {
  //     parameters = patDiagId.toString();
      
  //     final testType = report['testtype']?.toString().toUpperCase() ?? '';
  //     final modality = report['modality']?.toString().toUpperCase() ?? '';

  //     if (testType == 'LABORATORY' || modality.contains('LAB')) {
  //       reportName = 'Labrpt';
  //       rptId = '19';
  //     } else if (testType == 'GASTRO' || modality.contains('GASTRO')) {
  //       reportName = 'GastRpt';
  //       rptId = '64';
  //     } else if (testType == 'RADIOLOGY' || modality.contains('RADIOLOGY')) {
  //       reportName = 'RadRpt';
  //       rptId = '22';
  //     } else {
  //       reportName = 'Prescrpt';
  //       rptId = '19';
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Cannot open report: No valid ID found")),
  //     );
  //     return;
  //   }

  //   final pdfUrl =
  //       'http://172.16.40.10:8080/api/PatientReport/GenerateReport'
  //       '?rptId=$rptId'
  //       '&reportName=$reportName'
  //       '&parameters=$parameters'
  //       '&user=MobileApp';

  //   try {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (_) => Center(
  //         child: Container(
  //           padding: const EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const CircularProgressIndicator(color: Color(0xFF1FC9C0)),
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Generating Report...',
  //                 style: TextStyle(color: Colors.grey[600]),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  //     final dir = await getApplicationDocumentsDirectory();
  //     final fileName = '${reportName}_$parameters.pdf';
  //     final filePath = '${dir.path}/$fileName';

  //     final dio = Dio();
  //     dio.options.connectTimeout = const Duration(seconds: 30);
  //     dio.options.receiveTimeout = const Duration(seconds: 30);

  //     final response = await dio.get(
  //       pdfUrl,
  //       options: Options(responseType: ResponseType.bytes),
  //     );

  //     final contentType = response.headers.value("content-type");

  //     if (contentType == null || !contentType.contains("application/pdf")) {
  //       Navigator.pop(context);
  //       throw Exception("Server did not return a valid PDF");
  //     }

  //     final file = File(filePath);
  //     await file.writeAsBytes(response.data, flush: true);

  //     Navigator.pop(context);

  //     // Show options dialog
  //     showModalBottomSheet(
  //       context: context,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       builder: (context) => Container(
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             ListTile(
  //               leading: CircleAvatar(
  //                 backgroundColor: primaryColor.withOpacity(0.1),
  //                 child: Icon(Icons.visibility, color: primaryColor),
  //               ),
  //               title: const Text('View Report'),
  //               subtitle: const Text('Open and read the report'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _openPDF(filePath, fileName);
  //               },
  //             ),
  //             ListTile(
  //               leading: CircleAvatar(
  //                 backgroundColor: Colors.blue.withOpacity(0.1),
  //                 child: const Icon(Icons.download, color: Colors.blue),
  //               ),
  //               title: const Text('Download Report'),
  //               subtitle: const Text('Save to device'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _downloadReport(pdfUrl, fileName);
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     Navigator.pop(context);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error opening report: $e"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

void _openReport(Map<String, dynamic> report) async {
  final patDiagId = report['pat_diag_id'];
  final patVisitId = report['pat_visit_id'];
  
  String reportName = '';
  String rptId = '';
  String parameters = '';
  
  if (patVisitId != null) {
    parameters = patVisitId.toString();
    reportName = 'Prescrpt';
    rptId = '19';
  } else if (patDiagId != null) {
    parameters = patDiagId.toString();
    
    final testType = report['testtype']?.toString().toUpperCase() ?? '';
    final modality = report['modality']?.toString().toUpperCase() ?? '';

    if (testType == 'LABORATORY' || modality.contains('LAB')) {
      reportName = 'Labrpt';
      rptId = '19';
    } else if (testType == 'GASTRO' || modality.contains('GASTRO')) {
      reportName = 'GastRpt';
      rptId = '64';
    } else if (testType == 'RADIOLOGY' || modality.contains('RADIOLOGY')) {
      reportName = 'RadRpt';
      rptId = '22';
    } else {
      reportName = 'Prescrpt';
      rptId = '19';
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot open report: No valid ID found")),
    );
    return;
  }

  final pdfUrl =
      'http://172.16.40.10:8080/api/PatientReport/GenerateReport'
      '?rptId=$rptId'
      '&reportName=$reportName'
      '&parameters=$parameters'
      '&user=MobileApp';

  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated circular progress with container
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  color: Color(0xFF1FC9C0),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              // Report name
              Text(
                report['name'] ?? 'Report',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3B4E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Loading text with animated dots
              const Text(
                'Generating your report',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  try {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${reportName}_$parameters.pdf';
    final filePath = '${dir.path}/$fileName';

    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    final response = await dio.get(
      pdfUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final contentType = response.headers.value("content-type");

    if (contentType == null || !contentType.contains("application/pdf")) {
      Navigator.pop(context); // Close loading dialog
      throw Exception("Server did not return a valid PDF");
    }

    final file = File(filePath);
    await file.writeAsBytes(response.data, flush: true);

    Navigator.pop(context); // Close loading dialog

    // Show options dialog
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              // Report info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      report['name'] ?? 'Report',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3B4E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateFromAPI(report['date'] ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Divider
              Divider(
                color: Colors.grey[200],
                thickness: 1,
                height: 1,
              ),
              
              // Options
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.visibility,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                title: const Text(
                  'View Report',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  'Open and read the report',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openPDF(filePath, fileName);
                },
              ),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.download,
                    color: Colors.blue,
                    size: 22,
                  ),
                ),
                title: const Text(
                  'Save to Downloads',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  'Save report to your device',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _downloadReport(pdfUrl, fileName, report['name'] ?? 'Report');
                },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  } catch (e) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close loading dialog
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text("Error generating report: ${e.toString()}")),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medical Reports',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'MR: ${widget.patientMrNo}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.patientName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          isScrollable: true,
          tabs: const [
            Tab(text: 'Laboratory'),
            Tab(text: 'Gastro'),
            Tab(text: 'Radiology'),
            Tab(text: 'Prescription'),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading reports...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchAllReports,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
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
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReportsGrid(laboratoryReports),
                    _buildReportsGrid(gastroReports),
                    _buildReportsGrid(radiologyReports),
                    _buildReportsGrid(prescriptionReports),
                  ],
                ),
    );
  }

  Widget _buildReportsGrid(List<Map<String, dynamic>> reports) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No reports available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for updates',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          String formattedDate = _formatDateFromAPI(report['date'] ?? '');
          bool isPrescription = report['type'] == 'Prescription';
          
          return GestureDetector(
            onTap: () => _openReport(report),
            child: Container(
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Gradient overlay at top
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with icon and date
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  report['icon'] ?? Icons.description_outlined,
                                  color: primaryColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 10),
                          
                          // Report name/type
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              report['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: Color(0xFF2E3B4E),
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Doctor name (for prescriptions) or modality
                          if (isPrescription && report['doctor'] != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 12,
                                    color: Colors.blue[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      report['doctor'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                        letterSpacing: 0.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else if (report['modality'] != null && report['modality'].isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                report['modality'],
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange[800],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 8),
                          
                          // Department badge (for prescriptions)
                          if (isPrescription && report['department'] != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.business_outlined,
                                    size: 10,
                                    color: Colors.purple[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      report['department'],
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.purple[700],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Subtle border accent
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 4,
                        height: 30,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}