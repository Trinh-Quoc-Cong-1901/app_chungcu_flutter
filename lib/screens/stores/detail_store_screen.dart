import 'package:flutter/material.dart';

class DetailStoreScreen extends StatelessWidget {
  final Map<String, dynamic> store;
  const DetailStoreScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final products = store['products'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(store['name'] ?? 'Chi tiết cửa hàng'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              store['address'] ?? 'Không có địa chỉ',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(
                          product['name']?[0] ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(product['name'] ?? 'Sản phẩm không tên'),
                      subtitle: Text('Giá: ${product['price']}đ'),
                      trailing: Text('Còn lại: ${product['stock']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
