import 'package:flutter/material.dart';
import 'package:ecogreen_city/services/data_service.dart';
import 'package:ecogreen_city/screens/bill/bill_detail_screen.dart';
import 'package:ecogreen_city/screens/bill/bill_payment_screen.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final DataService _dataService = DataService();
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
      final amount = double.tryParse(
          bill['totalAmount'].replaceAll(RegExp(r'[^\d.]'), ''));
      total += amount ?? 0;
    }
    return '${total.toStringAsFixed(2)} USD';
  }

  Future<void> _loadBills() async {
    try {
      final bills = await _dataService.loadBills();
      setState(() {
        unpaidBills =
            bills.where((bill) => bill['status'] == "Chưa thanh toán").toList();
        paidBills =
            bills.where((bill) => bill['status'] == "Đã thanh toán").toList();
      });
    } catch (e) {
      print('Error loading bills: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải hóa đơn.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách hóa đơn'),
        backgroundColor: Colors.green,
      ),
      body: unpaidBills.isEmpty && paidBills.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Hóa đơn chưa thanh toán
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillDetailScreen(
                              billData: bill,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bill['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Hạn thanh toán: ${bill['paymentDueDate']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${bill['totalAmount']} USD',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                          _getTotalAmount(),
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
                          },
                          child: const Text('Thanh toán'),
                        ),
                      ],
                    ),
                  ),
                ],
                // Hóa đơn đã thanh toán
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillDetailScreen(
                              billData: bill,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bill['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ngày thanh toán: ${bill['paymentDueDate']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${bill['totalAmount']} USD',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}
