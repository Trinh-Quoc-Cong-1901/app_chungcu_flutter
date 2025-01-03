import 'package:flutter/material.dart';

class NotificationCardWidget extends StatelessWidget {
  final String title;
  final bool isRead;
  final String createdAt;

  const NotificationCardWidget({
    super.key,
    required this.title,
    required this.isRead,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: isRead
          ? Colors.white
          : const Color.fromARGB(
              255, 166, 220, 246), // Màu nền dựa trên trạng thái đọc
      child: ListTile(
        leading: Icon(
          isRead ? Icons.notifications : Icons.notifications_active,
          color: isRead ? Colors.grey : Colors.green,
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // Đảm bảo tiêu đề không quá dài
          style: TextStyle(
            fontWeight: isRead
                ? FontWeight.normal
                : FontWeight.bold, // Nhấn mạnh thông báo chưa đọc
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              _formatDate(createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm format ngày giờ
  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
