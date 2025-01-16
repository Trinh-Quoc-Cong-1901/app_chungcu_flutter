import 'package:ecogreen_city/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailScreen({super.key, required this.orderData});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final AuthService _authService = AuthService();
  bool _isUpdating = false; // Trạng thái đang cập nhật đơn hàng

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(amount);
  }

  Future<void> _updateOrderStatus(BuildContext context) async {
    final token = await _authService.getAccessToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa đăng nhập.')),
      );
      return;
    }

    final url =
        'http://192.168.1.9:3000/api/orders/user/${widget.orderData['_id']}';

    String nextStatus;
    if (widget.orderData['status'] == 'ordered') {
      nextStatus = 'shipping';
    } else if (widget.orderData['status'] == 'shipping') {
      nextStatus = 'delivered';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Không thể cập nhật trạng thái đơn hàng.')),
      );
      return;
    }

    try {
      setState(() {
        _isUpdating = true;
      });

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': nextStatus}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Đơn hàng đã được cập nhật thành "$nextStatus"!')),
        );

        setState(() {
          widget.orderData['status'] = nextStatus;
        });

        Navigator.pop(context);
      } else {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${error['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Lỗi không thể cập nhật trạng thái đơn hàng: $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Xác định trạng thái đơn hàng
    String orderStatus;
    Color statusColor;

    if (widget.orderData['status'] == 'ordered') {
      orderStatus = 'Đơn hàng đang xử lý';
      statusColor = Colors.orange;
    } else if (widget.orderData['status'] == 'shipping') {
      orderStatus = 'Đơn hàng đang giao';
      statusColor = Colors.blue;
    } else {
      orderStatus = 'Đơn hàng đã giao';
      statusColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết đơn hàng',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Mã đơn hàng: ${widget.orderData['_id']}'),
                    Text(
                      'Tổng tiền: ${_formatCurrency(widget.orderData['totalAmount']?.toDouble() ?? 0)}',
                    ),
                    Text(
                      'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.orderData['createdAt']).toLocal())}',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Trạng thái: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          orderStatus,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Danh sách sản phẩm:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    for (var product in widget.orderData['products'])
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
            if (widget.orderData['status'] == 'shipping') ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isUpdating
                    ? null
                    : () async {
                        await _updateOrderStatus(context);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: _isUpdating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Nhận đơn hàng'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
