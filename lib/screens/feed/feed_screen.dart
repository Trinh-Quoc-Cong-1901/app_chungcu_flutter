import 'dart:convert';
import 'package:ecogreen_city/screens/feed/feed_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> posts = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Lấy userId từ SharedPreferences
    _fetchPosts(); // Gọi API để lấy danh sách bài viết
  }

  // Lấy userId từ SharedPreferences
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId'); // Lưu userId vào state
    });
  }

  // Gọi API để lấy danh sách bài viết
  Future<void> _fetchPosts() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/posts/allPost'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          posts = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải bài viết: $e')),
      );
    }
  }

  // Gửi yêu cầu like bài viết
  Future<void> _likePost(String postId) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User chưa đăng nhập')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/posts/$postId/like'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}), // Sử dụng userId đã lưu
      );

      if (response.statusCode == 200) {
        _fetchPosts(); // Cập nhật lại danh sách bài viết sau khi like
      } else {
        throw Exception('Failed to like post');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể like bài viết: $e')),
      );
    }
  }

  // Gửi yêu cầu thêm bình luận
  Future<void> _addComment(String postId, String content) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User chưa đăng nhập')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/posts/$postId/comment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'content': content}),
      );

      if (response.statusCode == 200) {
        _fetchPosts(); // Cập nhật lại danh sách bài viết sau khi comment
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể thêm bình luận: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Tin Ban Quản Lý'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(child: Text('Không có bài viết nào.'))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCardWidget(
                      post: post,
                      onLike: () => _likePost(post['_id']),
                      onComment: (content) => _addComment(post['_id'], content),
                    );
                  },
                ),
    );
  }
}



class PostCardWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final Function(String) onComment;

  const PostCardWidget({super.key, 
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedDetailScreen(post: post),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tác giả và thời gian
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      post['author']['avatar'] ??
                          'https://via.placeholder.com/150',
                    ),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['author']['name'] ?? 'Không rõ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateTime.parse(post['createdAt']).toLocal().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Tiêu đề bài viết
              Text(
                post['title'] ?? 'Không có tiêu đề',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Nội dung bài viết
              Text(
                post['content'] ?? 'Không có nội dung',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Like và comment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up_alt_outlined),
                        onPressed: onLike,
                      ),
                      Text('${post['likes'].length} Likes'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Thêm bình luận'),
                                content: TextField(
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'Nhập bình luận của bạn...',
                                  ),
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
                                      onComment(commentController.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Gửi'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Text('${post['comments'].length} Comments'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
