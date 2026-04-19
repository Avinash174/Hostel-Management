import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../../../hosteller/domain/hosteller_model.dart';
import '../payment_provider.dart';

class PendingDuesScreen extends ConsumerWidget {
  const PendingDuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingDues = ref.watch(pendingDuesProvider);
    final currentMonthName = DateFormat('MMMM yyyy').format(DateTime.now());

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Pending Dues')),
        body: MaxWidthContainer(
          maxWidth: 800,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Showing pending payments for $currentMonthName',
                        style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: pendingDues.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, size: 60, color: AppColors.secondary),
                            const SizedBox(height: 16),
                            const Text('All dues are clear!', style: TextStyle(color: AppColors.textMuted)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: pendingDues.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final due = pendingDues[index];
                          final hosteller = due['hosteller'] as Hosteller;
                          
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              title: Text(hosteller.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Room: ${hosteller.roomNo} • Due: ₹${due['amount']}'),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  minimumSize: const Size(80, 40),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                                onPressed: () => context.push('/payments/entry', extra: hosteller),
                                child: const Text('Pay'),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
