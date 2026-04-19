import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/complaint_repository.dart';
import '../domain/complaint_model.dart';

final complaintRepositoryProvider = Provider<IComplaintRepository>((ref) {
  return ComplaintRepository();
});

class ComplaintListNotifier extends AsyncNotifier<List<Complaint>> {
  @override
  FutureOr<List<Complaint>> build() {
    return _fetchComplaints();
  }

  Future<List<Complaint>> _fetchComplaints() {
    return ref.read(complaintRepositoryProvider).getAll();
  }

  Future<void> addComplaint(Complaint complaint) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(complaintRepositoryProvider).add(complaint);
      return _fetchComplaints();
    });
  }

  Future<void> updateStatus(int id, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(complaintRepositoryProvider).updateStatus(id, status);
      return _fetchComplaints();
    });
  }
}

final complaintListProvider = AsyncNotifierProvider<ComplaintListNotifier, List<Complaint>>(() {
  return ComplaintListNotifier();
});

final filteredComplaintsProvider = Provider.family<List<Complaint>, String>((ref, status) {
  final complaintsAsync = ref.watch(complaintListProvider);
  return complaintsAsync.when(
    data: (complaints) {
      if (status == 'All') return complaints;
      return complaints.where((c) => c.status == status).toList();
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});
