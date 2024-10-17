import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget destination; // Widget đích

  IconButtonWidget({
    required this.title,
    required this.icon,
    required this.color,
    required this.destination, // Nhận widget đích khi khởi tạo
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          destination), // Chuyển đến màn hình đích
                );
              },
              icon: Icon(icon, color: color),
            ),
            if (title == 'Hóa đơn')
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
