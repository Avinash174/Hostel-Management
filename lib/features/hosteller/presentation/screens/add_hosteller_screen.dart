import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/hosteller_model.dart';
import '../hosteller_provider.dart';

class AddHostellerScreen extends ConsumerStatefulWidget {
  const AddHostellerScreen({super.key});

  @override
  ConsumerState<AddHostellerScreen> createState() => _AddHostellerScreenState();
}

class _AddHostellerScreenState extends ConsumerState<AddHostellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roomController = TextEditingController();
  final _rentController = TextEditingController();
  DateTime _joiningDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roomController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _joiningDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _joiningDate = picked;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final hosteller = Hosteller(
        name: _nameController.text,
        phone: _phoneController.text,
        roomNo: _roomController.text,
        rent: double.parse(_rentController.text),
        joiningDate: _joiningDate,
      );
      
      await ref.read(hostellerListProvider.notifier).addHosteller(hosteller);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Resident')),
        body: MaxWidthContainer(
          maxWidth: 800,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resident Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).animate().fadeIn(),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name', 
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      hintText: 'Enter complete name',
                    ),
                    validator: (v) => v!.isEmpty ? 'Name is required' : null,
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number', 
                      prefixIcon: Icon(Icons.phone_iphone_rounded),
                      hintText: 'e.g. +91 9876543210',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Phone is required' : null,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _roomController,
                          decoration: const InputDecoration(
                            labelText: 'Room No', 
                            prefixIcon: Icon(Icons.meeting_room_rounded),
                            hintText: 'e.g. 101-A',
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _rentController,
                          decoration: const InputDecoration(
                            labelText: 'Rent', 
                            prefixIcon: Icon(Icons.currency_rupee_rounded),
                            hintText: 'Monthly',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceLight.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Joining Date', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              Text(DateFormat('dd MMMM yyyy').format(_joiningDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.edit_calendar_rounded, color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Confirm Registration'),
                  ).animate().fadeIn(delay: 600.ms).scale(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
