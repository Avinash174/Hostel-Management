import 'package:hostel_managemet/features/payments/domain/payment_model.dart';
import '../database/database_helper.dart';

abstract class IPaymentRepository {
  Future<List<Payment>> getAll();
  Future<List<Payment>> getByHosteller(int hostellerId);
  Future<int> add(Payment payment);
}

class PaymentRepository implements IPaymentRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<int> add(Payment payment) => _db.insertPayment(payment);

  @override
  Future<List<Payment>> getAll() => _db.getAllPayments();

  @override
  Future<List<Payment>> getByHosteller(int hostellerId) => _db.getPaymentsByHosteller(hostellerId);
}
