import 'package:flutter/material.dart';

class FamilyScreen extends StatefulWidget {
  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<Map<String, String>> members = [
    {
      'name': 'Trịnh Như Quỳnh (Bạn)',
      'role': 'Chủ hộ',
      'phone': '0971793348',
      'image': 'assets/images/icon_facebook.png',
    },
    {
      'name': 'Trịnh Quốc Công',
      'role': 'Thành viên',
      'phone': '0392921501',
      'image': 'assets/images/icon_facebook.png',
    },
  ];

  void _addMember(String name, String role, String phone) {
    setState(() {
      members.add({
        'name': name,
        'role': role,
        'phone': phone,
        'image':
            'assets/images/icon_facebook.png', // Đường dẫn ảnh của thành viên
      });
    });
  }

  void _showAddMemberDialog() {
    final _nameController = TextEditingController();
    final _roleController = TextEditingController();
    final _phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm thành viên mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Vai trò'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Điện thoại'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _addMember(
                  _nameController.text,
                  _roleController.text,
                  _phoneController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Thêm'),
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
        title: Text('Danh sách thành viên'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.asset(
                      member['image']!,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(member['name']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: member['role'] == 'Chủ hộ'
                                    ? Colors.red
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                member['role']!,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text('Điện thoại: ${member['phone']}'),
                      ],
                    ),
                    trailing: member['role'] != 'Chủ hộ'
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                members.removeAt(index);
                              });
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddMemberDialog, // Mở dialog để thêm thành viên
              icon: Icon(Icons.person_add),
              label: Text('THÊM THÀNH VIÊN'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
