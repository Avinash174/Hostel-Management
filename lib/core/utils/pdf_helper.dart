import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:hostel_managemet/features/hosteller/domain/hosteller_model.dart';
import 'package:hostel_managemet/features/payments/domain/payment_model.dart';
import 'package:intl/intl.dart';

class PdfHelper {
  static Future<void> generateHostellerReport(Hosteller hosteller, List<Payment> payments) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, text: 'Hostel Payment Report'),
              pw.SizedBox(height: 20),
              pw.Text('Hosteller: ${hosteller.name}'),
              pw.Text('Room No: ${hosteller.roomNo}'),
              pw.Text('Phone: ${hosteller.phone}'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Date', 'Amount', 'Mode', 'Period'],
                data: payments.map((p) => [
                  DateFormat('dd/MM/yyyy').format(p.date),
                  'INR ${p.amount}',
                  p.mode,
                  '${DateFormat('MMM').format(DateTime(2022, p.month))} ${p.year}'
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
