import 'package:ecogreen_city/screens/hot_line/hot_line_comment_screen.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class HotlineScreen extends StatefulWidget {
  const HotlineScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HotlineScreenState createState() => _HotlineScreenState();
}

class _HotlineScreenState extends State<HotlineScreen> {
  bool isLiked = false;
  int likes = 0; // Đếm số lượt thích
  int commentCount = 0; // Số lượng bình luận
  List<String> comments = []; // Danh sách các bình luận

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likes = isLiked ? likes + 1 : likes - 1;
    });
  }

  void _navigateToComments(BuildContext context) async {
    // Điều hướng sang màn hình CommentScreen và nhận lại dữ liệu
    final newComment = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HotLineCommentScreen()),
    );

    // Nếu có bình luận mới
    if (newComment != null) {
      setState(() {
        comments.add(newComment); // Thêm bình luận mới vào danh sách
        commentCount++; // Tăng số lượng bình luận
      });
    }
  }

  void _shareContent() {
    // Thực hiện chức năng chia sẻ
    // ignore: avoid_print
    print("Chia sẻ nội dung");
  }

  // Hàm mở số điện thoại khi nhấn vào
  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    // ignore: deprecated_member_use
    if (await canLaunch(phoneUri.toString())) {
      // ignore: deprecated_member_use
      await launch(phoneUri.toString());
    } else {
      // ignore: avoid_print
      print("Không thể mở số điện thoại");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotline'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh Hotline
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/hot_line.png'), // Thay thế bằng đường dẫn ảnh của bạn
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Thông tin chính của Hotline
                    const Text(
                      'Số điện thoại cần biết',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 20),
                        SizedBox(width: 5),
                        Text('Eco Green City'),
                        SizedBox(width: 20),
                        Icon(Icons.access_time, color: Colors.grey, size: 20),
                        SizedBox(width: 5),
                        Text('14/08/2023 18:14'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Chăm sóc khách hàng
                    Row(
                      children: [
                        Text(
                          'Công An:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            width:
                                8), // Thêm khoảng cách nhỏ giữa văn bản và số điện thoại
                        GestureDetector(
                          onTap: () => _launchPhone('113'), // Mở số điện thoại
                          child: Text(
                            '113',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Hotline
                    Row(
                      children: [
                        Text(
                          'Cứu Hoả:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            width:
                                8), // Thêm khoảng cách nhỏ giữa văn bản và số điện thoại
                        GestureDetector(
                          onTap: () => _launchPhone('114'), // Mở số điện thoại
                          child: Text(
                            '114',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Cấp Cứu Y Tế:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            width:
                                8), // Thêm khoảng cách nhỏ giữa văn bản và số điện thoại
                        GestureDetector(
                          onTap: () => _launchPhone('115'), // Mở số điện thoại
                          child: const Text(
                            '115',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Chăm Sóc Khách Hàng:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            width:
                                8), // Thêm khoảng cách nhỏ giữa văn bản và số điện thoại
                        GestureDetector(
                          onTap: () =>
                              _launchPhone('0986666666'), // Mở số điện thoại
                          child: const Text(
                            '0986666666',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Hotline:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            width:
                                8), // Thêm khoảng cách nhỏ giữa văn bản và số điện thoại
                        GestureDetector(
                          onTap: () =>
                              _launchPhone('09876543210'), // Mở số điện thoại
                          child: const Text(
                            '09876543210',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Spacer để đẩy nội dung dưới cùng xuống đáy màn hình
          const SizedBox(height: 4),

          // Hiển thị số lượt thích và bình luận nếu có
          if (likes > 0 || commentCount > 0)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (likes > 0)
                    Text('$likes lượt thích',
                        style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),

          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up,
                          color: isLiked ? Colors.green : Colors.grey),
                      const SizedBox(width: 5),
                      const Text('Thích'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToComments(context),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                      if (commentCount > 0) ...[
                        const SizedBox(width: 5),
                        Text('($commentCount)'),
                      ],
                      const SizedBox(width: 5),
                      const Text('Ý kiến'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _shareContent,
                  child: const Row(
                    children: [
                      Icon(Icons.share, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('Chia sẻ'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
