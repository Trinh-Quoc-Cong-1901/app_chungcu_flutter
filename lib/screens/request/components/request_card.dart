import 'dart:convert'; // Để sử dụng base64Decode
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> requestData; // Dữ liệu yêu cầu

  const RequestCard({super.key, required this.requestData});

  // Hàm xác định màu thẻ dựa trên trạng thái
  Color _getCardColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange[100]!;
      case 'In Progress':
        return Colors.blue[100]!;
      case 'Resolved':
        return Colors.green[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  // Hàm hiển thị hình ảnh đầy đủ
  void _showFullImage(BuildContext context, String imageBase64) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Center(
                child: Image.memory(
                  base64Decode(imageBase64),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getCardColor(
          requestData['status']), // Thay đổi màu nền theo trạng thái
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị tiêu đề
            Text(
              requestData['title'], // Tiêu đề
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Hiển thị loại phản ánh
            Text('Loại phản ánh: ${requestData['feedbackType']}'),
            const SizedBox(height: 8),

            // Hiển thị mức độ ưu tiên
            Text('Mức độ ưu tiên: ${requestData['priority']}'),
            const SizedBox(height: 8),

            // Hiển thị nội dung
            Text(
              'Nội dung: ${requestData['content']}',
              maxLines: 3, // Giới hạn dòng nếu nội dung dài
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Hiển thị danh sách ảnh
            if (requestData['images'] != null &&
                requestData['images'] is List<dynamic> &&
                requestData['images'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: requestData['images'].map<Widget>((imageBase64) {
                    return GestureDetector(
                      onTap: () => _showFullImage(context, imageBase64),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          base64Decode(imageBase64),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Hiển thị trạng thái của yêu cầu
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Trạng thái: ${requestData['status']}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            if (requestData['status'] == 'In Progress' ||
                requestData['status'] == 'Resolved') ...[
              const SizedBox(height: 8),
              const Divider(),
              Text(
                'Nhân viên xử lý:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Tên: ${requestData['assignedTo']['name']}'),
              Text(
                  'Số điện thoại: ${requestData['assignedTo']['phoneNumber']}'),
            ],
          ],
        ),
      ),
    );
  }
}
