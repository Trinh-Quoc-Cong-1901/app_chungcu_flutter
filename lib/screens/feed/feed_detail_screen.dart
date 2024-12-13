

import 'package:flutter/material.dart';

class FeedDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const FeedDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài viết'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Tên tác giả, Thời gian
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    post['author']['avatar'] ??
                        'https://via.placeholder.com/150',
                  ),
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['author']['name'] ?? 'Không rõ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      DateTime.parse(post['createdAt']).toLocal().toString(),
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
              post['title'] ?? 'Không có tiêu đề',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post['content'] ?? 'Không có nội dung',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Like và Comment Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _showLikes(context, post['likes']);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.thumb_up_alt_outlined),
                      const SizedBox(width: 5),
                      Text('${post['likes'].length} Likes'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showComments(context, post['comments']);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.comment_outlined),
                      const SizedBox(width: 5),
                      Text('${post['comments'].length} Comments'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30, color: Colors.grey),
            // Danh sách bình luận
            const Text(
              'Bình luận:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: post['comments'] != null && post['comments'].isNotEmpty
                  ? ListView.builder(
                      itemCount: post['comments'].length,
                      itemBuilder: (context, index) {
                        final comment = post['comments'][index];
                        return _buildCommentItem(comment);
                      },
                    )
                  : const Text(
                      'Chưa có bình luận nào.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
            ),
            const Divider(height: 20, color: Colors.grey),
            // Thêm bình luận mới
            Row(
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
                  onPressed: () {
                    // Gửi bình luận mới
                    final newComment = {
                      'user': {
                        'name': 'Bạn',
                        'avatar': 'https://via.placeholder.com/150',
                      },
                      'content': commentController.text,
                    };
                    post['comments']?.add(newComment); // Cập nhật cục bộ
                    commentController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
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

  // Hiển thị danh sách bình luận
  void _showComments(BuildContext context, List<dynamic> comments) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  comment['user']['avatar'] ??
                      'https://via.placeholder.com/150',
                ),
              ),
              title: Text(comment['user']['name'] ?? 'Không rõ'),
              subtitle: Text(comment['content'] ?? 'Không có nội dung'),
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
