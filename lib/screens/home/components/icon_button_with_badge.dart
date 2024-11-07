import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget destination; // Widget đích
  final int badgeCount; // Số lượng thông báo

  const IconButtonWidget({super.key, 
    required this.title,
    required this.icon,
    required this.color,
    required this.destination,
    this.badgeCount = 0, // Mặc định là 0 nếu không có thông báo
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
            if (badgeCount > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
