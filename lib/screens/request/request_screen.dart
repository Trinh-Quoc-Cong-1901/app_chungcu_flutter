// ignore_for_file: avoid_print

import 'package:ecogreen_city/screens/request/components/request_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'new_request_screen.dart'; // Đảm bảo import đúng file

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<Map<String, dynamic>> requests = []; // Danh sách lưu trữ các yêu cầu

  @override
  void initState() {
    super.initState();
    _fetchRequests(); // Gọi hàm tải dữ liệu khi màn hình khởi động
  }

  // Hàm để tải dữ liệu từ API
  Future<void> _fetchRequests() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/feedbacks'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        requests = data
            .map((item) => {
                  "title": item["title"],
                  "feedbackType": item["feedbackType"],
                  "priority": item["priority"],
                  "content": item["content"],
                  "image": item["image"],
                  "createdAt": item["createdAt"]
                })
            .toList();
      });
    } else {
      // Xử lý lỗi nếu không tải được dữ liệu
      print("Failed to load feedbacks");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách yêu cầu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu cầu B...'),
      ),
      body: requests.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có yêu cầu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCard(requestData: requests[index]);
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            // Điều hướng sang trang NewRequestScreen và nhận dữ liệu trả về
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewRequestScreen(),
              ),
            );

            // Nếu có dữ liệu trả về, thêm vào danh sách yêu cầu
            if (result != null) {
              setState(() {
                requests.add(result);
              });
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('TẠO YÊU CẦU'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
