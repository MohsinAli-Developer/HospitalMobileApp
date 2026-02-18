// import 'package:flutter/material.dart';

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

// class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
  
//   // Sample data for each category
//   final List<Map<String, dynamic>> laboratoryReports = [
//     {'name': 'Complete Blood Count', 'date': '2024-01-15', 'status': 'Normal', 'value': '4.5M/µL', 'icon': Icons.science},
//     {'name': 'Lipid Profile', 'date': '2024-01-10', 'status': 'Abnormal', 'value': '240 mg/dL', 'icon': Icons.opacity},
//     {'name': 'Liver Function Test', 'date': '2024-01-05', 'status': 'Normal', 'value': '35 U/L', 'icon': Icons.healing},
//     {'name': 'Thyroid Profile', 'date': '2023-12-28', 'status': 'Normal', 'value': '2.5 µIU/mL', 'icon': Icons.monitor_heart},
//     {'name': 'Urinalysis', 'date': '2023-12-20', 'status': 'Normal', 'value': 'Clear', 'icon': Icons.water_drop},
//     {'name': 'Vitamin D Test', 'date': '2023-12-15', 'status': 'Low', 'value': '18 ng/mL', 'icon': Icons.wb_sunny},
//   ];

//   final List<Map<String, dynamic>> gastroReports = [
//     {'name': 'Upper Endoscopy', 'date': '2024-01-12', 'status': 'Completed', 'doctor': 'Dr. Smith', 'icon': Icons.healing},
//     {'name': 'Colonoscopy', 'date': '2023-12-20', 'status': 'Completed', 'doctor': 'Dr. Johnson', 'icon': Icons.medical_services},
//     {'name': 'H. Pylori Test', 'date': '2024-01-08', 'status': 'Positive', 'value': 'Detected', 'icon': Icons.bug_report},
//     {'name': 'Stool Analysis', 'date': '2024-01-03', 'status': 'Normal', 'value': 'No abnormalities', 'icon': Icons.biotech},
//     {'name': 'Abdominal Ultrasound', 'date': '2023-12-18', 'status': 'Completed', 'doctor': 'Dr. Williams', 'icon': Icons.medical_services},
//     {'name': 'Gastric Biopsy', 'date': '2023-12-10', 'status': 'Benign', 'value': 'Negative', 'icon': Icons.science},
//   ];

//   final List<Map<String, dynamic>> radiologyReports = [
//     {'name': 'Chest X-Ray', 'date': '2024-01-14', 'status': 'Normal', 'doctor': 'Dr. Brown', 'icon': Icons.medical_services},
//     {'name': 'MRI Brain', 'date': '2024-01-07', 'status': 'Abnormal', 'findings': 'Small lesion', 'icon': Icons.monitor_heart},
//     {'name': 'CT Abdomen', 'date': '2023-12-22', 'status': 'Normal', 'doctor': 'Dr. Davis', 'icon': Icons.view_in_ar},
//     {'name': 'Bone Density', 'date': '2023-12-15', 'status': 'Osteopenia', 'value': '-1.8 T-score', 'icon': Icons.health_and_safety},
//     {'name': 'Mammogram', 'date': '2023-12-05', 'status': 'Normal', 'doctor': 'Dr. Miller', 'icon': Icons.health_and_safety},
//     {'name': 'Ultrasound Abdomen', 'date': '2023-11-28', 'status': 'Normal', 'doctor': 'Dr. Wilson', 'icon': Icons.medical_services},
//   ];

