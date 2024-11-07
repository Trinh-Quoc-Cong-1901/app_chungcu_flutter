import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<Map<String, dynamic>> members = []; // Danh sách thành viên từ API

  @override
  void initState() {
    super.initState();
    _fetchMembers(); // Gọi API để lấy danh sách thành viên
  }

  // Hàm để lấy danh sách thành viên từ API
  Future<void> _fetchMembers() async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/api/users/67107548c80418d6c3e38523'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        members = List<Map<String, dynamic>>.from(data['members']);
      });
    } else {
      // Xử lý khi không tải được dữ liệu
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách thành viên')),
      );
    }
  }

// Hàm để xóa thành viên khỏi cơ sở dữ liệu
  Future<void> _deleteMember(String memberId, int index) async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:3000/api/members/67107548c80418d6c3e38523/$memberId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      setState(() {
        members
            .removeAt(index); // Xóa thành viên khỏi danh sách trong giao diện
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thành viên đã được xóa')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa thành viên')),
      );
    }
  }

  // Hàm để thêm thành viên mới
  Future<void> _addMember(String name, int age, String relation) async {
    final newMember = {
      "name": name,
      "age": age,
      "relation": relation,
    };

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/members/67107548c80418d6c3e38523'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newMember),
    );

    if (response.statusCode == 201) {
      setState(() {
        members.add(newMember); // Cập nhật giao diện với thành viên mới
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thành viên đã được thêm thành công')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thêm thành viên')),
      );
    }
  }

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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
      body: members.isEmpty
          ? const Center(child: Text('Chưa có thành viên'))
          : ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 50),
                    title: Text(member['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tuổi: ${member['age']}'),
                        Text('Quan hệ: ${member['relation']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _deleteMember(member['_id'], index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemberDialog, // Mở dialog để thêm thành viên
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
