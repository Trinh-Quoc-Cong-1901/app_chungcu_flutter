import 'package:flutter/material.dart';

class BillPaymentScreen extends StatefulWidget {
  final List<dynamic> unpaidBills;

  BillPaymentScreen({required this.unpaidBills});

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  List<dynamic> selectedBills = [];

  double _getTotalSelectedAmount() {
    double total = 0;
    for (var bill in selectedBills) {
      String amountStr = bill['totalAmount'].replaceAll(RegExp(r'[^0-9]'), '');
      total += double.parse(amountStr);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán hóa đơn'),
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Kỳ ${bill['paymentPeriod']}'),
                    trailing: Text(
                      bill['totalAmount'],
                      style: TextStyle(
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
                Text(
                  'Tổng thanh toán:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_getTotalSelectedAmount().toStringAsFixed(0)}đ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedBills.isEmpty
                      ? null
                      : () {
                          // Xử lý thanh toán cho các hóa đơn đã chọn ở đây
                        },
                  child: Text('TIẾP TỤC'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
