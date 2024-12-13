import 'dart:async';
import 'dart:convert'; // Để sử dụng base64Encode và base64Decode
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatAdminScreen extends StatefulWidget {
  final String userId = "67107548c80418d6c3e38523"; // ID người dùng hiện tại
  final String adminId = "671076f0f8ce7d3257653147"; // ID admin

  const ChatAdminScreen({super.key});

  @override
  _ChatAdminScreenState createState() => _ChatAdminScreenState();
}

class _ChatAdminScreenState extends State<ChatAdminScreen> {
  final List<Map<String, dynamic>> messages = []; // Danh sách tin nhắn
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String lastFetchedMessageId = ""; // Lưu trữ ID tin nhắn cuối cùng
  Timer? _timer;

  // Base URL của API
  final String baseUrl = 'http://localhost:3000/api/chats';

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Lấy tin nhắn khi khởi chạy

    // Thiết lập timer để kiểm tra tin nhắn mới
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchMessages(newMessagesOnly: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi widget bị dispose
    super.dispose();
  }

  Future<void> _fetchMessages({bool newMessagesOnly = false}) async {
    final url = Uri.parse('$baseUrl/${widget.userId}/${widget.adminId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final latestMessageId = data.last['_id'];

          if (!newMessagesOnly || latestMessageId != lastFetchedMessageId) {
            setState(() {
              if (!newMessagesOnly) {
                messages.clear();
              }
              messages.addAll(data.map((message) {
                return {
                  'content': message['message'],
                  'type': message['type'], // Phân biệt text hoặc image
                  'time': DateFormat('h:mm a')
                      .format(DateTime.parse(message['timestamp'])),
                  'date': DateFormat('MMM d, yyyy')
                      .format(DateTime.parse(message['timestamp'])),
                  'sender': message['sender']['_id'], // ID người gửi
                };
              }).toList());
              lastFetchedMessageId =
                  latestMessageId; // Cập nhật ID tin nhắn cuối cùng
            });
          }
        }
      } else {
        print('Failed to load messages');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> _sendMessage(String content, {String type = 'text'}) async {
    if (content.isNotEmpty) {
      final url = Uri.parse(baseUrl);
      final messageData = {
        'sender': widget.userId,
        'receiver': widget.adminId,
        'message': content,
        'type': type, // Phân biệt text hoặc image
      };

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(messageData),
        );

        if (response.statusCode == 201) {
          final now = DateTime.now();
          final newMessage = {
            'content': content,
            'type': type,
            'time': DateFormat('h:mm a').format(now),
            'date': DateFormat('MMM d, yyyy').format(now),
            'sender': widget.userId, // Người gửi là người dùng hiện tại
          };
          setState(() {
            messages.add(newMessage);
          });
          _messageController.clear();
        } else {
          print('Failed to send message');
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      _sendMessage(base64Image, type: 'image'); // Gửi tin nhắn dạng ảnh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat BQL'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                // Phân biệt người gửi và người nhận
                final isSender =
                    message['sender'] == widget.userId; // Người dùng hiện tại

                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (message['type'] == 'text') // Hiển thị văn bản
                          Text(
                            message['content'],
                            style: TextStyle(
                              color: isSender ? Colors.white : Colors.black,
                            ),
                          ),
                        if (message['type'] == 'image') // Hiển thị ảnh
                          Image.memory(
                            base64Decode(message['content']),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 5),
                        Text(
                          message['time'],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
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
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
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
