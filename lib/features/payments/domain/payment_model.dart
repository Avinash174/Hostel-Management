class Payment {
  final int? id;
  final int hostellerId;
  final double amount;
  final DateTime date;
  final String mode;
  final int month;
  final int year;

  Payment({
    this.id,
    required this.hostellerId,
    required this.amount,
    required this.date,
    required this.mode,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hostellerId': hostellerId,
      'amount': amount,
      'date': date.toIso8601String(),
      'mode': mode,
      'month': month,
      'year': year,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      hostellerId: map['hostellerId'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      mode: map['mode'],
      month: map['month'],
      year: map['year'],
    );
  }
}
