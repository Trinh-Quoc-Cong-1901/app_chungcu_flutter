import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Đảm bảo bạn đã thêm package intl vào pubspec.yaml
import 'package:image_picker/image_picker.dart'; // Thêm thư viện image_picker

class ChatAdminScreen extends StatefulWidget {
  @override
  _ChatAdminScreenState createState() => _ChatAdminScreenState();
}

class _ChatAdminScreenState extends State<ChatAdminScreen> {
  final List<Map<String, dynamic>> messages = []; // Danh sách lưu trữ tin nhắn
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // Khởi tạo ImagePicker

  void _sendMessage(String content, {String? type}) {
    if (content.isNotEmpty) {
      final now = DateTime.now(); // Lấy thời gian hiện tại
      final time = DateFormat('h:mm a').format(now); // Định dạng thời gian
      final date = DateFormat('MMM d, yyyy').format(now); // Định dạng ngày

      setState(() {
        messages.add({
          'content': content,
          'type': type ?? 'text', // Hoặc 'image' nếu là tin nhắn hình ảnh
          'time': time,
          'date': date,
        });
        _messageController.clear(); // Xóa nội dung sau khi gửi
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMessage(pickedFile.path, type: 'image'); // Gửi tin nhắn hình ảnh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Admin'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: message['type'] == 'text'
                          ? Colors.blue
                          : Colors.white70,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (message['type'] == 'text')
                          Text(
                            message['content'],
                            style: TextStyle(color: Colors.white),
                          ),
                        if (message['type'] == 'image')
                          Image.asset(
                            message[
                                'content'], // Dùng đường dẫn hình ảnh từ tin nhắn
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 5),
                        Text(
                          message['time'],
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                prefixIcon: IconButton(
                  icon: Icon(Icons.image), // Biểu tượng hình ảnh
                  onPressed: _pickImage, // Gọi hàm chọn hình ảnh
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send), // Biểu tượng gửi tin nhắn
                  onPressed: () {
                    _sendMessage(
                        _messageController.text); // Gửi tin nhắn văn bản
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
