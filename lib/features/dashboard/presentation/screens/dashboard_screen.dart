import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hostel_managemet/core/theme/app_colors.dart';
import 'package:hostel_managemet/shared/widgets/app_background.dart';
import 'package:hostel_managemet/shared/widgets/app_drawer.dart';
import 'package:hostel_managemet/core/utils/responsive.dart';
import 'package:hostel_managemet/features/payments/presentation/payment_provider.dart';
import 'package:hostel_managemet/features/complaints/presentation/complaint_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintsAsync = ref.watch(complaintListProvider);
    
    return AppBackground(
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            _buildNotificationIcon(context, ref),
            const SizedBox(width: 8),
          ],
        ),
        body: complaintsAsync.when(
          data: (complaints) => MaxWidthContainer(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? 20 : 40, 
                vertical: 24
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildStatsGrid(context, complaints),
                  const SizedBox(height: 40),
                  _buildSectionHeader(context, 'All Complaints', '/complaints'),
                  const SizedBox(height: 16),
                  _buildRecentComplaints(complaints),
                  const SizedBox(height: 32),
                  Text('Management', style: Theme.of(context).textTheme.titleLarge).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 16),
                  _buildActionRows(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context, WidgetRef ref) {
    final pendingDues = ref.watch(pendingDuesProvider);
    return Stack(
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
    );
  }

  Widget _buildStatsGrid(BuildContext context, List<dynamic> complaints) {
    final total = complaints.length;
    final viewed = complaints.where((c) => c.status == 'Viewed').length;
    final inProgress = complaints.where((c) => c.status == 'In Progress').length;
    final solved = complaints.where((c) => c.status == 'Solved').length;

    final data = [
      {'title': 'Total', 'value': '$total', 'icon': Icons.assignment_rounded, 'color': const Color(0xFF4A4E69)},
      {'title': 'Viewed', 'value': '$viewed', 'icon': Icons.remove_red_eye_outlined, 'color': const Color(0xFFE9C46A)},
      {'title': 'In Progress', 'value': '$inProgress', 'icon': Icons.pending_outlined, 'color': const Color(0xFF219EBC)},
      {'title': 'Solved', 'value': '$solved', 'icon': Icons.check_circle_outline_rounded, 'color': const Color(0xFF2A9D8F)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 4 : (Responsive.isTablet(context) ? 2 : 2),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: Responsive.isMobile(context) ? 1.4 : 1.6,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final item = data[index];
        return _SummaryCard(
          title: item['title'] as String,
          value: item['value'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
          delay: Duration(milliseconds: 200 + (index * 100)),
          onTap: () => context.push('/complaints'),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String route) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          TextButton(
            onPressed: () => context.push(route),
            child: const Text('View All'),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildRecentComplaints(List<dynamic> complaints) {
    if (complaints.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('No active complaints', style: TextStyle(color: AppColors.textMuted))),
        ),
      );
    }
    return Column(
      children: complaints.take(5).map((complaint) {
        Color statusColor;
        switch (complaint.status) {
          case 'Solved': statusColor = const Color(0xFF2A9D8F); break;
          case 'In Progress': statusColor = const Color(0xFF219EBC); break;
          default: statusColor = const Color(0xFFE9C46A);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(complaint.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  spacing: 12,
                  children: [
                    _IconInfo(icon: Icons.person_outline, text: complaint.postedBy),
                    _IconInfo(icon: Icons.access_time, text: DateFormat('MMM dd').format(complaint.date)),
                  ],
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  complaint.status, 
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionRows(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _ActionTile(
          icon: Icons.people_alt_rounded,
          title: 'Residents',
          subtitle: 'Manage hostellers',
          color: AppColors.primary,
          delay: 900.ms,
          onTap: () => context.push('/hostellers'),
        ),
        _ActionTile(
          icon: Icons.receipt_long_rounded,
          title: 'Payments',
          subtitle: 'Track dues',
          color: AppColors.secondary,
          delay: 1000.ms,
          onTap: () => context.push('/payments'),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin Dashboard',
          style: Theme.of(context).textTheme.displayLarge,
        ).animate().fadeIn().slideX(begin: -0.1),
        Text(
          'Manage all hostel complaints and residents',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
      ],
    );
  }
}

class _IconInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
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
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28),
              ),
              Text(
                title,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay).scale(begin: const Offset(0.9, 0.9));
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
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
          onTap: onTap,
        ),
      ),
    ).animate().fadeIn(delay: delay).slideY(begin: 0.2);
  }
}
