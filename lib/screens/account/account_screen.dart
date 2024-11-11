import 'dart:convert';
import 'package:ecogreen_city/screens/sign/sign_screen.dart';
import 'package:http/http.dart' as http;
import 'package:ecogreen_city/screens/account/my_address_screen.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/notification/notification_screen.dart';
import 'package:ecogreen_city/screens/utilities/utilities_screen.dart';

import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 0; // Bắt đầu từ mục Tài khoản

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

  // Hàm này trả về màn hình phù hợp với chỉ số được chọn
  Widget getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return UtilitiesScreen();
      case 2:
        return NotificationListScreen();
      case 3:
        return const AccountScreen();
      default:
        return const AccountScreen();
    }
  }

  // Hàm gọi API logout
  Future<void> _logout() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/api/token/logout'), // Thay URL bằng URL của API thực tế
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken':
              'YOUR_REFRESH_TOKEN' // Thay bằng refresh token thực tế
        }),
      );

      if (response.statusCode == 200) {
        // Nếu đăng xuất thành công, điều hướng về SignInScreen và xóa tất cả lịch sử điều hướng
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (Route<dynamic> route) => false, // Xóa toàn bộ các route trước đó
        );
      } else {
        // Xử lý lỗi từ API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng xuất thất bại. Vui lòng thử lại.')),
        );
      }
    } catch (error) {
      // Hiển thị lỗi mạng hoặc lỗi khác
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại sau.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/home_id_logo.png'),
            ),
            title: const Text('Trịnh Như Quỳnh'),
            subtitle: const Text('0971793348'),
            onTap: () {},
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.orange),
            title: const Text('Địa chỉ của tôi'),
            subtitle: const Text('Quản lý địa chỉ nhận hàng'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAddressScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.orange),
            title: const Text('Đơn dịch vụ tiện ích'),
            subtitle:
                const Text('Các đơn dịch vụ tiện ích bạn đã đặt từ bên ngoài'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.blue),
            title: const Text('Đơn hàng của tôi'),
            subtitle:
                const Text('Các đơn hàng bạn đã đặt tới các Cửa hàng tòa nhà'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.info, color: Colors.purple),
            title: const Text('Về chúng tôi'),
            subtitle: const Text('Giới thiệu về chúng tôi'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.rule, color: Colors.green),
            title: const Text('Điều khoản sử dụng'),
            subtitle: const Text('Điều khoản sử dụng App'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.orange),
            title: const Text('Chính sách riêng tư'),
            subtitle: const Text('Chính sách riêng tư'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text('Thông tin ứng dụng'),
            subtitle: const Text('© HomeID - Phiên bản: 1.1.6-b12.2.19'),
            onTap: () {},
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Công ty CP Phần mềm và Dịch vụ gia đình HomeID\nGPKD: 0110007865 do sở KH&ĐT TP Hà Nội cấp ngày 24/05/2022.\nMST: 0110007865',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          // Nút đăng xuất
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Đăng xuất'),
            onTap: _logout,
          ),
        ],
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
