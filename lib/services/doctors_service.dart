import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctors_model.dart';
import '../models/doctor_schedule_model.dart';

class DoctorService {
  Future<List<Doctor>> getDoctors() async {
    final response = await http.get(
      Uri.parse('http://172.16.40.10:8080/api/Doctor'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      print("Raw API Response: $jsonData"); // 👈 Debug

      return jsonData.map((e) => Doctor.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }
  Future<List<DoctorSchedule>> getDoctorSchedule(int doctorId) async {
  final response = await http.get(
    Uri.parse('http://172.16.40.10:8080/api/Doctor/$doctorId/schedule'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((e) => DoctorSchedule.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load schedule');
  }
}

}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/doctors_model.dart';
// //import '../models/doctor_schedule_model.dart';

// class DoctorService {
//   static const String baseUrl = 'http://172.16.40.10:8080';

//   Future<List<Doctor>> getDoctors() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/doctor'),
//       headers: {'accept': '*/*'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => Doctor.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load doctors');
//     }
//   }
  // Add this method to your existing DoctorService class
// Future<List<DoctorSchedule>> getDoctorSchedule(int doctorId) async {
//   final response = await http.get(
//     Uri.parse('http://172.16.40.10:8080/api/Doctor/$doctorId/schedule'),
//     headers: {'accept': '*/*'},
//   );

//   if (response.statusCode == 200) {
//     List<dynamic> data = json.decode(response.body);
//     return data.map((json) => DoctorSchedule.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load doctor schedule');
//   }
// }
//}
