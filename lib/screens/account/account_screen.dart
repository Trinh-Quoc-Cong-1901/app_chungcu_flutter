import 'package:ecogreen_city/screens/account/my_address_screen.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/notification/notification_screen.dart';
import 'package:ecogreen_city/screens/utilities/utilities_screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 0; // Bắt đầu từ mục Tài khoản

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
        return const AccountScreen(); // Thông báo

      default:
        return const AccountScreen(); // Tài khoản
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
          // Thông tin cá nhân
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/home_id_logo.png'), // Thay bằng ảnh đại diện của bạn
            ),
            title: const Text('Trịnh Như Quỳnh'),
            subtitle: const Text('0971793348'),
            onTap: () {},
          ),
          const Divider(), // Dòng phân cách

          // Địa chỉ của tôi
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

          // Đơn dịch vụ tiện ích
          ListTile(
            leading:const Icon(Icons.receipt_long, color: Colors.orange),
            title: const Text('Đơn dịch vụ tiện ích'),
            subtitle: const Text('Các đơn dịch vụ tiện ích bạn đã đặt từ bên ngoài'),
            onTap: () {
              
            },
          ),

          // Đơn hàng của tôi
          ListTile(
            leading: const  Icon(Icons.shopping_cart, color: Colors.blue),
            title: const Text('Đơn hàng của tôi'),
            subtitle: const Text('Các đơn hàng bạn đã đặt tới các Cửa hàng tòa nhà'),
            onTap: () {
              
            },
          ),

          // Về chúng tôi
          ListTile(
            leading: const Icon(Icons.info, color: Colors.purple),
            title: const Text('Về chúng tôi'),
            subtitle:const  Text('Giới thiệu về chúng tôi'),
            onTap: () {
              
            },
          ),

          // Điều khoản sử dụng
          ListTile(
            leading: const  Icon(Icons.rule, color: Colors.green),
            title: const Text('Điều khoản sử dụng'),
            subtitle: const Text('Điều khoản sử dụng App'),
            onTap: () {
              
            },
          ),

          // Chính sách riêng tư
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.orange),
            title:const Text('Chính sách riêng tư'),
            subtitle: const Text('Chính sách riêng tư'),
            onTap: () {
              
            },
          ),

          // Thông tin ứng dụng
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text('Thông tin ứng dụng'),
            subtitle: const Text('© HomeID - Phiên bản: 1.1.6-b12.2.19'),
            onTap: () {
              
            },
          ),

          // Thông tin về công ty
          const Padding(
            padding:  EdgeInsets.all(16.0),
            child: Text(
              'Công ty CP Phần mềm và Dịch vụ gia đình HomeID\nGPKD: 0110007865 do sở KH&ĐT TP Hà Nội cấp ngày 24/05/2022.\nMST: 0110007865',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Chỉ số hiện tại của màn hình được chọn
        onTap: _onItemTapped, // Gọi hàm khi người dùng nhấn vào tab
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
