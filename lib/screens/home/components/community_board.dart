import 'package:flutter/material.dart';

class CommunityBoardWidget extends StatelessWidget {
  const CommunityBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bo góc card
      ),
      child: Stack(
        children: [
          // Hình ảnh nền
          Container(
            height: 150, // Chiều cao của card
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Bo góc hình ảnh
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/icon_facebook.png'), // Thay thế bằng đường dẫn ảnh nền của bạn
                fit: BoxFit.cover, // Hình ảnh cover toàn bộ diện tích
              ),
            ),
          ),
          // Văn bản với container có nền
          Positioned(
            bottom: 0, // Đặt văn bản ở cuối
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0), // Khoảng cách padding trong Container
              decoration: BoxDecoration(
                color: Colors.blue[100], // Nền màu đen mờ
                borderRadius:
                    BorderRadius.circular(5), // Bo góc nhẹ cho Container
              ),
              child: const Text(
                ' Thông báo quan trọng Thông báo quan trọng Thông báo quan trọng',
                style: TextStyle(
                  color: Colors.green, // Màu trắng cho văn bản
                  fontSize: 14,
                  fontWeight: FontWeight.bold, // Bôi đậm cho văn bản
                ),
                maxLines: 1, // Giới hạn số dòng hiển thị
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