//   final List<Map<String, dynamic>> prescriptionReports = [
//     {'name': 'Amoxicillin', 'date': '2024-01-10', 'status': 'Active', 'dosage': '500mg', 'icon': Icons.medication},
//     {'name': 'Lisinopril', 'date': '2024-01-05', 'status': 'Active', 'dosage': '10mg', 'icon': Icons.medication_liquid},
//     {'name': 'Metformin', 'date': '2023-12-20', 'status': 'Active', 'dosage': '850mg', 'icon': Icons.medication},
//     {'name': 'Atorvastatin', 'date': '2023-12-15', 'status': 'Active', 'dosage': '20mg', 'icon': Icons.medication},
//     {'name': 'Albuterol Inhaler', 'date': '2023-12-10', 'status': 'Active', 'dosage': '90mcg', 'icon': Icons.medical_services},
//     {'name': 'Omeprazole', 'date': '2023-12-01', 'status': 'Completed', 'dosage': '20mg', 'icon': Icons.medication},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

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
//           isScrollable: true, // Makes tabs scrollable on smaller screens
//           tabs: const [
//             Tab(text: 'Laboratory'),
//             Tab(text: 'Gastro'),
//             Tab(text: 'Radiology'),
//             Tab(text: 'Prescription'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildReportsGrid(laboratoryReports, 'Laboratory'),
//           _buildReportsGrid(gastroReports, 'Gastro'),
//           _buildReportsGrid(radiologyReports, 'Radiology'),
//           _buildReportsGrid(prescriptionReports, 'Prescription'),
//         ],
//       ),
//     );
//   }

//   Widget _buildReportsGrid(List<Map<String, dynamic>> reports, String category) {
//     return reports.isEmpty
//         ? Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.folder_open,
//                   size: 64,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No $category reports available',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         : Padding(
//             padding: const EdgeInsets.all(12), // Reduced padding
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12, // Reduced spacing
//                 mainAxisSpacing: 12, // Reduced spacing
//                 childAspectRatio: 1.3, // Increased ratio for better content fit
//               ),
//               itemCount: reports.length,
//               itemBuilder: (context, index) {
//                 final report = reports[index];
//                 return _buildReportCard(report, category);
//               },
//             ),
//           );
//   }

//   Widget _buildReportCard(Map<String, dynamic> report, String category) {
//     Color statusColor = Colors.green;
//     String status = report['status']?.toString().toLowerCase() ?? 'normal';
    
//     if (status.contains('abnormal')) {
//       statusColor = Colors.red;
//     } else if (status.contains('low') || status.contains('positive')) {
//       statusColor = Colors.orange;
//     } else if (status.contains('completed')) {
//       statusColor = Colors.blue;
//     } else if (status.contains('active')) {
//       statusColor = Colors.green;
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             _showReportDetails(context, report, category);
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(10), // Reduced padding
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min, // Minimize height usage
//               children: [
//                 // Header with icon and date
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(6), // Reduced padding
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         report['icon'] ?? Icons.description,
//                         color: const Color(0xFF1FC9C0),
//                         size: 18, // Smaller icon
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         _formatDate(report['date'] ?? ''),
//                         style: TextStyle(
//                           fontSize: 10, // Smaller font
//                           color: Colors.grey[600],
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
                
//                 // Title
//                 Text(
//                   report['name'] ?? '',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13, // Slightly smaller
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 6),
                
//                 // Status indicator
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     report['status'] ?? 'Normal',
//                     style: TextStyle(
//                       color: statusColor,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
                
//                 // Additional info based on category
//                 if (report.containsKey('value'))
//                   _buildInfoRow('Value', report['value']),
//                 if (report.containsKey('dosage'))
//                   _buildInfoRow('Dosage', report['dosage']),
//                 if (report.containsKey('doctor'))
//                   _buildInfoRow('Doctor', _formatDoctorName(report['doctor'])),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 3),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontSize: 9,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 9,
//                 fontWeight: FontWeight.w500,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(String date) {
//     if (date.isEmpty) return '';
//     try {
//       // Simple formatting - you can enhance this based on your date format
//       return date;
//     } catch (e) {
//       return date;
//     }
//   }

//   String _formatDoctorName(String doctor) {
//     if (doctor.length > 15) {
//       return '${doctor.substring(0, 12)}...';
//     }
//     return doctor;
//   }

//   void _showReportDetails(BuildContext context, Map<String, dynamic> report, String category) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle bar
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//             ),
            
