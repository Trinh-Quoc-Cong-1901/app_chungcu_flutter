import 'package:flutter/material.dart';

class NotificationCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String timeAgo;

  const NotificationCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              AssetImage(imageUrl), // Sử dụng hình ảnh từ file JSON
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Đảm bảo tiêu đề không quá dài
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 12),
            const SizedBox(width: 4),
            Text(timeAgo),
          ],
        ),
      ),
    );
  }
}
