import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_managemet/core/theme/app_colors.dart';
import 'package:hostel_managemet/features/auth/presentation/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            width: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sunrise Hostel',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Current Hostel',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_customize_rounded,
                  label: 'Guest Dashboard',
                  onTap: () => context.go('/dashboard'),
                ),
                _DrawerItem(
                  icon: Icons.assignment_rounded,
                  label: 'My Complaints',
                  onTap: () => context.push('/complaints'),
                ),
                 _DrawerItem(
                  icon: Icons.people_outline_rounded,
                  label: 'Hostellers',
                  onTap: () => context.push('/hostellers'),
                ),
                 _DrawerItem(
                  icon: Icons.payments_outlined,
                  label: 'Payments',
                  onTap: () => context.push('/payments'),
                ),
                _DrawerItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () {},
                ),
                const Divider(height: 32),
                _DrawerItem(
                  icon: Icons.exit_to_app_rounded,
                  label: 'Exit Current Hostel',
                  color: AppColors.error,
                  onTap: () => ref.read(authProvider.notifier).logout(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings_outlined, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text('Admin Login', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(label, style: TextStyle(color: color ?? AppColors.textSecondary, fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
