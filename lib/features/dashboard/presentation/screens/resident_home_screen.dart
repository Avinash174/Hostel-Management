import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_managemet/core/theme/app_colors.dart';
import 'package:hostel_managemet/shared/widgets/app_background.dart';

class ResidentHomeScreen extends StatelessWidget {
  const ResidentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            _buildTopHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, 'Your Complaints'),
                    const SizedBox(height: 16),
                    _buildComplaintList(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/complaints/post'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
              const Icon(Icons.menu, color: Colors.white),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Welcome, Avinash',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Text(
            'Sunrise Hostel',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Manage your complaints and requests',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/complaints/post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                   Icon(Icons.add_circle, size: 20),
                   SizedBox(width: 12),
                   Text('Post a Problem', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => context.push('/complaints'),
          child: const Text('View All', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildComplaintList() {
    final complaints = [
      {'title': 'Water leakage in bathroom', 'date': 'Nov 12, 2025', 'color': Colors.blue},
      {'title': 'AC not working properly', 'date': 'Nov 10, 2025', 'color': Colors.orange},
      {'title': 'WIFI connection issue', 'date': 'Nov 9, 2025', 'color': Colors.teal},
    ];

    return Column(
      children: complaints.map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withAlpha(20)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(c['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(c['date'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (c['color'] as Color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForIndex(complaints.indexOf(c)), 
                size: 16, 
                color: c['color'] as Color
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  IconData _getIconForIndex(int i) {
    if (i == 0) return Icons.refresh_rounded;
    if (i == 1) return Icons.remove_red_eye_outlined;
    return Icons.check_circle_outline_rounded;
  }
}
