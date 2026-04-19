import 'package:hostel_managemet/features/hosteller/domain/hosteller_model.dart';
import '../database/database_helper.dart';

abstract class IHostellerRepository {
  Future<List<Hosteller>> getAll();
  Future<int> add(Hosteller hosteller);
  Future<int> update(Hosteller hosteller);
  Future<int> delete(int id);
}

class HostellerRepository implements IHostellerRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<int> add(Hosteller hosteller) => _db.insertHosteller(hosteller);

  @override
  Future<int> delete(int id) => _db.deleteHosteller(id);

  @override
  Future<List<Hosteller>> getAll() => _db.getAllHostellers();

  @override
  Future<int> update(Hosteller hosteller) => _db.updateHosteller(hosteller);
}
