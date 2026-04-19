import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_managemet/core/theme/app_colors.dart';
import 'package:hostel_managemet/shared/widgets/app_background.dart';
import 'package:hostel_managemet/core/utils/responsive.dart';
import 'package:hostel_managemet/features/complaints/presentation/complaint_provider.dart';
import 'package:hostel_managemet/features/complaints/domain/complaint_model.dart';

class PostComplaintScreen extends ConsumerStatefulWidget {
  const PostComplaintScreen({super.key});

  @override
  ConsumerState<PostComplaintScreen> createState() => _PostComplaintScreenState();
}

class _PostComplaintScreenState extends ConsumerState<PostComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final complaint = Complaint(
        title: _titleController.text,
        description: _descController.text,
        postedBy: 'Avinash', // Mock user for now
        roomNo: '101',
        date: DateTime.now(),
      );

      await ref.read(complaintListProvider.notifier).addComplaint(complaint);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complaint submitted successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: MaxWidthContainer(
                maxWidth: 600,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Posted By'),
                        _buildUserChip(),
                        const SizedBox(height: 24),
                        _buildLabel('Problem Title'),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'e.g., Water leakage in bathroom',
                            fillColor: Color(0xFFF7F8FA),
                          ),
                          validator: (v) => v!.isEmpty ? 'Title is required' : null,
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('Description'),
                        TextFormField(
                          controller: _descController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'Describe the problem in detail...',
                            fillColor: Color(0xFFF7F8FA),
                          ),
                          validator: (v) => v!.isEmpty ? 'Description is required' : null,
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('Photo (Optional)'),
                        _buildUploadBox(),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE0E3E8), // Mock disabled/flat look
                              foregroundColor: Colors.grey,
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.send_rounded, size: 18),
                                SizedBox(width: 8),
                                Text('Submit Complaint'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          const Text(
            'Post a Problem',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Positioned(
            right: 16,
            child: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildUserChip() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Text('A', style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
          const SizedBox(width: 12),
          const Text('Avinash', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), style: BorderStyle.none), // Simplified
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image_outlined, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          const Text('Upload Photo', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
