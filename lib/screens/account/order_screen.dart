import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecogreen_city/services/data_service.dart';
import 'order_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final DataService _dataService = DataService();
  late Future<List<dynamic>> _orders;

  List<dynamic> orderedOrders = [];
  List<dynamic> shippingOrders = [];
  List<dynamic> deliveredOrders = [];

  @override
  void initState() {
    super.initState();
    _orders = _dataService.loadOrders();
  }

  void _categorizeOrders(List<dynamic> orders) {
    orderedOrders =
        orders.where((order) => order['status'] == 'ordered').toList();
    shippingOrders =
        orders.where((order) => order['status'] == 'shipping').toList();
    deliveredOrders =
        orders.where((order) => order['status'] == 'delivered').toList();
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(amount);
  }

  void _navigateToOrderDetail(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(orderData: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng '),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không tìm thấy đơn hàng'));
          }

          final orders = snapshot.data!;
          _categorizeOrders(orders);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Danh sách ordered
                if (orderedOrders.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Đơn hàng đang xử lý:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...orderedOrders.map((order) => GestureDetector(
                        onTap: () => _navigateToOrderDetail(order),
                        child: _buildOrderCard(order),
                      )),
                ],
                // Danh sách shipping
                if (shippingOrders.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Đơn hàng đang giao:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...shippingOrders.map((order) => GestureDetector(
                        onTap: () => _navigateToOrderDetail(order),
                        child: _buildOrderCard(order),
                      )),
                ],
                // Danh sách delivered
                if (deliveredOrders.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Đơn hàng đã giao:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...deliveredOrders.map((order) => GestureDetector(
                        onTap: () => _navigateToOrderDetail(order),
                        child: _buildOrderCard(order),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã đơn hàng: ${order['_id']}',
              maxLines: 2,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Tổng tiền: ${_formatCurrency(order['totalAmount']?.toDouble() ?? 0)}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal),
            ),
            const SizedBox(height: 8),
            Text(
              'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(order['createdAt']).toLocal())}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            const Text(
              'Danh sách sản phẩm:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...order['products'].map<Widget>((product) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] ?? 'Tên sản phẩm',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '${product['quantity']} x ${_formatCurrency(product['price']?.toDouble() ?? 0)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
