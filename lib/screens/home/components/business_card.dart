import 'package:ecogreen_city/screens/stores/detail_store_screen.dart';
import 'package:flutter/material.dart';

class BusinessCardWidget extends StatelessWidget {
  final Map<String, dynamic> store;
  const BusinessCardWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailStoreScreen(store: store),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bo góc card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                store['image'] ??
                    'https://example.com/default-logo.png', // Đường dẫn ảnh từ mạng
                width: double.infinity,
                height: 140, // Chiều cao hình ảnh
                fit: BoxFit.cover, // Hình ảnh cover toàn bộ diện tích
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/logo.png', // Ảnh mặc định khi không tải được
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                  );
                },
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
                    maxLines: 1, // Giới hạn chỉ 1 dòng
                    overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
