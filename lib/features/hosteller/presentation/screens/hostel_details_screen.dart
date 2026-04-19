import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_managemet/core/theme/app_colors.dart';
import 'package:hostel_managemet/shared/widgets/app_background.dart';

class HostelDetailsScreen extends StatelessWidget {
  const HostelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainInfoCard(),
                    const SizedBox(height: 32),
                    _buildAboutSection(),
                    const SizedBox(height: 32),
                    _buildAmenitiesSection(),
                    const SizedBox(height: 32),
                    _buildFeaturesList(),
                    const SizedBox(height: 48),
                    _buildJoinButton(context),
                    const SizedBox(height: 16),
                    _buildReportButton(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          const Text(
            'Hostel Details',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Positioned(
            right: 16,
            child: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sunrise Hostel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('Mumbai', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatItem('4.5', 'Rating', Icons.star_rounded, Colors.amber),
                const SizedBox(width: 32),
                _buildStatItem('234', 'Reviews', Icons.comment_rounded, AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          'A modern and well-maintained hostel with excellent facilities. Our hostel provides a safe and comfortable living environment for students and working professionals.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.8,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildAmenityItem(Icons.wifi, 'Free Wifi'),
            _buildAmenityItem(Icons.restaurant, 'Meals'),
            _buildAmenityItem(Icons.security, '24/7 Security'),
            _buildAmenityItem(Icons.group, 'Common Area'),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Real-time complaint tracking',
      'Quick response from management',
      '24/7 support system',
    ];
    return Column(
      children: features.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, size: 20, color: Colors.teal),
            const SizedBox(width: 12),
            Text(f, style: const TextStyle(fontSize: 14)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.go('/welcome'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.tealAccent.shade100,
          foregroundColor: Colors.teal,
          elevation: 0,
        ),
        child: const Text('Already Joined'),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => context.push('/complaints/post'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.message_rounded, size: 20),
            SizedBox(width: 12),
            Text('Report a Problem'),
          ],
        ),
      ),
    );
  }
}
