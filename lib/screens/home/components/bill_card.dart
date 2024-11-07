import 'package:ecogreen_city/screens/bill/bill_detail_screen.dart';
import 'package:flutter/material.dart';

class BillCardWidget extends StatelessWidget {
  final String title;
  final String totalAmount;
  final String paymentPeriod;
  final bool? isPaid; // Biến kiểm tra trạng thái thanh toán
  final Map<String, dynamic> billData;

  const BillCardWidget({super.key, 
    required this.title,
    required this.totalAmount,
    required this.paymentPeriod,
    this.isPaid,
    required this.billData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Điều hướng tới màn hình chi tiết hóa đơn khi nhấn vào
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillDetailScreen(
              billData: billData,
            ),
          ),
        );
      },
      child: Card(
        // Đổi màu nền dựa vào trạng thái thanh toán
        color: (isPaid == true) ? Colors.blue[100] : Colors.red[50],

        // Màu nền cho hóa đơn chưa thanh toán
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bo góc cho Card
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Thêm khoảng cách padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nội dung
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2, // Giới hạn số dòng cho tiêu đề
                overflow:
                    TextOverflow.ellipsis, // Thêm dấu ba chấm khi vượt quá dòng
              ),
              const SizedBox(height: 4), // Khoảng cách giữa tiêu đề và chi tiết
              const Text(
                'Vui lòng kiểm tra chi tiết hóa đơn',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8), // Khoảng cách giữa văn bản và kỳ tháng

              // Kỳ thanh toán và giá tiền
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kỳ $paymentPeriod',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    totalAmount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Màu của giá tiền
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
