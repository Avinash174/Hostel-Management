import 'package:hostel_managemet/features/complaints/domain/complaint_model.dart';
import '../database/database_helper.dart';

abstract class IComplaintRepository {
  Future<List<Complaint>> getAll();
  Future<int> add(Complaint complaint);
  Future<int> updateStatus(int id, String status);
}

class ComplaintRepository implements IComplaintRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<int> add(Complaint complaint) => _db.insertComplaint(complaint);

  @override
  Future<List<Complaint>> getAll() => _db.getAllComplaints();

  @override
  Future<int> updateStatus(int id, String status) => _db.updateComplaintStatus(id, status);
}
