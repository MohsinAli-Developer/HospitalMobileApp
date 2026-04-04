// import 'dart:io';
// import 'package:btih_andriod_app/utils/ip_file.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:share_plus/share_plus.dart';

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

//   // Color scheme
//   final Color primaryColor = const Color(0xFF1FC9C0);
//   final Color accentColor = const Color(0xFF2E3B4E);
//   final Color backgroundColor = Colors.white;
//   final Color cardBackgroundColor = Colors.white;

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
//             "${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/labReports"),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           laboratoryReports = data.map((item) => {
//             'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
//             'date': item['dT_SAMPLECOLLECTION'] ?? '',
//             'pat_diag_id': item['paT_DIAG_ID'],
//             'modality': item['modalitY_NM'] ?? '',
//             'testtype': item['testtype'] ?? '',
//             'icon': _getIconForTest(item['diagnostiC_NAME'] ?? ''),
//             'type': 'Laboratory',
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
//         Uri.parse("${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/gastroReports"),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           gastroReports = data.map((item) => {
//             'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
//             'date': item['dT_SAMPLECOLLECTION'] ?? '',
//             'pat_diag_id': item['paT_DIAG_ID'],
//             'modality': item['modalitY_NM'] ?? '',
//             'testtype': item['testtype'] ?? '',
//             'icon': Icons.medical_services,
//             'type': 'Gastro',
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
//             "${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/radiologyReports"),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           radiologyReports = data.map((item) => {
//             'name': item['diagnostiC_NAME'] ?? 'Unknown Test',
//             'date': item['dT_SAMPLECOLLECTION'] ?? '',
//             'pat_diag_id': item['paT_DIAG_ID'],
//             'modality': item['modalitY_NM'] ?? '',
//             'testtype': item['testtype'] ?? '',
//             'icon': Icons.radio,
//             'type': 'Radiology',
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching radiology reports: $e');
//     }
//   }

//   Future<void> fetchPrescriptionReports() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             "${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/prescriptionReports"),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           prescriptionReports = data.map((item) => {
//             'name': 'Prescription',
//             'date': item['visiT_DATE'] ?? '',
//             'pat_visit_id': item['paT_VISIT_ID'],
//             'doctor': item['doctor'] ?? 'Unknown Doctor',
//             'department': item['department'] ?? 'Unknown Department',
//             'icon': Icons.description_outlined,
//             'visit_date': item['visiT_DATE'] ?? '',
//             'type': 'Prescription',
//           }).toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching prescription reports: $e');
//     }
//   }

//   IconData _getIconForTest(String testName) {
//     String name = testName.toLowerCase();
//     if (name.contains('glucose')) return Icons.bloodtype_outlined;
//     if (name.contains('lipid')) return Icons.opacity_outlined;
//     if (name.contains('liver')) return Icons.healing_outlined;
//     if (name.contains('thyroid')) return Icons.monitor_heart_outlined;
//     if (name.contains('urine')) return Icons.water_drop_outlined;
//     if (name.contains('vitamin')) return Icons.wb_sunny_outlined;
//     if (name.contains('x-ray')) return Icons.medical_services_outlined;
//     if (name.contains('mri')) return Icons.monitor_heart_outlined;
//     if (name.contains('ct')) return Icons.view_in_ar_outlined;
//     return Icons.science_outlined;
//   }

