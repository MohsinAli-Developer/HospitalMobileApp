// import 'package:flutter/material.dart';

class Appointment {
  final String? id; // from backend
  final String doctorId;
  final DateTime date;
  final String time;
  final String userId;

  Appointment({
    this.id,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'date': date.toIso8601String(),
        'time': time,
        'userId': userId,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctorId'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      userId: json['userId'],
    );
  }
}
