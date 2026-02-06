import 'dart:convert';
import 'package:btih_andriod_app/models/doctors_model.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  static const String baseUrl = "http://your-api-url/api";

  Future<List<Doctor>> getDoctors() async {
    final response =
        await http.get(Uri.parse('$baseUrl/doctors'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Doctor.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load doctors");
    }
  }
}
