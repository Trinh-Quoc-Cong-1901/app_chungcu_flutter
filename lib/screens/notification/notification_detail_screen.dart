import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String title;
  final String time;
  final String content;

  NotificationDetailScreen({
    required this.title,
    required this.time,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh ở đầu màn hình chi tiết
            Center(
              child: Image.asset(
                'assets/images/hot_line.png', // Sử dụng một hình ảnh mẫu (thay thế bằng đường dẫn phù hợp)
                height: 300,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16),

            // Tiêu đề thông báo
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Thông tin thời gian và nơi gửi
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey, size: 20),
                SizedBox(width: 5),
                Text('Eco Green City'),
                SizedBox(width: 20),
                Icon(Icons.access_time, color: Colors.grey, size: 20),
                SizedBox(width: 5),
                Text(time),
              ],
            ),
            SizedBox(height: 16),

            // Nội dung thông báo
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5, // Độ cao dòng để cải thiện khả năng đọc
              ),
            ),
          ],
        ),
      ),
    );
  }
}
