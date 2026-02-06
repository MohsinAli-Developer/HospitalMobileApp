
class Patient {
  final String mrNo;
  final String name;
  final String gender;
  final String contactNumber;
  final String dob;
  final String cnic;
  final String address;

  Patient({
    required this.mrNo,
    required this.name,
    required this.gender,
    required this.contactNumber,
    required this.dob,
    required this.cnic,
    required this.address,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      mrNo: json['mrNo'],
      name: json['name'],
      gender: json['gender'],
      contactNumber: json['contactNumber'],
      dob: json['dob'],
      cnic: json['cnic'],
      address: json['address'],
    );
  }
}