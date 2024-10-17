// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:image_picker/image_picker.dart';

// // class HotLineCommentScreen extends StatefulWidget {
// //   @override
// //   _HotLineCommentScreenState createState() => _HotLineCommentScreenState();
// // }

// // class _HotLineCommentScreenState extends State<HotLineCommentScreen> {
// //   final List<Map<String, dynamic>> messages = []; // Danh sách lưu trữ tin nhắn
// //   final TextEditingController _messageController = TextEditingController();
// //   final ImagePicker _picker = ImagePicker(); // Khởi tạo ImagePicker
// //   bool isLiked = false; // Kiểm tra trạng thái like cho mỗi tin nhắn
// //   int likeCount = 0; // Đếm số lượng like

// //   void _sendMessage(String content, {String? type}) {
// //     if (content.isNotEmpty) {
// //       final now = DateTime.now(); // Lấy thời gian hiện tại
// //       final time = DateFormat('h:mm a').format(now); // Định dạng thời gian
// //       final date = DateFormat('MMM d, yyyy').format(now); // Định dạng ngày

// //       setState(() {
// //         messages.add({
// //           'content': content,
// //           'type': type ?? 'text', // Hoặc 'image' nếu là tin nhắn hình ảnh
// //           'time': time,
// //           'date': date,
// //           'likes': 0, // Thêm lượt thích
// //           'replies': [], // Danh sách các trả lời cho bình luận
// //         });
// //         _messageController.clear(); // Xóa nội dung sau khi gửi
// //       });
// //     }
// //   }

// //   Future<void> _pickImage() async {
// //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       _sendMessage(pickedFile.path, type: 'image'); // Gửi tin nhắn hình ảnh
// //     }
// //   }

// //   void _toggleLike(int index) {
// //     setState(() {
// //       messages[index]['likes']++;
// //     });
// //   }

