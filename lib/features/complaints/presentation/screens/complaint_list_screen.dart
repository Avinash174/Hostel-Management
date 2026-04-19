import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../complaint_provider.dart';
import '../../domain/complaint_model.dart';

class ComplaintListScreen extends ConsumerStatefulWidget {
  const ComplaintListScreen({super.key});

  @override
  ConsumerState<ComplaintListScreen> createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends ConsumerState<ComplaintListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Viewed', 'In Progress', 'Solved'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Complaints'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((tab) => _ComplaintListView(status: tab)).toList(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/complaints/post'),
          icon: const Icon(Icons.add_comment_rounded),
          label: const Text('Post Problem'),
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }
}

class _ComplaintListView extends ConsumerWidget {
  final String status;
  const _ComplaintListView({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaints = ref.watch(filteredComplaintsProvider(status));

    if (complaints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_rounded, size: 64, color: AppColors.textMuted.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No complaints found', style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return MaxWidthContainer(
      maxWidth: 800,
      child: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: complaints.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return _ComplaintCard(complaint: complaint);
        },
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  const _ComplaintCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (complaint.status) {
      case 'Solved':
        statusColor = AppColors.secondary;
        break;
      case 'In Progress':
        statusColor = AppColors.info;
        break;
      default:
        statusColor = AppColors.error;
    }

    return Card(
      child: ExpansionTile(
        title: Text(complaint.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Text(DateFormat('MMM dd, yyyy').format(complaint.date), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Text(complaint.status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(complaint.description, style: const TextStyle(color: AppColors.textMuted)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Posted by: ${complaint.postedBy}', style: const TextStyle(fontSize: 12)),
                    Text('Room: ${complaint.roomNo}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
