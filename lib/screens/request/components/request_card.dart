import 'dart:convert'; // Để sử dụng base64Decode
import 'package:flutter/material.dart';
// Để sử dụng Uint8List

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> requestData; // Dữ liệu yêu cầu

  const RequestCard({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              requestData['title'], // Tiêu đề
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Loại phản ánh: ${requestData['type']}'), // Loại phản ánh
            const SizedBox(height: 8),
            Text(
                'Mức độ ưu tiên: ${requestData['priority']}'), // Mức độ ưu tiên
            const SizedBox(height: 8),
            Text('Nội dung: ${requestData['content']}'), // Nội dung
            if (requestData['image'] != null) // Kiểm tra nếu có ảnh base64
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.memory(
                  base64Decode(
                      requestData['image']), // Chuyển base64 thành hình ảnh
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
