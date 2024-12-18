// ignore_for_file: avoid_print

import 'dart:convert'; // Để sử dụng jsonDecode
import 'package:ecogreen_city/screens/account/account_screen.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/notification/component/notification_item_widget.dart';
import 'package:ecogreen_city/screens/stores/stores_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'notification_detail_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  var _selectedIndex = 0;
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/notifications/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          notifications = data;
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải thông báo.')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex != 4) {
        Navigator.push(
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
      case 2:
        return const NotificationListScreen();
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
}