//   String _formatDateFromAPI(String dateString) {
//     if (dateString.isEmpty) return '';
//     try {
//       DateTime dateTime = DateTime.parse(dateString);
//       final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//       return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
//     } catch (e) {
//       return dateString;
//     }
//   }
// Future<void> _downloadReport(String url, String fileName, String reportName) async {
//   // Show download progress dialog
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 spreadRadius: 2,
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const CircularProgressIndicator(
//                   color: Colors.blue,
//                   strokeWidth: 3,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 reportName,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2E3B4E),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Downloading report',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//               const Text(
//                 'Please wait...',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );

//   try {
//     final dio = Dio();
//     dio.options.connectTimeout = const Duration(seconds: 30);
//     dio.options.receiveTimeout = const Duration(seconds: 30);

//     final response = await dio.get(
//       url,
//       options: Options(responseType: ResponseType.bytes),
//     );

//     // For Android 10 and above, we need to use the Downloads folder
//     Directory? downloadsDir;
    
//     if (Platform.isAndroid) {
//       // Try to get the Downloads directory
//       downloadsDir = Directory('/storage/emulated/0/Download');
      
//       // Check if directory exists, if not try alternative paths
//       if (!await downloadsDir.exists()) {
//         downloadsDir = Directory('/sdcard/Download');
//       }
//       if (!await downloadsDir.exists()) {
//         downloadsDir = Directory('/storage/self/primary/Download');
//       }
      
//       // If still not found, fallback to app documents
//       if (!await downloadsDir.exists()) {
//         downloadsDir = await getExternalStorageDirectory();
//       }
//     } else if (Platform.isIOS) {
//       downloadsDir = await getApplicationDocumentsDirectory();
//     }

//     // If we couldn't get downloads directory, fallback to app documents
//     if (downloadsDir == null || !await downloadsDir.exists()) {
//       downloadsDir = await getApplicationDocumentsDirectory();
//     }

//     // Create a clean filename
//     String cleanFileName = fileName.replaceAll(' ', '_');
//     String filePath = '${downloadsDir.path}/$cleanFileName';
    
//     File file = File(filePath);
    
//     // If file exists, add number to avoid overwriting
//     if (await file.exists()) {
//       int counter = 1;
//       final nameWithoutExt = cleanFileName.substring(0, cleanFileName.lastIndexOf('.'));
//       final ext = cleanFileName.substring(cleanFileName.lastIndexOf('.'));
      
//       // Generate new filename with counter
//       String newFileName;
//       do {
//         newFileName = '${nameWithoutExt}_$counter$ext';
//         filePath = '${downloadsDir.path}/$newFileName';
//         file = File(filePath);
//         counter++;
//       } while (await file.exists());
      
//       cleanFileName = newFileName;
//     }

//     await file.writeAsBytes(response.data, flush: true);

//     if (Navigator.canPop(context)) {
//       Navigator.pop(context); // Close download dialog
//     }

//     // Show success message with option to open
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 8),
//                 Text(
//                   'Download Complete',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Saved to: $cleanFileName',
//               style: const TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 4),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         action: SnackBarAction(
//           label: 'OPEN',
//           textColor: Colors.white,
//           onPressed: () {
//             _openPDF(filePath, cleanFileName);
//           },
//         ),
//       ),
//     );
//   } catch (e) {
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context); // Close download dialog
//     }
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text("Download failed: ${e.toString()}")),
//           ],
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }
//   void _openPDF(String filePath, String fileName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text(
//               fileName,
//               style: const TextStyle(fontSize: 16),
//             ),
//             backgroundColor: primaryColor,
//             elevation: 0,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.share),
//                 onPressed: () {
//                   // Share functionality can be added here
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   const SnackBar(content: Text('Share feature coming soon')),
//                   // );
//                   _sharePDF(filePath, fileName);
//                 },
//               ),
//             ],
//           ),
//           body: SfPdfViewer.file(
//   File(filePath),
//   pageLayoutMode: PdfPageLayoutMode.single, // Important
//   canShowScrollHead: true,
//   canShowScrollStatus: true,
//   enableDoubleTapZooming: true,
// ),
//         ),
//       ),
//     );
//   }

// Future<void> _sharePDF(String filePath, String reportName) async {
//   try {
//     final file = File(filePath);
//     if (await file.exists()) {
//       final xFile = XFile(filePath);
//       await Share.shareXFiles(
//         [xFile],
//         text: 'Here is your $reportName',
//       );
//     }
//   } catch (e) {
//     print('Share error: $e');
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error sharing file: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

// void _openReport(Map<String, dynamic> report) async {
//   final patDiagId = report['pat_diag_id'];
//   final patVisitId = report['pat_visit_id'];
  
