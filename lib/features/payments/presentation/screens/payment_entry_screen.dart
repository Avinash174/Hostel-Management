import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../core/utils/responsive.dart';
import '../../../hosteller/domain/hosteller_model.dart';
import '../../domain/payment_model.dart';
import '../payment_provider.dart';

class PaymentEntryScreen extends ConsumerStatefulWidget {
  final Hosteller hosteller;
  const PaymentEntryScreen({super.key, required this.hosteller});

  @override
  ConsumerState<PaymentEntryScreen> createState() => _PaymentEntryScreenState();
}

class _PaymentEntryScreenState extends ConsumerState<PaymentEntryScreen> {
  final _amountController = TextEditingController();
  String _selectedMode = 'Online';
  final DateTime _paymentDate = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.hosteller.rent.toString();
  }

  void _savePayment() async {
    if (_amountController.text.isEmpty) return;

    final payment = Payment(
      hostellerId: widget.hosteller.id!,
      amount: double.parse(_amountController.text),
      date: _paymentDate,
      mode: _selectedMode,
      month: _selectedMonth,
      year: _selectedYear,
    );

    await ref.read(paymentListProvider.notifier).addPayment(payment);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment recorded successfully')),
      );
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('New Payment')),
        body: Center(
          child: MaxWidthContainer(
            maxWidth: 600,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Paying for: ${widget.hosteller.name}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount Paid', prefixIcon: Icon(Icons.currency_rupee_rounded)),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  const Text('Payment Mode', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: ['Online', 'Cash', 'Cheque'].map((mode) => ChoiceChip(
                      label: Text(mode),
                      selected: _selectedMode == mode,
                      onSelected: (val) => setState(() => _selectedMode = mode),
                    )).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Month', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedMonth,
                                  isExpanded: true,
                                  items: List.generate(12, (index) => DropdownMenuItem(
                                    value: index + 1,
                                    child: Text(DateFormat('MMMM').format(DateTime(2022, index + 1))),
                                  )),
                                  onChanged: (v) => setState(() => _selectedMonth = v!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Year', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedYear,
                                  isExpanded: true,
                                  items: [2024, 2025, 2026].map((y) => DropdownMenuItem(
                                    value: y,
                                    child: Text('$y'),
                                  )).toList(),
                                  onChanged: (v) => setState(() => _selectedYear = v!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: _savePayment,
                    child: const Text('Submit Payment'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
