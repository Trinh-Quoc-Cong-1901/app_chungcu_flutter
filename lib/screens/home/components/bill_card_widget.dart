import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillCardWidget extends StatelessWidget {
  final String title;
  final String paymentDueDate;
  final String totalAmount;

  const BillCardWidget({
    super.key,
    required this.title,
    required this.paymentDueDate,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon đại diện hóa đơn
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(
                Icons.receipt_long,
                size: 32,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16.0),
            // Nội dung chính
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Hạn: $paymentDueDate',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Tổng tiền: ${_formatCurrency(totalAmount)} VND',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(String amount) {
    try {
      final double parsedAmount = double.parse(
        amount.replaceAll(RegExp(r'[^0-9.]'), ''),
      );
      return NumberFormat('#,###', 'vi').format(parsedAmount);
    } catch (e) {
      return '0'; // Trả về "0" nếu có lỗi khi chuyển đổi
    }
  }
}
