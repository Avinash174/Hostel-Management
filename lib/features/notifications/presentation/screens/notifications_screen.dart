import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../../../payments/presentation/payment_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingDuesProvider);

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: MaxWidthContainer(
          maxWidth: 800,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'System Notifications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (pending.isNotEmpty)
                _NotificationCard(
                  title: '${pending.length} Payments Pending',
                  message: 'Remind hostellers to pay their rent for this month.',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.error,
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reminders sent to all pending hostellers! (Mock)')),
                    );
                  },
                  actionLabel: 'Send All Reminders',
                ),
              const SizedBox(height: 12),
              const _NotificationCard(
                title: 'System Update',
                message: 'Hostel Management system updated to version 1.0.0',
                icon: Icons.info_outline,
                color: AppColors.info,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
          if (onAction != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
