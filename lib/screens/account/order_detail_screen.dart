import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailScreen({super.key, required this.orderData});

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Xác định trạng thái đơn hàng
    String orderStatus = orderData['status'] == 'ordered'
        ? 'Đơn hàng đang xử lý'
        : 'Đơn hàng đã giao';

    Color statusColor =
        orderData['status'] == 'ordered' ? Colors.orange : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chi tiết đơn hàng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Mã đơn hàng: ${orderData['_id']}'),
              Text(
                'Tổng tiền: ${_formatCurrency(orderData['totalAmount']?.toDouble() ?? 0)}',
              ),
              Text(
                'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(orderData['createdAt']).toLocal())}',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Trạng thái: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    orderStatus,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Danh sách sản phẩm:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (var product in orderData['products'])
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product['image'] ?? 'assets/images/logo.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    title: Text(product['name'] ?? 'Tên sản phẩm'),
                    subtitle: Text(
                      '${product['quantity']} x ${_formatCurrency(product['price']?.toDouble() ?? 0)}',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
