import 'package:ecogreen_city/screens/feed/feed_detail_screen.dart';
import 'package:flutter/material.dart';

class CommunityBoardWidget extends StatelessWidget {
  final Map<String, dynamic> feed;

  const CommunityBoardWidget({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedDetailScreen(post: feed),
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
            // Hình ảnh nền
            Container(
              height: 140, // Chiều cao của card
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ), // Bo góc chỉ cho phần trên
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/logo.png', // Thay thế bằng đường dẫn ảnh của bạn
                  ),
                  fit: BoxFit.cover, // Hình ảnh cover toàn bộ diện tích
                ),
              ),
            ),
            // Nội dung văn bản
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    feed['title'] ?? 'Không có tiêu đề',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // Bôi đậm cho tiêu đề
                    ),
                    maxLines: 2, // Giới hạn số dòng hiển thị
                    overflow: TextOverflow.ellipsis,
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