//             // Content
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Header
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Icon(
//                           report['icon'] ?? Icons.description,
//                           color: const Color(0xFF1FC9C0),
//                           size: 30,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               report['name'] ?? '',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               category,
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
                  
//                   // Details
//                   _buildDetailItem('Date', report['date'] ?? 'N/A'),
//                   const SizedBox(height: 12),
//                   _buildDetailItem('Status', report['status'] ?? 'N/A'),
//                   if (report.containsKey('value')) ...[
//                     const SizedBox(height: 12),
//                     _buildDetailItem('Value', report['value']),
//                   ],
//                   if (report.containsKey('dosage')) ...[
//                     const SizedBox(height: 12),
//                     _buildDetailItem('Dosage', report['dosage']),
//                   ],
//                   if (report.containsKey('doctor')) ...[
//                     const SizedBox(height: 12),
//                     _buildDetailItem('Doctor', report['doctor']),
//                   ],
//                   if (report.containsKey('findings')) ...[
//                     const SizedBox(height: 12),
//                     _buildDetailItem('Findings', report['findings']),
//                   ],
                  
//                   const SizedBox(height: 24),
                  
//                   // Action buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.download, size: 18),
//                           label: const Text('Download'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF1FC9C0),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.share, size: 18),
//                           label: const Text('Share'),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: const Color(0xFF1FC9C0),
//                             side: const BorderSide(color: Color(0xFF1FC9C0)),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20), // Extra bottom padding
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailItem(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 80,
//           child: Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 14,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchReports() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/labReports'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        processReports(data);
      } else {
        setState(() {
          errorMessage =
              'Failed to load reports. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching reports: $e';
        isLoading = false;
      });
    }
  }

  void processReports(List<dynamic> data) {
    List<Map<String, dynamic>> labReports = [];
    List<Map<String, dynamic>> gastro = [];
    List<Map<String, dynamic>> radiology = [];
    List<Map<String, dynamic>> prescription = [];

    for (var item in data) {
      String testType = item['testtype']?.toString().toUpperCase() ?? '';
      String modality = item['modalitY_NM']?.toString().toUpperCase() ?? '';

      Map<String, dynamic> report = {
        'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
        'date': item['dT_SAMPLECOLLECTION'] ?? '',
        'pat_diag_id': item['paT_DIAG_ID'],
        'status': 'Completed',
        'icon': _getIconForTest(item['diagnostiC_NAME'] ?? ''),
      };

      if (testType == 'LABORATORY' ||
          modality.contains('BIOCHEMISTRY') ||
          modality.contains('PATHOLOGY') ||
          modality.contains('MICROBIOLOGY')) {
        labReports.add(report);
      } else if (modality.contains('RADIOLOGY') ||
          modality.contains('X-RAY') ||
          modality.contains('MRI') ||
          modality.contains('CT') ||
          modality.contains('ULTRASOUND')) {
        radiology.add(report);
      } else if (modality.contains('GASTRO') ||
          modality.contains('ENDOSCOPY') ||
          modality.contains('COLONOSCOPY')) {
        gastro.add(report);
      } else {
        labReports.add(report);
      }
    }

    setState(() {
      laboratoryReports = labReports;
      gastroReports = gastro;
      radiologyReports = radiology;
      prescriptionReports = prescription;
      isLoading = false;
    });
  }

  IconData _getIconForTest(String testName) {
    String name = testName.toLowerCase();
    if (name.contains('glucose')) return Icons.bloodtype;
    if (name.contains('lipid')) return Icons.opacity;
    if (name.contains('liver')) return Icons.healing;
    if (name.contains('thyroid')) return Icons.monitor_heart;
    if (name.contains('urine')) return Icons.water_drop;
    if (name.contains('vitamin')) return Icons.wb_sunny;
    if (name.contains('x-ray')) return Icons.medical_services;
    if (name.contains('mri')) return Icons.monitor_heart;
    if (name.contains('ct')) return Icons.view_in_ar;
    return Icons.science;
  }

  String _formatDateFromAPI(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  // 🔥 Download PDF and open in-app
  void _openReport(Map<String, dynamic> report) async {
    final reportId = report['pat_diag_id'];
    if (reportId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report ID not available')),
      );
      return;
    }

    final pdfUrl =
        'https://btkhospital.com/patientreports/Reports/PDF/$reportId.pdf';

    try {
      // Download PDF
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$reportId.pdf';
      final dio = Dio();

      await dio.download(pdfUrl, filePath);

      // Open PDF in PDFView
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(report['name'] ?? 'Report PDF'),
              backgroundColor: const Color(0xFF1FC9C0),
            ),
            body: PDFView(
              filePath: filePath,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1FC9C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medical Reports',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              'MR No: ${widget.patientMrNo}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
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
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1FC9C0)))
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
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
      return const Center(child: Text('No reports available'));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          String formattedDate = _formatDateFromAPI(report['date'] ?? '');
          return GestureDetector(
            onTap: () => _openReport(report),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1FC9C0).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            report['icon'] ?? Icons.description,
                            color: const Color(0xFF1FC9C0),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        report['status'] ?? 'Completed',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
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




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:convert';
// import 'package:webview_flutter/webview_flutter.dart';

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
//     fetchReports();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchReports() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse(
//             'http://172.16.40.10:8080/api/Patient/${widget.patientMrNo}/reports'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         processReports(data);
//       } else {
//         setState(() {
//           errorMessage =
//               'Failed to load reports. Status code: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error fetching reports: $e';
//         isLoading = false;
//       });
//     }
//   }

