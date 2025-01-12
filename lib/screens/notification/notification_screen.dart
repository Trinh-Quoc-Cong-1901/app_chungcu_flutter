import 'package:ecogreen_city/screens/account/order_detail_screen.dart';
import 'package:ecogreen_city/screens/bill/bill_detail_screen.dart';
import 'package:ecogreen_city/screens/request/request_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecogreen_city/services/data_service.dart';
import 'package:ecogreen_city/screens/account/account_screen.dart';
import 'package:ecogreen_city/screens/home/components/notification_card.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/stores/stores_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final DataService _dataService = DataService();
  var _selectedIndex = 2;
  List<dynamic> notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  /// Hàm tải danh sách thông báo
  Future<void> _loadNotifications() async {
    try {
      final data = await _dataService.loadNotifications();
      setState(() {
        notifications = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải thông báo.')),
      );
    }
  }

  /// Hàm cập nhật trạng thái thông báo
  Future<void> _markAsRead(String notificationId) async {
    try {
      await _dataService.markNotificationAsRead(notificationId);
      setState(() {
        final notification = notifications
            .firstWhere((n) => n['_id'] == notificationId, orElse: () => null);
        if (notification != null) {
          notification['isRead'] = true;
        }
      });
    } catch (e) {
      print('Error updating notification status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Không thể cập nhật trạng thái thông báo.')),
      );
    }
  }

  void _navigateToDetail(String type, String relatedId) async {
    print("Type: $type");
    try {
      if (type == 'invoice') {
        // Lấy chi tiết hóa đơn
        final billData = await _dataService.getInvoiceDetails(relatedId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillDetailScreen(
              billData: billData,
            ),
          ),
        );
      } else if (type == 'order') {
        final orderData = await _dataService.getOrderDetails(relatedId);
        if (orderData == null) {
          throw Exception('Dữ liệu đơn hàng không tồn tại.');
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              orderData: orderData,
            ),
          ),
        );
      } else if (type == 'feedback') {
        // Xử lý chi tiết phản hồi
        final requestData = await _dataService.getRequestDetails(relatedId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestDetailScreen(
              requestData: requestData,
            ),
          ),
        );
      } else {
        // Thông báo nếu loại không được hỗ trợ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loại thông báo không được hỗ trợ.')),
        );
      }
    } catch (e) {
      print('Error navigating to detail: $e');
      // Thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải chi tiết.')),
      );
    }
  }

  /// Xử lý khi chọn mục trong BottomNavigationBar
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

  /// Lấy màn hình tương ứng với BottomNavigationBar
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text('Không có thông báo.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return GestureDetector(
                      onTap: () async {
                        print("on tap");
                        await _markAsRead(notification['_id']);
                        _navigateToDetail(
                          notification['type'],
                          notification['relatedId'],
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
}
