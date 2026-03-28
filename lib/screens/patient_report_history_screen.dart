import 'dart:io';

import 'package:btih_andriod_app/utils/ip_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/patient_report_model.dart';
import '../services/patient_report_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientReportHistoryScreen extends StatefulWidget {
  final String patientMrNo;
  final String patientName;
  final bool isLoggedIn; // Add this parameter

  const PatientReportHistoryScreen({
    super.key,
    required this.patientMrNo,
    required this.patientName,
    this.isLoggedIn = false, // Default to false
  });

  @override
  State<PatientReportHistoryScreen> createState() => _PatientReportHistoryScreenState();
}
class _PatientReportHistoryScreenState extends State<PatientReportHistoryScreen> 
    with SingleTickerProviderStateMixin {
  
  final PatientReportService _reportService = PatientReportService();
  List<PatientReport> allReports = [];
  List<PatientReport> filteredReports = [];
  bool isLoading = true;
  bool isGeneratingReport = false;
  
  late TabController _tabController;
    final Color primaryColor = const Color(0xFF1FC9C0);

  // Department tabs in the specified order with their rptId values
  final List<Map<String, dynamic>> departments = [
    {'name': 'Emergency', 'code': 'EMERGENCY', 'rptId': 27},
    {'name': 'OPD', 'code': 'OPD', 'rptId': 26},
    {'name': 'Services', 'code': 'SERVICES', 'rptId': 26},
    {'name': 'Laboratory', 'code': 'LABORATORY', 'rptId': 26},
    {'name': 'Radiology', 'code': 'RADIOLOGY', 'rptId': 26},
    {'name': 'IPD', 'code': 'IPD', 'rptId': 27},
    {'name': 'Procedure', 'code': 'PROCEDURE', 'rptId': 26},
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: departments.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadReportHistory();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      filterReportsByDepartment();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void loadReportHistory() async {
    try {
      final reports = await _reportService.getPatientReportHistory(widget.patientMrNo);
      setState(() {
        allReports = reports;
        filterReportsByDepartment();
        isLoading = false;
      });
    } catch (e) {
      print("Report Load Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterReportsByDepartment() {
    if (allReports.isEmpty) {
      setState(() {
        filteredReports = [];
      });
      return;
    }

    final selectedDepartment = departments[_tabController.index]['code']!;
    setState(() {
      filteredReports = allReports
          .where((report) => report.department.toUpperCase() == selectedDepartment)
          .toList();
      
      // Sort by payment date (newest first)
      filteredReports.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    });
  }

Future<void> generateReport(PatientReport report) async {
  try {
    // Get the rptId based on department
    final departmentInfo = departments.firstWhere(
      (dept) => dept['code'] == report.department.toUpperCase(),
      orElse: () => departments[_tabController.index],
    );
    
    final rptId = departmentInfo['rptId'];
    
    // Build the API URL with parameters (keeping your original URL structure)
    final String pdfUrl = "${ApiConfig.baseUrl}/api/PatientReport/GenerateReports?rptId=$rptId&param=${report.billId}";

    print('Generating report with URL: $pdfUrl');

    // Show loading dialog (from sample code)
    if (!mounted) return;
    
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
                    color: const Color(0xFF1FC9C0).withOpacity(0.1),
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
                  '${report.department} Report',
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

    // Initialize Dio with timeout settings
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    // Download the PDF
    final response = await dio.get(
      pdfUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    // Check if response is actually a PDF
    final contentType = response.headers.value("content-type");
    if (contentType == null || !contentType.contains("application/pdf")) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close loading dialog
      }
      throw Exception("Server did not return a valid PDF");
    }

    // Get application documents directory
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${report.department}_Bill${report.billId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '${dir.path}/$fileName';

    // Save the PDF file
    final file = File(filePath);
    await file.writeAsBytes(response.data, flush: true);

    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close loading dialog
    }

    if (!mounted) return;
    // DIRECTLY OPEN THE PDF - NO OPTIONS DIALOG
    _openPDF(filePath, fileName);
  } catch (e) {
    print('Report generation error: $e');
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close loading dialog
    }
    
    if (mounted) {
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
  } finally {
    if (mounted) {
      setState(() {
        isGeneratingReport = false;
      });
    }
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

// Helper method to share PDF
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
  // Alternative method using HTTP client for more control
  Future<void> generateReportWithHttp(PatientReport report) async {
    setState(() {
      isGeneratingReport = true;
    });

    try {
      final departmentInfo = departments.firstWhere(
        (dept) => dept['code'] == report.department.toUpperCase(),
        orElse: () => departments[_tabController.index],
      );
      
      final rptId = departmentInfo['rptId'];

    final Uri uri = Uri.parse(
      "${ApiConfig.baseUrl}/api/PatientReport/GenerateReports?rptId=$rptId&param=${widget.patientMrNo}",
    );
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isGeneratingReport = false;
      });
    }
  }

  String formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateTimeString;
    }
  }

  String formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? "PM" : "AM";
      return "$hour:$minute $period";
    } catch (e) {
      return '';
    }
  }

  String formatCurrency(double amount) {
    return 'Rs. ${amount.toStringAsFixed(0)}';
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
              'Patient Reports',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              'MR No: ${widget.patientMrNo}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: departments.map((dept) => Tab(text: dept['name'])).toList(),
        ),
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FC9C0)),
                  ),
                )
              : Column(
                  children: [
                    // Summary Card
                    if (filteredReports.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1FC9C0), Color(0xFF1AAFA7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1FC9C0).withOpacity(0.3),
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
                                  '${departments[_tabController.index]['name']} Department',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${filteredReports.length} Reports',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Rpt ID: ${departments[_tabController.index]['rptId']}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  formatCurrency(
                                    filteredReports.fold(0, (sum, item) => sum + item.amount)
                                  ),
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
                    
                    // Report List
                    Expanded(
                      child: filteredReports.isEmpty
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
                                    'No reports found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No ${departments[_tabController.index]['name']} reports available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filteredReports.length,
                              itemBuilder: (context, index) {
                                final report = filteredReports[index];
                                return GestureDetector(
                                  onTap: () => generateReport(report),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.1),
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
                                                color: report.departmentColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                report.departmentIcon,
                                                color: report.departmentColor,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Bill #${report.billId}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Invoice: ${report.invoiceNo}',
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
                                                color: report.departmentColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    report.formattedDepartment,
                                                    style: TextStyle(
                                                      color: report.departmentColor,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Icon(
                                                    Icons.picture_as_pdf,
                                                    size: 14,
                                                    color: report.departmentColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Date and Amount Row
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
                                                        formatDate(report.paymentDate),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        formatTime(report.paymentDate),
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
                                            
                                            // Amount and Generate Button
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    formatCurrency(report.amount),
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF1FC9C0).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.download,
                                                      color: Color(0xFF1FC9C0),
                                                      size: 20,
                                                    ),
                                                    onPressed: () => generateReport(report),
                                                    tooltip: 'Generate Report',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        
                                        // Payment Method (if available)
                                        if (report.paymentMethod != null && report.paymentMethod!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.payment,
                                                  size: 14,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Payment: ${report.paymentMethod}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        
                                        // Cancel Info (if cancelled)
                                        if (report.isCancel == true)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.05),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      report.cancelReason ?? 'Cancelled',
                                                      style: const TextStyle(
                                                        color: Colors.red,
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
                ),
          
          // Loading overlay for report generation
          if (isGeneratingReport)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FC9C0)),
                        ),
                        SizedBox(height: 16),
                        Text('Generating Report...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}