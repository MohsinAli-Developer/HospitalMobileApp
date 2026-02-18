class DoctorSchedule {
  final int serialNumber;
  final int doctorId;
  final String doctorName;
  final String dayName;
  final DateTime timeFrom;
  final DateTime timeTo;

  DoctorSchedule({
    required this.serialNumber,
    required this.doctorId,
    required this.doctorName,
    required this.dayName,
    required this.timeFrom,
    required this.timeTo,
  });

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      serialNumber: json['serialNumber'],
      doctorId: json['doctor_ID'],
      doctorName: json['doctorName'],
      dayName: json['dayName'],
      timeFrom: DateTime.parse(json['timeFrom']),
      timeTo: DateTime.parse(json['timeTo']),
    );
  }
}
