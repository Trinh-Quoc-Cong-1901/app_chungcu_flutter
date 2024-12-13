import 'package:flutter/material.dart';
import 'bill_payment_screen.dart'; // Import màn hình thanh toán hóa đơn

class BillDetailScreen extends StatelessWidget {
  final Map<String, dynamic> billData;

  const BillDetailScreen({super.key, required this.billData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chi tiết hóa đơn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Title: ${billData['title']}'),
            Text('Tổng tiền: ${billData['totalAmount']}'),
            Text('Hạn đóng tiền: ${billData['time']}'),
            const SizedBox(height: 16),
            for (var serviceFee in billData['serviceFees'])
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(serviceFee['name']),
                  subtitle: Text(serviceFee['details']),
                  trailing: Text(
                    '${serviceFee['amount']} USD',
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text('Trạng thái: ${billData['status']}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: billData['status'] == 'Chưa thanh toán'
                        ? Colors.red
                        : Colors.green)),
            const SizedBox(height: 16),
            if (billData['status'] == 'Chưa thanh toán')
              ElevatedButton(
                onPressed: () {
                  // Chuyển sang màn hình thanh toán hóa đơn và truyền hóa đơn đã chọn
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BillPaymentScreen(
                        unpaidBills: [
                          billData
                        ], // Truyền hóa đơn cần thanh toán
                        preselectedBills: [
                          billData
                        ], // Tự động tích chọn hóa đơn này
                      ),
                    ),
                  );
                },
                child: const Text('Thanh toán'),
              ),
          ],
        ),
      ),
    );
  }
}
