import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../../../hosteller/presentation/hosteller_provider.dart';
import '../../../payments/presentation/payment_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostellersAsync = ref.watch(hostellerListProvider);
    final pendingDues = ref.watch(pendingDuesProvider);
    
    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hostel Hub'),
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () => context.push('/dashboard/notifications'),
                  icon: const Icon(Icons.notifications_none_rounded, size: 28),
                ),
                if (pendingDues.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${pendingDues.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: hostellersAsync.when(
          data: (hostellers) {
            const int totalRooms = 50;
            final int availableRooms = totalRooms - hostellers.length;

            return MaxWidthContainer(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 24 : 48, 
                  vertical: 24
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    Text(
                      'Hostel Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isDesktop(context) ? 4 : (Responsive.isTablet(context) ? 3 : 2),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: Responsive.isMobile(context) ? 1.1 : 1.3,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final data = [
                          {
                            'title': 'Residents',
                            'value': '${hostellers.length}',
                            'icon': Icons.people_alt_rounded,
                            'color': AppColors.primary,
                            'onTap': () => context.push('/hostellers'),
                          },
                          {
                            'title': 'Unpaid',
                            'value': '${pendingDues.length}',
                            'icon': Icons.error_outline_rounded,
                            'color': AppColors.error,
                            'onTap': () => context.push('/payments'),
                          },
                          {
                            'title': 'Available',
                            'value': '$availableRooms',
                            'icon': Icons.bed_rounded,
                            'color': AppColors.secondary,
                            'onTap': () {},
                          },
                          {
                            'title': 'Reports',
                            'value': 'View',
                            'icon': Icons.bar_chart_rounded,
                            'color': AppColors.info,
                            'onTap': () {},
                          },
                        ];
                        final item = data[index];
                        return _SummaryCard(
                          title: item['title'] as String,
                          value: item['value'] as String,
                          icon: item['icon'] as IconData,
                          color: item['color'] as Color,
                          delay: Duration(milliseconds: 200 + (index * 100)),
                          onTap: item['onTap'] as VoidCallback,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 16),
                    _buildActionRows(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildActionRows(BuildContext context) {
    final actions = [
      _ActionTile(
        icon: Icons.add_business_rounded,
        title: 'Register New Hosteller',
        subtitle: 'Add details and room assignment',
        color: AppColors.primary,
        delay: 700.ms,
        onTap: () => context.push('/hostellers/add'),
      ),
      _ActionTile(
        icon: Icons.payments_rounded,
        title: 'Collect Rent',
        subtitle: 'Record monthly dues payment',
        color: AppColors.secondary,
        delay: 800.ms,
        onTap: () => context.push('/hostellers?selectForPayment=true'),
      ),
    ];

    if (Responsive.isMobile(context)) {
      return Column(
        children: actions.map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: a,
        )).toList(),
      );
    } else {
      return Row(
        children: actions.map((a) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: a,
          ),
        )).toList(),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Administrator',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ).animate().fadeIn().slideX(begin: -0.1),
        Text(
          'Manage Your Oasis',
          style: Theme.of(context).textTheme.displayLarge,
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Duration delay;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Duration delay;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    ).animate().fadeIn(delay: delay).slideY(begin: 0.2);
  }
}
