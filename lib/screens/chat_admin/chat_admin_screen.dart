// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatAdminScreen extends StatefulWidget {
  final String userId =
      "67107548c80418d6c3e38523"; // User ID for the current user
  final String adminId = "671076f0f8ce7d3257653147"; // Admin ID for the admin

  const ChatAdminScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatAdminScreenState createState() => _ChatAdminScreenState();
}

class _ChatAdminScreenState extends State<ChatAdminScreen> {
  final List<Map<String, dynamic>> messages = []; // List to store messages
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Timer? _timer;

  // Base URL for the API
  final String baseUrl = 'http://localhost:3000/api/chats';

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Fetch initial messages when the screen loads

    // Set up a timer to periodically fetch messages every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    final url = Uri.parse('$baseUrl/${widget.userId}/${widget.adminId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          messages.clear();
          messages.addAll(data
              .map((message) => {
                    'content': message['message'],
                    'type': 'text', // assuming messages are text-only
                    'time': DateFormat('h:mm a')
                        .format(DateTime.parse(message['timestamp'])),
                    'date': DateFormat('MMM d, yyyy')
                        .format(DateTime.parse(message['timestamp'])),
                    'email': message['sender']['email'], // add sender's email
                  })
              .toList());
        });
      } else {
        print('Failed to load messages');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  // Function to send a message to the server
  Future<void> _sendMessage(String content, {String? type}) async {
    if (content.isNotEmpty) {
      final url = Uri.parse(baseUrl);
      final messageData = {
        'sender': widget.userId,
        'receiver': widget.adminId,
        'message': content,
      };

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(messageData),
        );

        if (response.statusCode == 201) {
          final newMessage = jsonDecode(response.body);
          final now = DateTime.now();
          setState(() {
            messages.add({
              'content': newMessage['message'],
              'type': type ?? 'text',
              'time': DateFormat('h:mm a').format(now),
              'date': DateFormat('MMM d, yyyy').format(now),
            });
          });
          _messageController.clear();
        } else {
          // ignore:
          print('Failed to send message');
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  // Function to pick an image and send it as a message
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMessage(pickedFile.path, type: 'image'); // send the image path
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
                final isSenderBob = message['email'] == 'bob.smith@example.com';

                return Align(
                  alignment: isSenderBob
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isSenderBob ? Colors.grey[300] : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: isSenderBob
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        if (message['type'] == 'text')
                          Text(
                            message['content'],
                            style: TextStyle(
                                color:
                                    isSenderBob ? Colors.black : Colors.white),
                          ),
                        if (message['type'] == 'image')
                          Image.file(
                            File(message['content']),
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
