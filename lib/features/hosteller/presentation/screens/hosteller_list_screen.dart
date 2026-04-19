import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../hosteller_provider.dart';

class HostellerListScreen extends ConsumerWidget {
  final bool selectForPayment;
  const HostellerListScreen({super.key, this.selectForPayment = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredHostellers = ref.watch(filteredHostellerProvider);
    
    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text(selectForPayment ? 'Choose Resident' : 'Resident Directory'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(130),
            child: MaxWidthContainer(
              maxWidth: 800,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: TextField(
                      onChanged: (value) => ref.read(searchHostellerProvider.notifier).state = value,
                      decoration: InputDecoration(
                        hintText: 'Search by name, room or phone...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                        fillColor: AppColors.surface.withValues(alpha: 0.5),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      children: HostellerFilter.values.map((f) {
                        final isSelected = ref.watch(filterProvider) == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f.name.toUpperCase()),
                            selected: isSelected,
                            onSelected: (val) => ref.read(filterProvider.notifier).state = f,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: MaxWidthContainer(
          maxWidth: 800,
          child: filteredHostellers.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_search_rounded, size: 80, color: AppColors.textMuted.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text('No residents found', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: filteredHostellers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final hosteller = filteredHostellers[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            hosteller.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      title: Text(hosteller.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Room ${hosteller.roomNo} • ${hosteller.phone}', style: const TextStyle(color: AppColors.textMuted)),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.chevron_right_rounded, size: 20),
                      ),
                      onTap: () {
                        if (selectForPayment) {
                          context.push('/payments/entry', extra: hosteller);
                        } else {
                          context.push('/hostellers/details', extra: hosteller);
                        }
                      },
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
