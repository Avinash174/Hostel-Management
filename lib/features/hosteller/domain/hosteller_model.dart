class Hosteller {
  final int? id;
  final String name;
  final String phone;
  final String roomNo;
  final double rent;
  final DateTime joiningDate;
  final bool isActive;

  Hosteller({
    this.id,
    required this.name,
    required this.phone,
    required this.roomNo,
    required this.rent,
    required this.joiningDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'roomNo': roomNo,
      'rent': rent,
      'joiningDate': joiningDate.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Hosteller.fromMap(Map<String, dynamic> map) {
    return Hosteller(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      roomNo: map['roomNo'],
      rent: map['rent'],
      joiningDate: DateTime.parse(map['joiningDate']),
      isActive: map['isActive'] == 1,
    );
  }
}
