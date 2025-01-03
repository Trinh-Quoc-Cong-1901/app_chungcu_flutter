import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecogreen_city/services/auth_service.dart';
import 'package:http/http.dart' as http;

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final AuthService _authService = AuthService();
  List<dynamic> unpaidBills = [];
  List<dynamic> paidBills = [];

  Future<void> _loadBills() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/invoices/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          unpaidBills = data
              .where((bill) => bill['status'] == "Chưa thanh toán")
              .toList();
          paidBills =
              data.where((bill) => bill['status'] == "Đã thanh toán").toList();
        });
      } else if (response.statusCode == 401) {
        await _authService.refreshToken(); // Làm mới token
        await _loadBills(); // Thử lại
      } else {
        throw Exception('Failed to load invoices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading invoices: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải hóa đơn.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hóa Đơn')),
      body: ListView(
        children: [
          _buildBillSection('Chưa thanh toán', unpaidBills),
          _buildBillSection('Đã thanh toán', paidBills),
        ],
      ),
    );
  }

  Widget _buildBillSection(String title, List<dynamic> bills) {
    return ExpansionTile(
      title: Text(title),
      children: bills.map((bill) {
        return ListTile(
          title: Text('Mã hóa đơn: ${bill['id']}'),
          subtitle: Text('Số tiền: ${bill['amount']} VNĐ'),
          trailing: Text(bill['status']),
        );
      }).toList(),
    );
  }
}
