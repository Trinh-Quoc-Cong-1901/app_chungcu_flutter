import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ecogreen_city/services/data_service.dart';
import 'package:ecogreen_city/screens/feed/feed_detail_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final DataService _dataService = DataService();
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  // Gọi `DataService` để tải danh sách bài viết
  Future<void> _fetchPosts() async {
    try {
      final fetchedPosts = await _dataService.loadFeeds();
      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải bài viết: $e')),
      );
    }
  }

  // Gửi yêu cầu like bài viết
  Future<void> _likePost(String postId) async {
    try {
      await _dataService.likePost(postId);
      _fetchPosts(); // Cập nhật lại danh sách bài viết sau khi like
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể like bài viết: $e')),
      );
    }
  }

  // Gửi yêu cầu thêm bình luận
  Future<void> _addComment(String postId, String content) async {
    try {
      await _dataService.addComment(postId, content);
      _fetchPosts(); // Cập nhật lại danh sách bài viết sau khi comment
    } catch (e) {
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

class PostCardWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final Function(String) onComment;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedDetailScreen(
              post: widget.post,
            ),
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
                      widget.post['author']['avatar'] ??
                          'https://via.placeholder.com/150',
                    ),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post['author']['name'] ?? 'Không rõ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateTime.parse(widget.post['createdAt'])
                            .toLocal()
                            .toString(),
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
                widget.post['title'] ?? 'Không có tiêu đề',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Nội dung bài viết với "Xem thêm"
              Text.rich(
                TextSpan(
                  text: isExpanded
                      ? widget.post['content'] ?? 'Không có nội dung'
                      : (widget.post['content'] ?? 'Không có nội dung')
                          .substring(
                              0,
                              (widget.post['content']?.length ?? 0) > 100
                                  ? 100
                                  : widget.post['content']?.length ?? 0),
                  style: const TextStyle(fontSize: 16),
                  children: [
                    if (!isExpanded &&
                        (widget.post['content']?.length ?? 0) > 100)
                      TextSpan(
                        text: '... Xem thêm',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              isExpanded = true;
                            });
                          },
                      ),
                  ],
                ),
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
                        onPressed: widget.onLike,
                      ),
                      Text('${widget.post['likes'].length} Likes'),
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
                                      widget.onComment(commentController.text);
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
                      Text('${widget.post['comments'].length} Comments'),
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
