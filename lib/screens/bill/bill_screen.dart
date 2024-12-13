import 'dart:convert';

import 'package:ecogreen_city/screens/bill/bill_payment_screen.dart';
import 'package:ecogreen_city/screens/home/components/bill_card.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  List<dynamic> unpaidBills = [];
  List<dynamic> paidBills = [];

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  // String _getTotalAmount() {
  //   double total = 0;
  //   for (var bill in unpaidBills) {
  //     String amountStr = bill['totalAmount'].replaceAll(RegExp(r'[^0-9]'), '');
  //     total += double.parse(amountStr);
  //   }
  //   return '${total.toStringAsFixed(0)}đ';
  // }
  String _getTotalAmount() {
    double total = 0;
    for (var bill in unpaidBills) {
      // Lấy chuỗi số tiền và giữ lại phần thập phân
      String amountStr = bill['totalAmount'].replaceAll(RegExp(r'[^\d.]'), '');
      // Chuyển đổi chuỗi thành double và cộng dồn vào tổng
      total += double.tryParse(amountStr) ?? 0;
    }
    // Trả về kết quả định dạng 2 chữ số thập phân
    return '${total.toStringAsFixed(2)} USD';
  }

  Future<void> _loadBills() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/invoices'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        unpaidBills =
            data.where((bill) => bill['status'] == "Chưa thanh toán").toList();
        paidBills =
            data.where((bill) => bill['status'] == "Đã thanh toán").toList();
      });
    } else {
      // Xử lý lỗi nếu cần
      throw Exception('Failed to load invoices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách hóa đơn'),
      ),
      body: unpaidBills.isEmpty && paidBills.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (unpaidBills.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Hóa đơn chưa thanh toán (${unpaidBills.length})',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (var bill in unpaidBills)
                    BillCardWidget(
                      title: bill['title'],
                      totalAmount: bill['totalAmount'],
                      paymentPeriod: bill['paymentPeriod'],
                      isPaid: bill['isPaid'],
                      billData: bill,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng tiền:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          unpaidBills.isNotEmpty ? _getTotalAmount() : '0USD',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BillPaymentScreen(
                                  unpaidBills: unpaidBills,
                                ),
                              ),
                            );
                            // Xử lý thanh toán ở đây
                          },
                          child: const Text('Thanh toán'),
                        ),
                      ],
                    ),
                  ),
                ],
                if (paidBills.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Hóa đơn đã thanh toán (${paidBills.length})',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (var bill in paidBills)
                    BillCardWidget(
                      title: bill['title'],
                      totalAmount: bill['totalAmount'],
                      paymentPeriod: bill['paymentPeriod'],
                      isPaid: bill['isPaid'],
                      billData: bill,
                    ),
                ],
              ],
            ),
    );
  }
}
