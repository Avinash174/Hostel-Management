import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/hosteller_repository.dart';
import '../domain/hosteller_model.dart';

enum HostellerFilter { all, active, inactive }

// Defining Repository Provider
final hostellerRepositoryProvider = Provider<IHostellerRepository>((ref) {
  return HostellerRepository();
});

class HostellerListNotifier extends AsyncNotifier<List<Hosteller>> {
  @override
  FutureOr<List<Hosteller>> build() {
    return _fetchHostellers();
  }

  Future<List<Hosteller>> _fetchHostellers() {
    return ref.read(hostellerRepositoryProvider).getAll();
  }

  Future<void> addHosteller(Hosteller hosteller) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(hostellerRepositoryProvider).add(hosteller);
      return _fetchHostellers();
    });
  }

  Future<void> updateHosteller(Hosteller hosteller) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(hostellerRepositoryProvider).update(hosteller);
      return _fetchHostellers();
    });
  }

  Future<void> deleteHosteller(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(hostellerRepositoryProvider).delete(id);
      return _fetchHostellers();
    });
  }
}

final hostellerListProvider = AsyncNotifierProvider<HostellerListNotifier, List<Hosteller>>(() {
  return HostellerListNotifier();
});

final searchHostellerProvider = StateProvider<String>((ref) => '');
final filterProvider = StateProvider<HostellerFilter>((ref) => HostellerFilter.all);

final filteredHostellerProvider = Provider<List<Hosteller>>((ref) {
  final hostellersAsync = ref.watch(hostellerListProvider);
  final search = ref.watch(searchHostellerProvider).toLowerCase();
  final filter = ref.watch(filterProvider);
  
  return hostellersAsync.when(
    data: (hostellers) {
      List<Hosteller> filtered = hostellers;

      if (filter == HostellerFilter.active) {
        filtered = filtered.where((h) => h.isActive).toList();
      } else if (filter == HostellerFilter.inactive) {
        filtered = filtered.where((h) => !h.isActive).toList();
      }

      if (search.isNotEmpty) {
        filtered = filtered.where((h) => 
          h.name.toLowerCase().contains(search) || 
          h.roomNo.toLowerCase().contains(search) ||
          h.phone.contains(search)
        ).toList();
      }
      return filtered;
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});
