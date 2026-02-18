// import 'package:btih_andriod_app/models/patient_model.dart';
// import 'package:btih_andriod_app/services/patients_service.dart';
// import 'package:flutter/material.dart';

// class ProfileScreen extends StatefulWidget {
//   final String mrNo;

//   const ProfileScreen({super.key, required this.mrNo});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late Future<Patient> patient;

//   @override
//   void initState() {
//     super.initState();
//     patient = PatientService().getPatient(widget.mrNo);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Patient Profile'),
//       ),
//       body: FutureBuilder<Patient>(
//         future: patient,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildInfoRow('MR NO:', snapshot.data!.mrNo),
//                   _buildInfoRow('Patient Name:', snapshot.data!.name),
//                   _buildInfoRow('Gender:', snapshot.data!.gender),
//                   _buildInfoRow('Contact #:', snapshot.data!.contactNumber),
//                   _buildInfoRow('DOB:', snapshot.data!.dob),
//                   _buildInfoRow('CNIC #:', snapshot.data!.cnic),
//                   _buildInfoRow('Address:', snapshot.data!.address),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(width: 16),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }