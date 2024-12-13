import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class BillPaymentScreen extends StatefulWidget {
  final List<dynamic> unpaidBills;
  final List<dynamic> preselectedBills;

  const BillPaymentScreen(
      {super.key, required this.unpaidBills, this.preselectedBills = const []});

  @override
  // ignore: library_private_types_in_public_api
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  List<dynamic> selectedBills = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo selectedBills với các hóa đơn đã chọn trước
    selectedBills = List.from(widget.preselectedBills);
  }

  double _getTotalSelectedAmount() {
    double total = 0;
    for (var bill in selectedBills) {
      String amountStr = bill['totalAmount'].replaceAll(RegExp(r'[^0-9]'), '');
      total += double.parse(amountStr);
    }
    return total;
  }

  void _startPayPalPayment() {
    if (selectedBills.isNotEmpty) {
      double totalAmount = _getTotalSelectedAmount();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true, // Đổi thành false khi triển khai thực tế
          clientId:
              "AT-l0EYJL-UjnI8RsO_ebkRh-XpoTVBSCKGOfR0Q_JqW7O-cGUxxgrgibm8CDFE1eHccolNFWxH-wwAt", // Thay thế bằng Client ID từ PayPal Developer
          secretKey:
              "EK0JvKMHz8mRxTgu6TT4XQmZKgpcGt45kTRzS97TxMeVjgn0m1qpZ9bz7SuIvxIlaNGK7wUpvOYRLLjz", // Thay thế bằng Secret Key từ PayPal Developer
          transactions: [
            {
              "amount": {
                "total": totalAmount.toStringAsFixed(2),
                "currency": "USD", // Thay đổi thành tiền tệ bạn cần
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
                        bill['totalAmount'].replaceAll(RegExp(r'[^0-9]'), ''),
                    "currency": "USD" // Thay đổi thành tiền tệ bạn cần
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
            setState(() {
              selectedBills
                  .clear(); // Xóa danh sách hóa đơn đã chọn sau khi thanh toán
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
            // print('Thanh toán bị hủy.');
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
                    subtitle: Text('Kỳ ${bill['paymentPeriod']}'),
                    trailing: Text(
                      bill['totalAmount'],
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
                  '${_getTotalSelectedAmount().toStringAsFixed(0)}đ',
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