//   String reportName = '';
//   String rptId = '';
//   String parameters = '';
  
//   if (patVisitId != null) {
//     parameters = patVisitId.toString();
//     reportName = 'PRESCRIPTION_A4';
//     rptId = '141';
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
//       reportName = 'PRESCRIPTION_A4';
//       rptId = '141';
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Cannot open report: No valid ID found")),
//     );
//     return;
//   }

//   final String pdfUrl =
//       "${ApiConfig.baseUrl}/api/PatientReport/GenerateReport"
//       "?rptId=$rptId"
//       "&reportName=$reportName"
//       "&parameters=$parameters"
//       "&user=MobileApp";
  
//   // Show loading dialog
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 spreadRadius: 2,
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Animated circular progress with container
//               Container(
//                 width: 60,
//                 height: 60,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: primaryColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const CircularProgressIndicator(
//                   color: Color(0xFF1FC9C0),
//                   strokeWidth: 3,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Report name
//               Text(
//                 report['name'] ?? 'Report',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2E3B4E),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               // Loading text with animated dots
//               const Text(
//                 'Generating your report',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 'Please wait...',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );

//   try {
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
//       Navigator.pop(context); // Close loading dialog
//       throw Exception("Server did not return a valid PDF");
//     }

//     final file = File(filePath);
//     await file.writeAsBytes(response.data, flush: true);

//     Navigator.pop(context); // Close loading dialog

//     // Directly open the PDF without showing options
//     _openPDF(filePath, fileName);
    
//   } catch (e) {
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context); // Close loading dialog
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text("Error generating report: ${e.toString()}")),
//           ],
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             child: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Medical Reports',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 18,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     'MR: ${widget.patientMrNo}',
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     widget.patientName,
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           indicatorWeight: 3,
//           indicatorSize: TabBarIndicatorSize.tab,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white,
//           labelStyle: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 14,
//           ),
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
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     color: primaryColor,
//                     strokeWidth: 3,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Loading reports...',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : errorMessage != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 48,
//                         color: Colors.red[300],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         errorMessage!,
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: fetchAllReports,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
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
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.folder_open_outlined,
//                 size: 48,
//                 color: Colors.grey[400],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No reports available',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Check back later for updates',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 1.1,
//         ),
//         itemCount: reports.length,
//         itemBuilder: (context, index) {
//           final report = reports[index];
//           String formattedDate = _formatDateFromAPI(report['date'] ?? '');
//           bool isPrescription = report['type'] == 'Prescription';
          
