import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_managemet/core/repositories/payment_repository.dart';
import 'package:hostel_managemet/features/payments/domain/payment_model.dart';
import 'package:hostel_managemet/features/hosteller/presentation/hosteller_provider.dart';

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  return PaymentRepository();
});

class PaymentListNotifier extends AsyncNotifier<List<Payment>> {
  @override
  FutureOr<List<Payment>> build() {
    return _fetchPayments();
  }

  Future<List<Payment>> _fetchPayments() {
    return ref.read(paymentRepositoryProvider).getAll();
  }

  Future<void> addPayment(Payment payment) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(paymentRepositoryProvider).add(payment);
      return _fetchPayments();
    });
  }

  Future<List<Payment>> getHostellerPayments(int hostellerId) {
    return ref.read(paymentRepositoryProvider).getByHosteller(hostellerId);
  }
}

final paymentListProvider = AsyncNotifierProvider<PaymentListNotifier, List<Payment>>(() {
  return PaymentListNotifier();
});

final pendingDuesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final hostellersAsync = ref.watch(hostellerListProvider);
  final paymentsAsync = ref.watch(paymentListProvider);
  
  if (hostellersAsync is! AsyncData || paymentsAsync is! AsyncData) return [];

  final hostellers = hostellersAsync.value!;
  final payments = paymentsAsync.value!;
  
  final now = DateTime.now();
  final currentMonth = now.month;
  final currentYear = now.year;
  
  List<Map<String, dynamic>> pending = [];
  
  for (var hosteller in hostellers) {
    bool paid = payments.any((p) => 
      p.hostellerId == hosteller.id && 
      p.month == currentMonth && 
      p.year == currentYear
    );
    
    if (!paid) {
      pending.add({
        'hosteller': hosteller,
        'amount': hosteller.rent,
      });
    }
  }
  
  return pending;
});
