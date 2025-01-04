import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;
import 'package:ecogreen_city/services/auth_service.dart';
import 'package:intl/intl.dart';

class BillPaymentScreen extends StatefulWidget {
  final List<dynamic> unpaidBills;
  final List<dynamic> preselectedBills;

  const BillPaymentScreen(
      {super.key, required this.unpaidBills, this.preselectedBills = const []});

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final AuthService _authService = AuthService();
  List<dynamic> selectedBills = [];

  @override
  void initState() {
    super.initState();
    selectedBills = List.from(widget.preselectedBills);
  }

  double _getTotalSelectedAmount() {
    double total = 0;
    for (var bill in selectedBills) {
      String amountStr = bill['totalAmount'].replaceAll(RegExp(r'[^\d.]'), '');
      total += double.parse(amountStr);
    }
    return total;
  }

  Future<void> _updateInvoiceStatus(String invoiceId) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) throw Exception('Token không tồn tại.');

      final response = await http.patch(
        Uri.parse('http://localhost:3000/api/invoices/user/$invoiceId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': 'Đã thanh toán'}),
      );

      if (response.statusCode == 200) {
        log('Hóa đơn $invoiceId đã được cập nhật thành "Đã thanh toán".');
      } else {
        log('Lỗi khi cập nhật hóa đơn $invoiceId: ${response.body}');
      }
    } catch (e) {
      log('Lỗi kết nối khi cập nhật hóa đơn $invoiceId: $e');
    }
  }

  Future<void> _refreshUnpaidBills() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) throw Exception('Token không tồn tại.');

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/invoices/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final allInvoices = jsonDecode(response.body);
        final unpaidInvoices = allInvoices.where((invoice) {
          return invoice['status'] == 'Chưa thanh toán';
        }).toList();

        setState(() {
          widget.unpaidBills.clear();
          widget.unpaidBills.addAll(unpaidInvoices);
        });
      } else {
        log('Lỗi khi làm mới danh sách hóa đơn: ${response.body}');
      }
    } catch (e) {
      log('Lỗi kết nối khi làm mới danh sách hóa đơn: $e');
    }
  }

  void _startPayPalPayment() {
    if (selectedBills.isNotEmpty) {
      double totalAmount = _getTotalSelectedAmount();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId:
              "AT-l0EYJL-UjnI8RsO_ebkRh-XpoTVBSCKGOfR0Q_JqW7O-cGUxxgrgibm8CDFE1eHccolNFWxH-wwAt",
          secretKey:
              "EK0JvKMHz8mRxTgu6TT4XQmZKgpcGt45kTRzS97TxMeVjgn0m1qpZ9bz7SuIvxIlaNGK7wUpvOYRLLjz",
          transactions: [
            {
              "amount": {
                "total": totalAmount.toStringAsFixed(2),
                "currency": "USD",
                "details": {
                  "subtotal": totalAmount.toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "Thanh toán hóa đơn",
              "item_list": {
                "items": selectedBills.map((bill) {
                  return {
                    "name": bill['title'],
                    "quantity": 1,
                    "price":
                        bill['totalAmount'].replaceAll(RegExp(r'[^\d.]'), ''),
                    "currency": "USD"
                  };
                }).toList(),
              }
            }
          ],
          note: "Liên hệ với chúng tôi nếu có thắc mắc về đơn hàng.",
          onSuccess: (Map params) async {
            log("onSuccess: $params");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thanh toán thành công')),
            );

            // Cập nhật trạng thái của từng hóa đơn
            for (var bill in selectedBills) {
              await _updateInvoiceStatus(bill['_id']);
            }

            await _refreshUnpaidBills();

            setState(() {
              selectedBills.clear();
            });

            Navigator.pop(context);
          },
          onError: (error) {
            log("onError: $error");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Có lỗi xảy ra: $error')),
            );
            Navigator.pop(context);
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thanh toán đã bị hủy')),
            );
            Navigator.pop(context);
          },
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán hóa đơn'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.unpaidBills.length,
              itemBuilder: (context, index) {
                var bill = widget.unpaidBills[index];
                bool isSelected = selectedBills.contains(bill);

                return Card(
                  color: isSelected ? Colors.green[50] : Colors.red[50],
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedBills.add(bill);
                          } else {
                            selectedBills.remove(bill);
                          }
                        });
                      },
                    ),
                    title: Text(
                      bill['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${NumberFormat('#,###').format(double.tryParse(bill['totalAmount']) ?? 0)} VND',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng thanh toán:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${NumberFormat('#,###').format(_getTotalSelectedAmount())} VND',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedBills.isEmpty ? null : _startPayPalPayment,
                  child: const Text('TIẾP TỤC'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
