import 'dart:convert';

import 'package:ecogreen_city/screens/bill/bill_payment_screen.dart';
import 'package:ecogreen_city/screens/home/components/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BillScreen extends StatefulWidget {
  @override
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

  String _getTotalAmount() {
    double total = 0;
    for (var bill in unpaidBills) {
      String amountStr = bill['totalAmount'].replaceAll(RegExp(r'[^0-9]'), '');
      total += double.parse(amountStr);
    }
    return '${total.toStringAsFixed(0)}đ';
  }

  Future<void> _loadBills() async {
    // Đọc tệp JSON từ assets
    final String response =
        await rootBundle.loadString('assets/json/bill_details.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      unpaidBills =
          data.where((bill) => bill['status'] == "Chưa thanh toán").toList();
      paidBills =
          data.where((bill) => bill['status'] == "Thanh toán đủ").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách hóa đơn'),
      ),
      body: unpaidBills.isEmpty && paidBills.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (unpaidBills.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Hóa đơn chưa thanh toán (${unpaidBills.length})',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        Text(
                          'Tổng tiền:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          unpaidBills.isNotEmpty ? _getTotalAmount() : '0đ',
                          style: TextStyle(
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
                          child: Text('Thanh toán'),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
