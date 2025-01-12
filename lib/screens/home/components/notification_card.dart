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
      elevation: 3, // Hiệu ứng nổi của thẻ
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: isRead
          ? Colors.white
          : const Color.fromARGB(
              255, 220, 240, 255), // Màu nền dựa trên trạng thái đọc
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Góc bo tròn
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0), // Padding trong thẻ
        leading: CircleAvatar(
          radius: 24, // Kích thước avatar
          backgroundColor: isRead ? Colors.grey[200] : Colors.green[200],
          child: Icon(
            isRead ? Icons.notifications : Icons.notifications_active,
            color: isRead ? Colors.grey : Colors.green,
            size: 24, // Kích thước icon
          ),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // Đảm bảo tiêu đề không quá dài
          style: TextStyle(
            fontSize: 16,
            fontWeight: isRead
                ? FontWeight.normal
                : FontWeight.bold, // Nhấn mạnh thông báo chưa đọc
            color: isRead ? Colors.black87 : Colors.black,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              _formatDate(createdAt),
              style: const TextStyle(fontSize: 14, color: Colors.blue),
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
