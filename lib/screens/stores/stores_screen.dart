import 'package:flutter/material.dart';
import 'detail_store_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
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
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/stores'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          stores = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách cửa hàng.')),
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
                            elevation: 5,
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
                                  Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.green,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
