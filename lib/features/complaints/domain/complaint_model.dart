class Complaint {
  final int? id;
  final String title;
  final String description;
  final String status; // 'Viewed', 'In Progress', 'Solved'
  final String postedBy;
  final String roomNo;
  final DateTime date;

  Complaint({
    this.id,
    required this.title,
    required this.description,
    this.status = 'Viewed',
    required this.postedBy,
    required this.roomNo,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'postedBy': postedBy,
      'roomNo': roomNo,
      'date': date.toIso8601String(),
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      postedBy: map['postedBy'],
      roomNo: map['roomNo'],
      date: DateTime.parse(map['date']),
    );
  }
}
