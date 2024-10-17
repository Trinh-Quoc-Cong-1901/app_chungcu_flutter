import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecogreen_city/screens/account/account_screen.dart';
import 'package:ecogreen_city/screens/bill/bill_detail_screen.dart';
import 'package:ecogreen_city/screens/bill/bill_payment_screen.dart';
import 'package:ecogreen_city/screens/bill/bill_screen.dart';
import 'package:ecogreen_city/screens/chat_admin/chat_admin_screen.dart';
import 'package:ecogreen_city/screens/community/community_screen.dart';
import 'package:ecogreen_city/screens/family/family_screen.dart';
import 'package:ecogreen_city/screens/home/components/bill_card.dart';
// import 'package:ecogreen_city/screens/home/components/bill_card.dart';
import 'package:ecogreen_city/screens/home/components/business_card.dart';
import 'package:ecogreen_city/screens/home/components/community_board.dart';
import 'package:ecogreen_city/screens/home/components/icon_button_with_badge.dart';
import 'package:ecogreen_city/screens/home/components/notification_card.dart';
import 'package:ecogreen_city/screens/home/components/section_header.dart';
import 'package:ecogreen_city/screens/hot_line/hot_line_screen.dart';
import 'package:ecogreen_city/screens/notification/notification_detail_screen.dart';
import 'package:ecogreen_city/screens/notification/notification_screen.dart';
import 'package:ecogreen_city/screens/request/request_screen.dart';
import 'package:ecogreen_city/screens/utilities/utilities_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        return AccountScreen(); // Thông báo

      default:
        return HomeScreen(); // Tài khoản
    }
  }

  List<dynamic> notifications = [];
  List<dynamic> bills = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _loadBills();
  }

  String _getTotalAmount() {
    double total = 0;
    for (var bill in bills) {
      String amountStr = bill['totalAmount'].replaceAll(RegExp(r'[^0-9]'), '');
      total += double.parse(amountStr);
    }
    return '${total.toStringAsFixed(0)}đ';
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

  Future<void> _loadBills() async {
    // Đọc tệp JSON từ assets
    final String response =
        await rootBundle.loadString('assets/json/bill_details.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      bills =
          data.where((bill) => bill['status'] == "Chưa thanh toán").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20, // Kích thước avatar
              backgroundImage: AssetImage(
                  'assets/images/avata.png'), // Thay thế bằng đường dẫn tới ảnh avatar của bạn
            ),
            SizedBox(width: 10), // Khoảng cách giữa avatar và thông tin
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trịnh Như Quỳnh',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  'CT4.12A10, Eco Green City',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                Text(
                  'Nguyễn Xiển, Thanh Xuân, Hà Nội',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () {
              // Reload lại trang hiện tại
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Các nút phía dưới hình ảnh
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButtonWidget(
                    title: 'Hóa đơn',
                    icon: Icons.receipt_long,
                    color: Colors.orange,
                    destination: BillScreen(), // Thay thế bằng màn hình Hóa đơn
                  ),
                  IconButtonWidget(
                    title: 'Yêu cầu',
                    icon: Icons.assignment,
                    color: Colors.green,
                    destination:
                        RequestScreen(), // Thay thế bằng màn hình Yêu cầu
                  ),
                  IconButtonWidget(
                    title: 'Chat BQL',
                    icon: Icons.chat,
                    color: Colors.green,
                    destination:
                        ChatAdminScreen(), // Thay thế bằng màn hình Chat BQL
                  ),
                  IconButtonWidget(
                    title: 'Cộng đồng',
                    icon: Icons.groups,
                    color: Colors.green,
                    destination:
                        CommunityScreen(), // Thay thế bằng màn hình Cộng đồng
                  ),
                  IconButtonWidget(
                    title: 'Gia đình',
                    icon: Icons.family_restroom,
                    color: Colors.green,
                    destination:
                        FamilyScreen(), // Thay thế bằng màn hình Gia đình
                  ),
                  IconButtonWidget(
                    title: 'Hotline',
                    icon: Icons.phone,
                    color: Colors.green,
                    destination:
                        HotlineScreen(), // Thay thế bằng màn hình Hotline
                  ),
                ],
              ),
            ),
            // thông báo mới
            Column(
              children: [
                // Header với tiêu đề và nút "Xem tất cả"
                SectionHeaderWidget(
                  title: 'Thông báo mới',
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationListScreen()),
                    );
                  },
                ),
                SizedBox(height: 16.0),
                // Kiểm tra nếu chưa load được thông báo
                notifications.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: 120.0, // Chiều cao của slider
                          autoPlay: false, // Tự động chuyển
                          enlargeCenterPage:
                              false, // Không phóng to item ở giữa
                          enableInfiniteScroll: false, // Vô hạn scroll
                          viewportFraction: 0.8, // Điều chỉnh kích thước item
                        ),
                        items: notifications.map((notification) {
                          return GestureDetector(
                            onTap: () {
                              // Điều hướng đến màn hình chi tiết khi ấn vào
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationDetailScreen(
                                    title: notification['title'],
                                    time: notification['time'],
                                    content: notification['content'],
                                  ),
                                ),
                              );
                            },
                            child: NotificationCardWidget(
                              imageUrl: notification['imageUrl'],
                              title: notification['title'],
                              timeAgo: notification['timeAgo'],
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
            // hoá đơn
            Column(
              children: [
                SectionHeaderWidget(
                  title: 'Hoá đơn chưa thanh toán',
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BillScreen()),
                    );
                  },
                ),
                bills.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: 170, // Chiều cao của slider
                          autoPlay: false, // Tự động chuyển
                          enlargeCenterPage:
                              false, // Không phóng to item ở giữa
                          enableInfiniteScroll: false, // Vô hạn scroll
                          viewportFraction: 0.9, // Điều chỉnh kích thước item
                        ),
                        items: bills.map((bill) {
                          return GestureDetector(
                            onTap: () {
                              // Điều hướng đến màn hình chi tiết hóa đơn
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BillDetailScreen(
                                    billData: bill,
                                  ),
                                ),
                              );
                            },
                            child: BillCardWidget(
                              title: bill['title'],
                              paymentPeriod: bill['paymentPeriod'],
                              totalAmount: bill['totalAmount'],
                              billData: bill,
                            ),
                          );
                        }).toList(),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        bills.isNotEmpty ? _getTotalAmount() : '0đ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý thanh toán ở đây

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillPaymentScreen(
                                unpaidBills: bills,
                              ),
                            ),
                          );
                        },
                        child: Text('Thanh toán'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Column(
              children: [
                SectionHeaderWidget(
                    title: 'BẢNG TIN TOÀ NHÀ', onViewAll: () {}),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 160.0, // Chiều cao của slider
                    autoPlay: false, // Tự động chuyển
                    enlargeCenterPage: false, // Không phóng to item ở giữa
                    enableInfiniteScroll: false, // Vô hạn scroll
                    viewportFraction: 0.8, // Điều chỉnh kích thước item
                  ),
                  items: List.generate(
                    5,
                    (index) => CommunityBoardWidget(),
                  ), // Thay thế bằng item của bạn
                ),
              ],
            ),
            Column(
              children: [
                SectionHeaderWidget(title: 'Kiot toà nhà', onViewAll: () {}),
                CarouselSlider(
                  options: CarouselOptions(
                    // height: 160.0, // Chiều cao của slider
                    autoPlay: false, // Tự động chuyển
                    enlargeCenterPage: false, // Không phóng to item ở giữa
                    enableInfiniteScroll: false, // Vô hạn scroll
                    viewportFraction: 0.8, // Điều chỉnh kích thước item
                  ),
                  items: List.generate(
                    5,
                    (index) => BusinessCardWidget(
                      title: 'Máy lọc nước Kasama',
                      subtitle: 'Chuyên Giao Lọc Nước',
                      address: 'Số 164 Nam Đường Q. Long Biên, TP Hà Nội',
                      imagePath:
                          'assets/images/icon_facebook.png', // Đường dẫn đến ảnh sản phẩm
                    ),
                  ), // Thay thế bằng item của bạn
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Chỉ số hiện tại của màn hình được chọn
        onTap: _onItemTapped, // Gọi hàm khi người dùng nhấn vào tab
        // backgroundColor:
        //     Colors.green, // Màu nền chung cho toàn bộ BottomNavigationBar
        // selectedItemColor: Colors.white, // Màu cho item được chọn
        // unselectedItemColor: Colors.black54, // Màu cho các item không được chọn
        // type:
        //     BottomNavigationBarType.fixed, // Đảm bảo các item hiển thị đều nhau

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
