import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_managemet/core/theme/app_colors.dart';
import 'package:hostel_managemet/shared/widgets/app_background.dart';

class HostelSelectionScreen extends StatelessWidget {
  const HostelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, size: 60, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text(
                  'HostelCare',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Join your hostel to continue',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 100),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Find Your Hostel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                    hintText: 'Search hostel name or location...',
                    fillColor: Colors.white,
                  ),
                  onTap: () => context.push('/hostel-details'), // Direct to details for demo
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/hostel-details'),
                    child: const Text('Search Hostels'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