//           return GestureDetector(
//             onTap: () => _openReport(report),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: cardBackgroundColor,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.08),
//                     spreadRadius: 2,
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Stack(
//                   children: [
//                     // Gradient overlay at top
//                     Positioned(
//                       top: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         height: 60,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               primaryColor.withOpacity(0.05),
//                               Colors.transparent,
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Header with icon and date
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: primaryColor.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: Icon(
//                                   report['icon'] ?? Icons.description_outlined,
//                                   color: primaryColor,
//                                   size: 18,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[50],
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                       color: Colors.grey[200]!,
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Text(
//                                     formattedDate,
//                                     style: TextStyle(
//                                       fontSize: 9,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
                          
//                           const SizedBox(height: 10),
                          
//                           // Report name/type
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: primaryColor.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               report['name'] ?? '',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 11,
//                                 color: Color(0xFF2E3B4E),
//                                 letterSpacing: 0.3,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
                          
//                           const SizedBox(height: 8),
                          
//                           // Doctor name (for prescriptions) or modality
//                           if (isPrescription && report['doctor'] != null) ...[
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.withOpacity(0.05),
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: Colors.blue.withOpacity(0.1),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.person_outline,
//                                     size: 12,
//                                     color: Colors.blue[700],
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       report['doctor'],
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.blue[800],
//                                         letterSpacing: 0.2,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ] else if (report['modality'] != null && report['modality'].isNotEmpty) ...[
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.orange.withOpacity(0.05),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 report['modality'],
//                                 style: TextStyle(
//                                   fontSize: 9,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.orange[800],
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
                          
//                           const SizedBox(height: 8),
                          
//                           // Department badge (for prescriptions)
//                           if (isPrescription && report['department'] != null) ...[
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.purple.withOpacity(0.05),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.business_outlined,
//                                     size: 10,
//                                     color: Colors.purple[600],
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Flexible(
//                                     child: Text(
//                                       report['department'],
//                                       style: TextStyle(
//                                         fontSize: 9,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.purple[700],
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
                    
//                     // Subtle border accent
//                     Positioned(
//                       top: 0,
//                       left: 0,
//                       child: Container(
//                         width: 4,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           color: primaryColor,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             bottomRight: Radius.circular(4),
//                           ),
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

import 'dart:io';
import 'package:btih_andriod_app/utils/ip_file.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

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

  // Filtered reports for each tab
  List<Map<String, dynamic>> filteredLaboratoryReports = [];
  List<Map<String, dynamic>> filteredGastroReports = [];
  List<Map<String, dynamic>> filteredRadiologyReports = [];
  List<Map<String, dynamic>> filteredPrescriptionReports = [];

  // Search controllers for each tab
  final TextEditingController labSearchController = TextEditingController();
  final TextEditingController gastroSearchController = TextEditingController();
  final TextEditingController radiologySearchController = TextEditingController();
  final TextEditingController prescriptionSearchController = TextEditingController();

  // Selected date for filtering (single date)
  DateTime? selectedLabDate;
  DateTime? selectedGastroDate;
  DateTime? selectedRadiologyDate;
  DateTime? selectedPrescriptionDate;

  bool isLoading = true;
  String? errorMessage;
  int _currentTabIndex = 0;

  // Color scheme
  final Color primaryColor = const Color(0xFF1FC9C0);
  final Color accentColor = const Color(0xFF2E3B4E);
  final Color backgroundColor = Colors.white;
  final Color cardBackgroundColor = Colors.white;

  // Define tabs with their icons and colors
  final List<Map<String, dynamic>> tabs = [
    {'name': 'Laboratory', 'icon': Icons.science_outlined, 'color': Color(0xFF1FC9C0)},
    {'name': 'Gastro', 'icon': Icons.medical_services_outlined, 'color': Color(0xFFFF6B6B)},
    {'name': 'Radiology', 'icon': Icons.radio, 'color': Color(0xFF4ECDC4)},
    {'name': 'Prescription', 'icon': Icons.description_outlined, 'color': Color(0xFFFFB347)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    fetchAllReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    labSearchController.dispose();
    gastroSearchController.dispose();
    radiologySearchController.dispose();
    prescriptionSearchController.dispose();
    super.dispose();
  }

  // Filter reports by name and single date
  void _filterReports() {
    setState(() {
      filteredLaboratoryReports = _applyFilters(
        laboratoryReports,
        labSearchController.text,
        selectedLabDate,
      );
      filteredGastroReports = _applyFilters(
        gastroReports,
        gastroSearchController.text,
        selectedGastroDate,
      );
      filteredRadiologyReports = _applyFilters(
        radiologyReports,
        radiologySearchController.text,
        selectedRadiologyDate,
      );
      filteredPrescriptionReports = _applyFilters(
        prescriptionReports,
        prescriptionSearchController.text,
        selectedPrescriptionDate,
      );
    });
  }

  List<Map<String, dynamic>> _applyFilters(
    List<Map<String, dynamic>> reports,
    String searchQuery,
    DateTime? selectedDate,
  ) {
    return reports.where((report) {
      // Filter by name
      if (searchQuery.isNotEmpty) {
        final reportName = (report['name'] ?? '').toLowerCase();
        if (!reportName.contains(searchQuery.toLowerCase())) {
          return false;
        }
      }

      // Filter by single date
      if (selectedDate != null) {
        final dateStr = report['date'] ?? '';
        if (dateStr.isNotEmpty) {
          try {
            final reportDate = DateTime.parse(dateStr);
            if (reportDate.year != selectedDate.year ||
                reportDate.month != selectedDate.month ||
                reportDate.day != selectedDate.day) {
              return false;
            }
          } catch (e) {
            // If date parsing fails, include the report
          }
        } else {
          return false;
        }
      }

      return true;
    }).toList();
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

      // Initialize filtered lists
      filteredLaboratoryReports = List.from(laboratoryReports);
      filteredGastroReports = List.from(gastroReports);
      filteredRadiologyReports = List.from(radiologyReports);
      filteredPrescriptionReports = List.from(prescriptionReports);

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
            "${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/labReports"),
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
            'department': 'Laboratory',
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
        Uri.parse("${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/gastroReports"),
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
            'department': 'Gastro',
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
            "${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/radiologyReports"),
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
            'department': 'Radiology',
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
            "${ApiConfig.baseUrl}/api/Patient/${widget.patientMrNo}/prescriptionReports"),
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

  String _formatDateForDisplay(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String formatTime(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? "PM" : "AM";
      return "$hour:$minute $period";
    } catch (e) {
      return '';
    }
  }

  Future<void> _selectDate(int tabIndex) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: accentColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        switch (tabIndex) {
          case 0:
            selectedLabDate = selectedDate;
            break;
          case 1:
            selectedGastroDate = selectedDate;
            break;
          case 2:
            selectedRadiologyDate = selectedDate;
            break;
          case 3:
            selectedPrescriptionDate = selectedDate;
            break;
        }
        _filterReports();
      });
    }
  }

  void _clearFilters(int tabIndex) {
    setState(() {
      switch (tabIndex) {
        case 0:
          labSearchController.clear();
          selectedLabDate = null;
          break;
        case 1:
          gastroSearchController.clear();
          selectedGastroDate = null;
          break;
        case 2:
          radiologySearchController.clear();
          selectedRadiologyDate = null;
          break;
        case 3:
          prescriptionSearchController.clear();
          selectedPrescriptionDate = null;
          break;
      }
      _filterReports();
    });
  }

  DateTime? _getSelectedDateForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: return selectedLabDate;
      case 1: return selectedGastroDate;
      case 2: return selectedRadiologyDate;
      case 3: return selectedPrescriptionDate;
      default: return null;
    }
  }

  String formatCurrency(double amount) {
    return 'Rs. ${amount.toStringAsFixed(0)}';
  }

  Future<void> _downloadReport(String url, String fileName, String reportName) async {
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
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(
                    color: Color(0xFF1FC9C0),
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

      Directory? downloadsDir;

      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');

        if (!await downloadsDir.exists()) {
          downloadsDir = Directory('/sdcard/Download');
        }
        if (!await downloadsDir.exists()) {
          downloadsDir = Directory('/storage/self/primary/Download');
        }

        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null || !await downloadsDir.exists()) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      String cleanFileName = fileName.replaceAll(' ', '_');
      String filePath = '${downloadsDir.path}/$cleanFileName';

      File file = File(filePath);

      if (await file.exists()) {
        int counter = 1;
        final nameWithoutExt = cleanFileName.substring(0, cleanFileName.lastIndexOf('.'));
        final ext = cleanFileName.substring(cleanFileName.lastIndexOf('.'));

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
        Navigator.pop(context);
      }

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
        Navigator.pop(context);
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

// void _openPDF(String filePath, String fileName) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => Scaffold(
//         appBar: AppBar(
//           title: Text(
//             fileName,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: primaryColor,
//           elevation: 1,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           actions: [
//             // Download Icon Button
//             IconButton(
//               icon: const Icon(Icons.download, color: Colors.white),
//               onPressed: () {
//                 _downloadExistingPDF(filePath, fileName);
//               },
//               tooltip: 'Download PDF',
//             ),
//             // Share Icon Button
//             IconButton(
//               icon: const Icon(Icons.share, color: Colors.white),
//               onPressed: () {
//                 _sharePDF(filePath, fileName);
//               },
//               tooltip: 'Share PDF',
//             ),
//           ],
//         ),
//         body: SfPdfViewer.file(
//           File(filePath),
//           pageLayoutMode: PdfPageLayoutMode.single,
//           canShowScrollHead: true,
//           canShowScrollStatus: true,
//           enableDoubleTapZooming: true,
//         ),
//       ),
//     ),
//   );
// }

void _openPDF(String filePath, String fileName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(
            fileName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          backgroundColor: primaryColor,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                _sharePDF(filePath, fileName);
              },
              tooltip: 'Share PDF',
            ),
          ],
        ),
        body: SfPdfViewer.file(
          File(filePath),
          pageLayoutMode: PdfPageLayoutMode.single,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableDoubleTapZooming: true,
        ),
      ),
    ),
  );
}

  Future<void> _sharePDF(String filePath, String reportName) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final xFile = XFile(filePath);
        await Share.shareXFiles(
          [xFile],
          text: 'Here is your $reportName',
        );
      }
    } catch (e) {
      print('Share error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openReport(Map<String, dynamic> report) async {
    final patDiagId = report['pat_diag_id'];
    final patVisitId = report['pat_visit_id'];

    String reportName = '';
    String rptId = '';
    String parameters = '';

    if (patVisitId != null) {
      parameters = patVisitId.toString();
      reportName = 'PRESCRIPTION_A4';
      rptId = '141';
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
        reportName = 'PRESCRIPTION_A4';
        rptId = '141';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open report: No valid ID found")),
      );
      return;
    }

    final String pdfUrl =
        "${ApiConfig.baseUrl}/api/PatientReport/GenerateReport"
        "?rptId=$rptId"
        "&reportName=$reportName"
        "&parameters=$parameters"
        "&user=MobileApp";

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
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(
                    color: Color(0xFF1FC9C0),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 20),
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
        Navigator.pop(context);
        throw Exception("Server did not return a valid PDF");
      }

      final file = File(filePath);
      await file.writeAsBytes(response.data, flush: true);

      Navigator.pop(context);

      _openPDF(filePath, fileName);
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: primaryColor,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              tabs: tabs.map((tab) => Tab(text: tab['name'])).toList(),
            ),
          ),
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
                    _buildTabContent(
                      filteredLaboratoryReports,
                      labSearchController,
                      selectedLabDate,
                      0,
                      tabs[0]['icon'],
                      tabs[0]['name'],
                      tabs[0]['color'],
                    ),
                    _buildTabContent(
                      filteredGastroReports,
                      gastroSearchController,
                      selectedGastroDate,
                      1,
                      tabs[1]['icon'],
                      tabs[1]['name'],
                      tabs[1]['color'],
                    ),
                    _buildTabContent(
                      filteredRadiologyReports,
                      radiologySearchController,
                      selectedRadiologyDate,
                      2,
                      tabs[2]['icon'],
                      tabs[2]['name'],
                      tabs[2]['color'],
                    ),
                    _buildTabContent(
                      filteredPrescriptionReports,
                      prescriptionSearchController,
                      selectedPrescriptionDate,
                      3,
                      tabs[3]['icon'],
                      tabs[3]['name'],
                      tabs[3]['color'],
                    ),
                  ],
                ),
    );
  }

  Widget _buildTabContent(
    List<Map<String, dynamic>> reports,
    TextEditingController searchController,
    DateTime? selectedDate,
    int tabIndex,
    IconData defaultIcon,
    String categoryName,
    Color tabColor,
  ) {
    final totalAmount = 0.0; // Since reports don't have amount field, using 0

    return Column(
      children: [
        // Filter Bar - Similar to sample design
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => _filterReports(),
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                      prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, size: 18, color: Colors.grey[500]),
                              onPressed: () {
                                searchController.clear();
                                _filterReports();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Single Date Filter Button
              Container(
                decoration: BoxDecoration(
                  color: selectedDate != null ? tabColor : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedDate != null ? tabColor : Colors.grey[200]!,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: selectedDate != null ? Colors.white : Colors.grey[600],
                  ),
                  onPressed: () => _selectDate(tabIndex),
                  tooltip: 'Filter by date',
                ),
              ),
              // Clear Filters Button
              if (searchController.text.isNotEmpty || selectedDate != null)
                const SizedBox(width: 8),
              if (searchController.text.isNotEmpty || selectedDate != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.clear_all, size: 20, color: Colors.red[400]),
                    onPressed: () => _clearFilters(tabIndex),
                    tooltip: 'Clear all filters',
                  ),
                ),
            ],
          ),
        ),
        
        // Summary Card - Similar to sample design
        if (reports.isNotEmpty)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tabColor, tabColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: tabColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$categoryName Department',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${reports.length} Reports',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Records',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reports.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        
        // Selected Date Display
        if (selectedDate != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: tabColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 14, color: tabColor),
                const SizedBox(width: 6),
                Text(
                  'Showing reports for: ${_formatDateForDisplay(selectedDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: tabColor,
                  ),
                ),
              ],
            ),
          ),
        
        // Reports List View - Similar to sample design
        Expanded(
          child: reports.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        searchController.text.isNotEmpty || selectedDate != null
                            ? 'No matching reports found'
                            : 'No reports found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        searchController.text.isNotEmpty || selectedDate != null
                            ? 'Try clearing filters'
                            : 'No $categoryName reports available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      if (searchController.text.isNotEmpty || selectedDate != null)
                        const SizedBox(height: 16),
                      if (searchController.text.isNotEmpty || selectedDate != null)
                        TextButton(
                          onPressed: () => _clearFilters(tabIndex),
                          child: Text(
                            'Clear filters',
                            style: TextStyle(color: tabColor),
                          ),
                        ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    String formattedDate = _formatDateFromAPI(report['date'] ?? '');
                    String formattedTime = report['date'] != null && report['date'].isNotEmpty
                        ? formatTime(report['date'])
                        : '';
                    bool isPrescription = report['type'] == 'Prescription';
                    
                    return GestureDetector(
                      onTap: () => _openReport(report),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          //color: Colors.teal,
                          color: const Color.fromARGB(1, 119, 234, 245).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Header Row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: tabColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    report['icon'] ?? defaultIcon,
                                    color: tabColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report['name'] ?? 'Unknown Test',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isPrescription && report['doctor'] != null)
                                        Text(
                                          'Dr. ${report['doctor']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tabColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        report['type'] ?? categoryName,
                                        style: TextStyle(
                                          color: tabColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.picture_as_pdf,
                                        size: 14,
                                        color: tabColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Date and Action Row
                            Row(
                              children: [
                                // Date
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 4),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (formattedTime.isNotEmpty)
                                            Text(
                                              formattedTime,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // View Button
                                Container(
                                  decoration: BoxDecoration(
                                    color: tabColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: tabColor,
                                      size: 20,
                                    ),
                                    onPressed: () => _openReport(report),
                                    tooltip: 'View Report',
                                  ),
                                ),
                              ],
                            ),
                            
                            // Modality or Department Info
                            // if (!isPrescription && report['modality'] != null && report['modality'].isNotEmpty)
                            //   Padding(
                            //     padding: const EdgeInsets.only(top: 12),
                            //     child: Row(
                            //       children: [
                            //         Icon(
                            //           Icons.category_outlined,
                            //           size: 14,
                            //           color: Colors.grey[400],
                            //         ),
                            //         const SizedBox(width: 4),
                            //         Text(
                            //           'Modality: ${report['modality']}',
                            //           style: TextStyle(
                            //             fontSize: 12,
                            //             color: Colors.grey[600],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            
                            // Department for Prescriptions
                            if (isPrescription && report['department'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.business_outlined,
                                        color: Colors.purple[400],
                                        size: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Department: ${report['department']}',
                                          style: TextStyle(
                                            color: Colors.purple[700],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}