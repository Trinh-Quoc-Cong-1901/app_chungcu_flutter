import 'dart:convert'; // Để sử dụng jsonDecode
import 'package:ecogreen_city/screens/account/account_screen.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/notification/component/notification_item_widget.dart';
import 'package:ecogreen_city/screens/utilities/utilities_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle; // Để load tệp JSON từ assets
import 'notification_detail_screen.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Xử lý chuyển đổi các tab trong BottomNavigationBar
    setState(() {
      _selectedIndex = index;
      // Ở đây bạn có thể điều hướng tới các trang khác, ví dụ như Trang chủ, Tiện ích, Thông báo
      if (_selectedIndex != 4) {
        // Điều hướng tới các trang khác ngoài Tài khoản
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => getScreenForIndex(index)),
        );
      }
    });
  }

  // Hàm này trả về màn hình phù hợp với chỉ số được chọn
  Widget getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen(); // Trang chủ của tôi
      case 1:
        return UtilitiesScreen(); // Tiện ích
      case 2:
        return NotificationListScreen(); // Thông báo
      case 3:
        return AccountScreen(); // Thông báo

      default:
        return NotificationListScreen(); // Tài khoản
    }
  }

  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    // Đọc tệp JSON từ assets
    final String response =
        await rootBundle.loadString('assets/json/notifications.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      notifications = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo mới'),
      ),
      body: notifications.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailScreen(
                          title: notification['title'],
                          time: notification['time'],
                          content: notification['content'],
                        ),
                      ),
                    );
                  },
                  child: NotificationItemWidget(
                    imageUrl: notification['imageUrl'],
                    title: notification['title'],
                    timeAgo: notification['timeAgo'],
                    sender: notification['sender'],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Chỉ số hiện tại của màn hình được chọn
        onTap: _onItemTapped, // Gọi hàm khi người dùng nhấn vào tab
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Nhà của tôi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Tiện ích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
