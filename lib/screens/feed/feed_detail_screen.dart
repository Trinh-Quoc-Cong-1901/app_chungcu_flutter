import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const FeedDetailScreen({super.key, required this.post});

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}


class _FeedDetailScreenState extends State<FeedDetailScreen> {
  bool showComments = false; // Trạng thái hiển thị bình luận
  final TextEditingController commentController = TextEditingController();
  String? userId;
  String? userName; // Thêm userName để hiển thị tên người dùng

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Lấy thông tin người dùng từ SharedPreferences
  }

  // Lấy userId và userName từ SharedPreferences
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      userName = prefs.getString('userName'); // Lưu userName vào state
    });
  }

  // Gửi bình luận mới lên API
  Future<void> _addComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung bình luận')),
      );
      return;
    }

    try {
      // Gửi bình luận qua API
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/api/posts/${widget.post['_id']}/comment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'userName': userName,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Cập nhật cục bộ danh sách bình luận
          widget.post['comments'].add({
            'user': {'id': userId, 'name': userName},
            'content': content,
          });
          commentController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bình luận thành công')),
        );
      } else {
        throw Exception('Gửi bình luận thất bại');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }
//   Future<void> _addComment() async {
//   final content = commentController.text.trim();
//   if (content.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Vui lòng nhập nội dung bình luận')),
//     );
//     return;
//   }

//   try {
//     final response = await http.post(
//       Uri.parse(
//           'http://localhost:3000/api/posts/${widget.post['_id']}/comment'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'userId': userId,
//         'userName': userName,
//         'content': content,
//       }),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         // Cập nhật cục bộ danh sách bình luận
//         widget.post['comments'].add({
//           'user': {'id': userId, 'name': userName},
//           'content': content,
//         });
//         commentController.clear();
//       });
//       widget.onUpdatePost(widget.post); // Thông báo về thay đổi
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Bình luận thành công')),
//       );
//     } else {
//       throw Exception('Gửi bình luận thất bại');
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Lỗi: $e')),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài viết'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Avatar, Tên tác giả, Thời gian
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            widget.post['author']['avatar'] ??
                                'https://via.placeholder.com/150',
                          ),
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post['author']['name'] ?? 'Không rõ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              DateTime.parse(widget.post['createdAt'])
                                  .toLocal()
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Nội dung bài viết
                    Text(
                      widget.post['title'] ?? 'Không có tiêu đề',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.post['content'] ?? 'Không có nội dung',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    // Like và Comment Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showLikes(context, widget.post['likes']);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.thumb_up_alt_outlined),
                              const SizedBox(width: 5),
                              Text('${widget.post['likes'].length} Likes'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showComments = !showComments;
                            });
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.comment_outlined),
                              const SizedBox(width: 5),
                              Text(
                                  '${widget.post['comments'].length} Comments'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30, color: Colors.grey),
                    // Hiển thị bình luận nếu `showComments` là true
                    if (showComments) ...[
                      const Text(
                        'Bình luận:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      widget.post['comments'] != null &&
                              widget.post['comments'].isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.post['comments'].length,
                              itemBuilder: (context, index) {
                                final comment = widget.post['comments'][index];
                                return _buildCommentItem(comment);
                              },
                            )
                          : const Text(
                              'Chưa có bình luận nào.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // Luôn hiển thị ô nhập bình luận
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Thêm bình luận...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hiển thị danh sách người đã like
  void _showLikes(BuildContext context, List<dynamic> likes) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: likes.length,
          itemBuilder: (context, index) {
            final user = likes[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  user['avatar'] ?? 'https://via.placeholder.com/150',
                ),
              ),
              title: Text(user['name'] ?? 'Không rõ'),
            );
          },
        );
      },
    );
  }

  // Widget hiển thị từng bình luận
  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              comment['user']['avatar'] ?? 'https://via.placeholder.com/150',
            ),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['user']['name'] ?? 'Không rõ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  comment['content'] ?? 'Không có nội dung',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
