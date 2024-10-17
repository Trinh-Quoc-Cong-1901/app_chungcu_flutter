import 'dart:io';

import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> requestData; // Dữ liệu yêu cầu

  RequestCard({required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              requestData['title'], // Tiêu đề
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Loại phản ánh: ${requestData['type']}'), // Loại phản ánh
            SizedBox(height: 8),
            Text(
                'Mức độ ưu tiên: ${requestData['priority']}'), // Mức độ ưu tiên
            SizedBox(height: 8),
            Text('Nội dung: ${requestData['content']}'), // Nội dung
            if (requestData['image'] != null) // Kiểm tra nếu có ảnh
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.file(
                  File(requestData['image'].path), // Hiển thị ảnh
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