//   void processReports(List<dynamic> data) {
//     List<Map<String, dynamic>> labReports = [];
//     List<Map<String, dynamic>> gastro = [];
//     List<Map<String, dynamic>> radiology = [];
//     List<Map<String, dynamic>> prescription = [];

//     for (var item in data) {
//       String testType = item['testtype']?.toString().toUpperCase() ?? '';
//       String modality = item['modalitY_NM']?.toString().toUpperCase() ?? '';

//       Map<String, dynamic> report = {
//         'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
//         'date': item['dT_SAMPLECOLLECTION'] ?? '',
//         'pat_diag_id': item['paT_DIAG_ID'],
//         'status': 'Completed',
//         'icon': _getIconForTest(item['diagnostiC_NAME'] ?? ''),
//       };

//       if (testType == 'LABORATORY' ||
//           modality.contains('BIOCHEMISTRY') ||
//           modality.contains('PATHOLOGY') ||
//           modality.contains('MICROBIOLOGY')) {
//         labReports.add(report);
//       } else if (modality.contains('RADIOLOGY') ||
//           modality.contains('X-RAY') ||
//           modality.contains('MRI') ||
//           modality.contains('CT') ||
//           modality.contains('ULTRASOUND')) {
//         radiology.add(report);
//       } else if (modality.contains('GASTRO') ||
//           modality.contains('ENDOSCOPY') ||
//           modality.contains('COLONOSCOPY')) {
//         gastro.add(report);
//       } else {
//         labReports.add(report);
//       }
//     }

//     setState(() {
//       laboratoryReports = labReports;
//       gastroReports = gastro;
//       radiologyReports = radiology;
//       prescriptionReports = prescription;
//       isLoading = false;
//     });
//   }

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
//   final reportId = report['pat_diag_id'];
//   if (reportId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Report ID not available')),
//     );
//     return;
//   }

//   final pdfUrl = 'https://btkhospital.com/patientreports/Reports/PDF/$reportId.pdf';
//   final Uri uri = Uri.parse(pdfUrl);

//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication); // ✅ opens external PDF app
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Cannot open report. Please install a PDF viewer.')),
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

//   Widget _buildReportsGrid(List<Map<String, dynamic>> reports) {
//     if (reports.isEmpty) {
//       return const Center(child: Text('No reports available'));
//     }

//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 1.3,
//         ),
//         itemCount: reports.length,
//         itemBuilder: (context, index) {
//           final report = reports[index];
//           String formattedDate = _formatDateFromAPI(report['date'] ?? '');
//           return GestureDetector(
//             onTap: () => _openReport(report),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1FC9C0).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             report['icon'] ?? Icons.description,
//                             color: const Color(0xFF1FC9C0),
//                             size: 18,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             formattedDate,
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey[600],
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       report['name'] ?? '',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding:
//                           const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         report['status'] ?? 'Completed',
//                         style: const TextStyle(
//                           color: Colors.green,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
