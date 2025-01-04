// ignore_for_file: avoid_print

import 'package:ecogreen_city/screens/home/components/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:ecogreen_city/services/data_service.dart';
import 'package:ecogreen_city/screens/account/account_screen.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/stores/stores_screen.dart';

import 'notification_detail_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final DataService _dataService = DataService();
  var _selectedIndex = 2;
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final data = await _dataService.loadNotifications(); // Gọi từ DataService
      setState(() {
        notifications = data;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải thông báo.')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex != 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => getScreenForIndex(index)),
        );
      }
    });
  }

  Widget getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const StoresScreen();
      case 3:
        return const AccountScreen();
      default:
        return const NotificationListScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo mới'),
        backgroundColor: Colors.green,
      ),
      body: notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
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
                          time: notification[
                              'createdAt'], // Dùng createdAt từ JSON
                          content:
                              'Thông tin chi tiết liên quan.', // Tuỳ chỉnh nội dung
                        ),
                      ),
                    );
                  },
                  child: NotificationCardWidget(
                    title: notification['title'],
                    createdAt: notification['createdAt'],
                    isRead: notification['isRead'],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
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

  // ignore: unused_element
  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
