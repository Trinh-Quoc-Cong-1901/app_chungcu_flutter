import 'package:ecogreen_city/screens/request/components/request_card.dart';
import 'package:ecogreen_city/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestDetailScreen extends StatelessWidget {
  final Map<String, dynamic> requestData;

  RequestDetailScreen({super.key, required this.requestData});
  final AuthService _authService = AuthService();

  Future<void> _updateStatusToResolved(BuildContext context) async {
    final token = await _authService.getAccessToken();
    if (token == null) {
      throw Exception('Access token không tồn tại.');
    }
    final String apiUrl =
        'http://192.168.1.9:3000/api/feedbacks/${requestData['_id']}';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': 'Resolved'}),
      );

      if (response.statusCode == 200) {
        // Cập nhật trạng thái local
        requestData['status'] = 'Resolved';

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trạng thái đã được cập nhật thành "Resolved"!'),
            backgroundColor: Colors.green,
          ),
        );

        // Quay lại màn hình trước (hoặc tải lại dữ liệu)
        Navigator.of(context).pop(true);
      } else {
        // Hiển thị lỗi nếu API trả về không thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật thất bại: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hiển thị lỗi nếu có lỗi khi gọi API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
/*************  ✨ Codeium Command ⭐  *************/
  /// Hiển thị màn hình chi tiết của một yêu cầu.
  ///
  /// Trên màn hình này, ta có thể xem chi tiết của một yêu cầu và
  /// có thể cập nhật trạng thái của yêu cầu thành "Resolved" (hoàn thành).
  ///
  /// [requestData] là dữ liệu của yêu cầu.
  ///
  /// Màn hình này được gọi từ [RequestScreen].
/******  9f395cc2-5889-46a1-8555-bb0cf968bb35  *******/ Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết yêu cầu'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RequestCard(requestData: requestData),

              // Nút hoàn thành nếu trạng thái là "In Progress"
              if (requestData['status'] == 'In Progress')
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _updateStatusToResolved(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text('Đã hoàn thành'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
