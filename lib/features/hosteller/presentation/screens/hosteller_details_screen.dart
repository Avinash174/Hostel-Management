import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/pdf_helper.dart';
import '../../domain/hosteller_model.dart';
import '../../../payments/domain/payment_model.dart';
import '../../../payments/presentation/payment_provider.dart';

class HostellerDetailsScreen extends ConsumerWidget {
  final Hosteller hosteller;
  const HostellerDetailsScreen({super.key, required this.hosteller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = !Responsive.isMobile(context);

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resident Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () async {
                final payments = await ref.read(paymentListProvider.notifier).getHostellerPayments(hosteller.id!);
                await PdfHelper.generateHostellerReport(hosteller, payments);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: MaxWidthContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildProfileSection(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 3, child: _buildHistorySection(context, ref)),
                    ],
                  )
                : Column(
                    children: [
                      _buildProfileSection(context),
                      const SizedBox(height: 32),
                      _buildHistorySection(context, ref),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    hosteller.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(hosteller.name, style: Theme.of(context).textTheme.displayMedium),
              Text(hosteller.phone, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _InfoRow(label: 'Room Number', value: hosteller.roomNo, icon: Icons.meeting_room_rounded),
                const Divider(height: 32, color: AppColors.glassBorder),
                _InfoRow(label: 'Monthly Rent', value: '₹${hosteller.rent}', icon: Icons.currency_rupee_rounded),
                const Divider(height: 32, color: AppColors.glassBorder),
                _InfoRow(
                    label: 'Joining Date',
                    value: DateFormat('dd MMM yyyy').format(hosteller.joiningDate),
                    icon: Icons.calendar_today_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history_rounded, color: AppColors.secondary),
            const SizedBox(width: 8),
            Text('Payment History', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Payment>>(
          future: ref.read(paymentListProvider.notifier).getHostellerPayments(hosteller.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final payments = snapshot.data ?? [];
            if (payments.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text('No payment history recorded yet.', 
                    style: TextStyle(color: AppColors.textMuted)),
                ),
              );
            }

            // Monthly Grouping
            final grouped = <String, List<Payment>>{};
            for (var p in payments) {
              final key = '${DateFormat('MMMM').format(DateTime(2022, p.month))} ${p.year}';
              grouped.putIfAbsent(key, () => []).add(p);
            }

            return Column(
              children: grouped.entries.map((group) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(group.key, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  ),
                  ...group.value.map((payment) => Card(
                    color: AppColors.surface.withValues(alpha: 0.3),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.receipt_long_rounded, color: AppColors.secondary),
                      ),
                      title: Text('₹${payment.amount} via ${payment.mode}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(DateFormat('dd MMM yyyy').format(payment.date)),
                    ),
                  )),
                ],
              )).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
