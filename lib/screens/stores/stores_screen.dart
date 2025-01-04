import 'package:ecogreen_city/screens/account/account_screen.dart';
import 'package:ecogreen_city/screens/home/home_screen.dart';
import 'package:ecogreen_city/screens/notification/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecogreen_city/services/data_service.dart';
import 'detail_store_screen.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  int _selectedIndex = 1; // Bắt đầu từ mục Tài khoản

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex != 4) {
        Navigator.pushReplacement(
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
        return const HomeScreen();
      case 1:
        return const StoresScreen();
      case 2:
        return const NotificationListScreen();
      case 3:
        return const AccountScreen();
      default:
        return const StoresScreen();
    }
  }

  final DataService _dataService = DataService();
  String searchQuery = "";
  List<dynamic> stores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    try {
      final data = await _dataService.loadStores();
      setState(() {
        stores = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách cửa hàng: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredStores = stores.where((store) {
      final title = store['name']?.toLowerCase() ?? '';
      return title.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm cửa hàng',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: filteredStores.isEmpty
                  ? const Center(child: Text('Không có cửa hàng nào.'))
                  : ListView.separated(
                      itemCount: filteredStores.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        final store = filteredStores[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailStoreScreen(store: store),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      store['image'] ??
                                          'https://via.placeholder.com/150',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.store,
                                          size: 80,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          store['name'] ?? 'Không có tên',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          store['description'] ??
                                              'Không có mô tả',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          store['address'] ??
                                              'Không có địa chỉ',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.green,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
