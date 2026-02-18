class Doctor {
  final int serialNumber;
  final int id;
  final String doctorName;
  final String doctorDescription;
  final String specializationName;
  final String? doctorImagePath;   // 👈 Add this

  Doctor({
    required this.serialNumber,
    required this.id,
    required this.doctorName,
    required this.doctorDescription,
    required this.specializationName,
    this.doctorImagePath,

  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      serialNumber: json['serialNumber'],
      id: json['doctor_ID'],
      doctorName: json['doctorName'],
      doctorDescription: json['doctorDescription'],
      specializationName: json['specializationName'],
      doctorImagePath: json['doctorImagePath'],  // 👈 Add this

    );
  }
}
