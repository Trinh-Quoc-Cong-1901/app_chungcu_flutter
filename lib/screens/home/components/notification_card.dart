// import 'package:flutter/material.dart';

// class NotificationCardWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(
//               'https://via.placeholder.com/150'), // Thay bằng hình ảnh thực tế
//         ),
//         title: Text('ĐÍNH CHÍNH THÔNG TIN NGÂN HÀNG THỤ HƯỞ...'),
//         subtitle: Row(
//           children: [
//             Icon(Icons.access_time, size: 12),
//             SizedBox(width: 4),
//             Text('2 tháng trước'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NotificationCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String timeAgo;

  NotificationCardWidget({
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
            Icon(Icons.access_time, size: 12),
            SizedBox(width: 4),
            Text(timeAgo),
          ],
        ),
      ),
    );
  }
}