// //   void _replyToComment(int index) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         final TextEditingController replyController = TextEditingController();
// //         return AlertDialog(
// //           title: Text('Trả lời bình luận'),
// //           content: TextField(
// //             controller: replyController,
// //             decoration: InputDecoration(hintText: 'Nhập câu trả lời của bạn'),
// //           ),
// //           actions: [
// //             ElevatedButton(
// //               onPressed: () {
// //                 setState(() {
// //                   messages[index]['replies'].add({
// //                     'content': replyController.text,
// //                     'time': DateFormat('h:mm a').format(DateTime.now())
// //                   });
// //                 });
// //                 Navigator.of(context).pop();
// //                 replyController.clear();
// //               },
// //               child: Text('Gửi'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Ý Kiến'),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: messages.length,
// //               itemBuilder: (context, index) {
// //                 final message = messages[index];
// //                 return Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     ListTile(
// //                       leading: CircleAvatar(
// //                         backgroundImage: AssetImage(
// //                           'assets/images/avatar_placeholder.png', // Đường dẫn tới ảnh avatar của bạn
// //                         ),
// //                       ),
// //                       title: Text('Tên người dùng'),
// //                       subtitle: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           if (message['type'] == 'text')
// //                             Text(message['content']),
// //                           if (message['type'] == 'image')
// //                             Image.asset(
// //                               message[
// //                                   'content'], // Đường dẫn hình ảnh từ tin nhắn
// //                               width: 150,
// //                               height: 150,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           Text(
// //                             message['time'],
// //                             style: TextStyle(fontSize: 12, color: Colors.grey),
// //                           ),
// //                           SizedBox(height: 5),
// //                           Row(
// //                             children: [
// //                               GestureDetector(
// //                                 onTap: () => _toggleLike(index),
// //                                 child: Row(
// //                                   children: [
// //                                     Icon(Icons.thumb_up,
// //                                         color: Colors.blue, size: 20),
// //                                     SizedBox(width: 5),
// //                                     Text('Thích (${message['likes']})'),
// //                                   ],
// //                                 ),
// //                               ),
// //                               SizedBox(width: 20),
// //                               GestureDetector(
// //                                 onTap: () => _replyToComment(index),
// //                                 child: Text(
// //                                   'Trả lời',
// //                                   style: TextStyle(color: Colors.blue),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           if (message['replies'].isNotEmpty)
// //                             Padding(
// //                               padding: const EdgeInsets.only(top: 8.0),
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: List.generate(
// //                                     message['replies'].length, (replyIndex) {
// //                                   final reply = message['replies'][replyIndex];
// //                                   return Padding(
// //                                     padding: const EdgeInsets.only(top: 4.0),
// //                                     child: Text(
// //                                         '- ${reply['content']} (${reply['time']})'),
// //                                   );
// //                                 }),
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: _messageController,
// //               decoration: InputDecoration(
// //                 hintText: 'Nhập nội dung...',
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 contentPadding:
// //                     EdgeInsets.symmetric(vertical: 10, horizontal: 20),
// //                 prefixIcon: IconButton(
// //                   icon: Icon(Icons.image), // Biểu tượng hình ảnh
// //                   onPressed: _pickImage, // Gọi hàm chọn hình ảnh
// //                 ),
// //                 suffixIcon: IconButton(
// //                   icon: Icon(Icons.send), // Biểu tượng gửi tin nhắn
// //                   onPressed: () {
// //                     _sendMessage(
// //                         _messageController.text); // Gửi tin nhắn văn bản
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';

// class HotLineCommentScreen extends StatefulWidget {
//   @override
//   _HotLineCommentScreenState createState() => _HotLineCommentScreenState();
// }

// class _HotLineCommentScreenState extends State<HotLineCommentScreen> {
//   final List<Map<String, dynamic>> messages = [];
//   final TextEditingController _messageController = TextEditingController();
//   final FocusNode _focusNode =
//       FocusNode(); // Focus node cho phần nhập bình luận
//   final ImagePicker _picker = ImagePicker();
//   int? replyToMessageIndex; // Lưu chỉ số tin nhắn được trả lời

//   void _sendMessage(String content, {String? type}) {
//     if (content.isNotEmpty) {
//       final now = DateTime.now();
//       final time = DateFormat('h:mm a').format(now);
//       final date = DateFormat('MMM d, yyyy').format(now);

//       setState(() {
//         if (replyToMessageIndex == null) {
//           // Bình luận mới
//           messages.add({
//             'content': content,
//             'type': type ?? 'text',
//             'time': time,
//             'date': date,
//             'likes': false, // Thích hay không
//             'replies': [],
//           });
//         } else {
//           // Trả lời bình luận
//           messages[replyToMessageIndex!]['replies'].add({
//             'content': content,
//             'time': time,
//             'likes': false,
//             'replies': [],
//           });
//         }
//         _messageController.clear();
//         replyToMessageIndex = null; // Reset sau khi gửi tin nhắn
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _sendMessage(pickedFile.path, type: 'image');
//     }
//   }

//   void _toggleLike(int index, {bool isReply = false, int? replyIndex}) {
//     setState(() {
//       if (isReply && replyIndex != null) {
//         messages[index]['replies'][replyIndex]['likes'] =
//             !messages[index]['replies'][replyIndex]['likes'];
//       } else {
//         messages[index]['likes'] = !messages[index]['likes'];
//       }
//     });
//   }

//   void _replyToComment(int index) {
//     setState(() {
//       replyToMessageIndex = index;
//     });
//     FocusScope.of(context).requestFocus(_focusNode); // Focus vào phần nhập
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ý Kiến'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Tin nhắn chính
//                     ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: AssetImage(
//                           'assets/images/avatar_placeholder.png',
//                         ),
//                       ),
//                       title: Text('Tên người dùng'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (message['type'] == 'text')
//                             Text(message['content']),
//                           if (message['type'] == 'image')
//                             Image.asset(
//                               message['content'],
//                               width: 150,
//                               height: 150,
//                               fit: BoxFit.cover,
//                             ),
//                           Text(
//                             message['time'],
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                           Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: () => _toggleLike(index),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.thumb_up,
//                                       color: message['likes']
//                                           ? Colors.blue
//                                           : Colors.grey,
//                                     ),
//                                     SizedBox(width: 5),
//                                     Text('Thích'),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(width: 20),
//                               GestureDetector(
//                                 onTap: () => _replyToComment(index),
//                                 child: Text(
//                                   'Trả lời',
//                                   style: TextStyle(color: Colors.blue),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // Hiển thị các trả lời
//                           if (message['replies'].isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.only(left: 30.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: List.generate(
//                                     message['replies'].length, (replyIndex) {
//                                   final reply = message['replies'][replyIndex];
//                                   return ListTile(
//                                     leading: CircleAvatar(
//                                       backgroundImage: AssetImage(
//                                         'assets/images/avatar_placeholder.png',
//                                       ),
//                                     ),
//                                     title: Text('Người trả lời'),
//                                     subtitle: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(reply['content']),
//                                         Text(
//                                           reply['time'],
//                                           style: TextStyle(
//                                               fontSize: 12, color: Colors.grey),
//                                         ),
//                                         Row(
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () => _toggleLike(index,
//                                                   isReply: true,
//                                                   replyIndex: replyIndex),
//                                               child: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.thumb_up,
//                                                     color: reply['likes']
//                                                         ? Colors.blue
//                                                         : Colors.grey,
//                                                   ),
//                                                   SizedBox(width: 5),
//                                                   Text('Thích'),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(width: 20),
//                                             GestureDetector(
//                                               onTap: () => _replyToComment(
//                                                   index), // Trả lời lại
//                                               child: Text(
//                                                 'Trả lời',
//                                                 style: TextStyle(
//                                                     color: Colors.blue),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _messageController,
//               focusNode: _focusNode, // Focus node để chuyển focus
//               decoration: InputDecoration(
//                 hintText: replyToMessageIndex != null
//                     ? 'Trả lời bình luận...'
//                     : 'Nhập nội dung...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 contentPadding:
//                     EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 prefixIcon: IconButton(
//                   icon: Icon(Icons.image),
//                   onPressed: _pickImage,
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     _sendMessage(_messageController.text);
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class HotLineCommentScreen extends StatefulWidget {
  @override
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
        title: Text('Ý Kiến'),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                title: Text('Trịnh Như Quỳnh'),
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
                                      style: TextStyle(
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
                                              SizedBox(width: 5),
                                              Text('Thích'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () => _replyToComment(index),
                                          child: Text(
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                              title: Text('Trịnh Như Quỳnh'),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(reply['content']),
                                                  Text(
                                                    reply['time'],
                                                    style: TextStyle(
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
                                                            SizedBox(width: 5),
                                                            Text('Thích'),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _replyToComment(
                                                                index), // Trả lời lại
                                                        child: Text(
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
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                prefixIcon: IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
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
