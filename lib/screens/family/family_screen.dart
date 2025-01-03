import 'package:flutter/material.dart';
import 'package:ecogreen_city/services/data_service.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final DataService _dataService = DataService();
  Map<String, dynamic>? userData; // Dữ liệu chủ hộ
  List<dynamic> members = []; // Danh sách thành viên
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load dữ liệu từ API
  Future<void> _loadUserData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await _dataService.fetchUserData();
      setState(() {
        userData = data;
        members = data['members'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải dữ liệu: $e')),
      );
    }
  }

  // Thêm thành viên mới
  Future<void> _addMember(String name, int age, String relation) async {
    try {
      await _dataService.addMember(name, age, relation);
      await _loadUserData(); // Cập nhật danh sách
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thành viên đã được thêm.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể thêm thành viên: $e')),
      );
    }
  }

  // Xóa thành viên
  Future<void> _deleteMember(String memberId) async {
    try {
      await _dataService.deleteMember(memberId);
      await _loadUserData(); // Cập nhật danh sách
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thành viên đã được xóa.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa thành viên: $e')),
      );
    }
  }

  // Dialog thêm thành viên
  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final relationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm thành viên mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Tuổi'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(labelText: 'Quan hệ'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final age = int.tryParse(ageController.text) ?? 0;
                final relation = relationController.text;
                _addMember(name, age, relation);
                Navigator.of(context).pop();
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách thành viên'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('Không thể tải dữ liệu chủ hộ.'))
              : Column(
                  children: [
                    // Thông tin chủ hộ
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.home, size: 40),
                          title: Text(userData?['name'] ?? 'Không rõ'),
                          subtitle: Text('Chủ hộ'),
                        ),
                      ),
                    ),
                    // Danh sách thành viên
                    Expanded(
                      child: members.isEmpty
                          ? const Center(child: Text('Chưa có thành viên.'))
                          : ListView.builder(
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                final member = members[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: ListTile(
                                    leading: const Icon(Icons.person, size: 50),
                                    title: Text(member['name']),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Tuổi: ${member['age']}'),
                                        Text('Quan hệ: ${member['relation']}'),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _deleteMember(member['_id']),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemberDialog, // Mở dialog thêm thành viên
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
