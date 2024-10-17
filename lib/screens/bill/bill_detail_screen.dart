import 'package:flutter/material.dart';

class BillDetailScreen extends StatelessWidget {
  final Map<String, dynamic> billData;

  BillDetailScreen({required this.billData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết hóa đơn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết hóa đơn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Title: ${billData['title']}'),
            Text('Tổng tiền: ${billData['totalAmount']}'),
            Text('Thời gian: ${billData['time']}'),
            SizedBox(height: 16),
            for (var serviceFee in billData['serviceFees'])
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(serviceFee['name']),
                  subtitle: Text(serviceFee['details']),
                  trailing: Text(serviceFee['amount']),
                ),
              ),
            SizedBox(height: 16),
            Text('Trạng thái: ${billData['status']}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: billData['status'] == 'Chưa thanh toán'
                        ? Colors.red
                        : Colors.green)),
            SizedBox(height: 16),
            if (billData['status'] == 'Chưa thanh toán')
              ElevatedButton(
                onPressed: () {
                  // Xử lý thanh toán ở đây
                },
                child: Text('Thanh toán'),
              ),
          ],
        ),
      ),
    );
  }
}
