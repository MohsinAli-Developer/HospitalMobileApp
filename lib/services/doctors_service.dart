import 'dart:convert';
import 'package:btih_andriod_app/utils/ip_file.dart';
import 'package:http/http.dart' as http;
import '../models/doctors_model.dart';
import '../models/doctor_schedule_model.dart';

class DoctorService {
  Future<List<Doctor>> getDoctors() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/Doctor"),
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
    Uri.parse("${ApiConfig.baseUrl}/api/Doctor/$doctorId/schedule"),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((e) => DoctorSchedule.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load schedule');
  }
}

}

