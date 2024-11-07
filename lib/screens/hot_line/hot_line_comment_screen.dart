import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class HotLineCommentScreen extends StatefulWidget {
  const HotLineCommentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HotLineCommentScreenState createState() => _HotLineCommentScreenState();
}

class _HotLineCommentScreenState extends State<HotLineCommentScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode =
      FocusNode(); // Focus node cho phần nhập bình luận
  final ImagePicker _picker = ImagePicker();
  int? replyToMessageIndex; // Lưu chỉ số tin nhắn được trả lời

  void _sendMessage(String content, {String? type}) {
    if (content.isNotEmpty) {
      final now = DateTime.now();
      final time = DateFormat('h:mm a').format(now);
      final date = DateFormat('MMM d, yyyy').format(now);

      setState(() {
        if (replyToMessageIndex == null) {
          // Bình luận mới
          messages.add({
            'content': content,
            'type': type ?? 'text',
            'time': time,
            'date': date,
            'likes': false,
            'replies': [],
          });
        } else {
          // Trả lời bình luận
          messages[replyToMessageIndex!]['replies'].add({
            'content': content,
            'time': time,
            'likes': false,
            'replies': [],
          });
        }
        _messageController.clear();
        replyToMessageIndex = null; // Reset sau khi gửi tin nhắn
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMessage(pickedFile.path, type: 'image');
    }
  }

  void _toggleLike(int index, {bool isReply = false, int? replyIndex}) {
    setState(() {
      if (isReply && replyIndex != null) {
        messages[index]['replies'][replyIndex]['likes'] =
            !messages[index]['replies'][replyIndex]['likes'];
      } else {
        messages[index]['likes'] = !messages[index]['likes'];
      }
    });
  }

  void _replyToComment(int index) {
    setState(() {
      replyToMessageIndex = index;
    });
    FocusScope.of(context).requestFocus(_focusNode); // Focus vào phần nhập
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ý Kiến'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tin nhắn chính
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/avatar_placeholder.png',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: const Text('Trịnh Như Quỳnh'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (message['type'] == 'text')
                                      Text(message['content']),
                                    if (message['type'] == 'image')
                                      Image.asset(
                                        message['content'],
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    Text(
                                      message['time'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _toggleLike(index),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.thumb_up,
                                                color: message['likes']
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text('Thích'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () => _replyToComment(index),
                                          child: const Text(
                                            'Trả lời',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Hiển thị các trả lời thụt vào
                              if (message['replies'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        List.generate(message['replies'].length,
                                            (replyIndex) {
                                      final reply =
                                          message['replies'][replyIndex];
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                'assets/images/avatar_placeholder.png',
                                              ),
                                              radius:
                                                  15, // Giảm kích thước avatar trả lời
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title:
                                                  const Text('Trịnh Như Quỳnh'),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(reply['content']),
                                                  Text(
                                                    reply['time'],
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _toggleLike(index,
                                                                isReply: true,
                                                                replyIndex:
                                                                    replyIndex),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.thumb_up,
                                                              color: reply[
                                                                      'likes']
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            const Text('Thích'),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _replyToComment(
                                                                index), // Trả lời lại
                                                        child: const Text(
                                                          'Trả lời',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode, // Focus node để chuyển focus
              decoration: InputDecoration(
                hintText: replyToMessageIndex != null
                    ? 'Trả lời bình luận...'
                    : 'Nhập nội dung...',
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
