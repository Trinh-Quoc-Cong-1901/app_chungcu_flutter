import 'package:flutter/material.dart';

class BusinessCardWidget extends StatelessWidget {
  final Map<String, dynamic> store;
  const BusinessCardWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bo góc card
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              store['image'] ?? 'assets/images/logo.png',
              width: double.infinity,
              height: 140, // Chiều cao hình ảnh
              fit: BoxFit.cover, // Hình ảnh cover toàn bộ diện tích
            ),
          ),
          // Nội dung
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store['name'] ?? 'Không rõ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  store['description'] ?? 'Cửa hàng Ecogreen City',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  store['address'] ?? '286 Nguyễn Xiển, Thanh Xuân, Hà Nội',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
