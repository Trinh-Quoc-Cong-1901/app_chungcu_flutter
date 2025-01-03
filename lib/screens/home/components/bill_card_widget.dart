import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Hạn thanh toán: $paymentDueDate'),
        trailing: Text(
          '$totalAmount VND',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
