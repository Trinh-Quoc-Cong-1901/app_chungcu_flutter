
import 'dart:convert';
import 'package:ecogreen_city/screens/utilities/detail_utilities_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  var _selectedIndex = 1;
  List<dynamic> stores = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadStores(); // Tải dữ liệu cửa hàng từ API
  }

  Future<void> _loadStores() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/stores/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          stores = data;
        });
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      // Xử lý lỗi
      if (kDebugMode) {
        print('Error fetching stores: $e');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách cửa hàng.')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index != 1) {
      // Điều hướng nếu không phải tab hiện tại
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => getScreenForIndex(index)),
      );
    }
  }

  Widget getScreenForIndex(int index) {
    // Logic chuyển đổi màn hình
    return const UtilitiesScreen();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: stores.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: filteredStores.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.brown,
                  thickness: 1.0,
                ),
                itemBuilder: (context, index) {
                  final store = filteredStores[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailUtilities(
                              
                              ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.store,
                        color: Colors.green,
                      ),
                      title: Text(store['name'] ?? 'Không có tên'),
                      subtitle: Text(store['address'] ?? 'Không có địa chỉ'),
                      trailing: const Icon(Icons.arrow_forward_ios),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Nhà của tôi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Tiện ích'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
