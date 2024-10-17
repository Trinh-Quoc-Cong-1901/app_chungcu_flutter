// // import 'package:dotted_border/dotted_border.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart'; // Thêm thư viện image_picker
// // import 'dart:io'; // Để sử dụng File

// // class NewRequestScreen extends StatefulWidget {
// //   @override
// //   _NewRequestScreenState createState() => _NewRequestScreenState();
// // }

// // class _NewRequestScreenState extends State<NewRequestScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final ImagePicker _picker = ImagePicker();
// //   XFile? _imageFile;
// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _typeController = TextEditingController();
// //   final TextEditingController _priorityController = TextEditingController();
// //   final TextEditingController _contentController = TextEditingController();

// //   Future<void> _pickImage() async {
// //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// //     setState(() {
// //       _imageFile = image; // Cập nhật biến _imageFile
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Tạo yêu cầu BQL'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               TextFormField(
// //                 controller: _titleController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Tiêu đề *',
// //                   border: UnderlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Vui lòng nhập tiêu đề';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16.0),
// //               TextFormField(
// //                 controller: _typeController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Loại phản ánh *',
// //                   border: UnderlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Vui lòng chọn loại phản ánh';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16.0),
// //               TextFormField(
// //                 controller: _priorityController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Mức độ ưu tiên *',
// //                   border: UnderlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Vui lòng chọn mức độ ưu tiên';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16.0),
// //               TextFormField(
// //                 controller: _contentController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Nội dung *',
// //                   border: UnderlineInputBorder(),
// //                 ),
// //                 maxLines: 5,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Vui lòng nhập nội dung';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 16.0),
// //               GestureDetector(
// //                 onTap: _pickImage, // Khi nhấn vào, gọi hàm chọn ảnh
// //                 child: DottedBorder(
// //                   color: Colors.grey,
// //                   strokeWidth: 1,
// //                   dashPattern: [4, 4],
// //                   child: Container(
// //                     width: 100, // Để sử dụng toàn bộ chiều rộng
// //                     height: 100,
// //                     child: _imageFile == null
// //                         ? Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Icon(Icons.image, size: 40, color: Colors.grey),
// //                               SizedBox(height: 8.0),
// //                               Text('Thêm ảnh',
// //                                   style: TextStyle(color: Colors.grey)),
// //                             ],
// //                           )
// //                         : Image.file(
// //                             File(_imageFile!.path), // Hiển thị ảnh đã chọn
// //                             fit: BoxFit.cover,
// //                           ),
// //                   ),
// //                 ),
// //               ),
// //               Spacer(),
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     if (_formKey.currentState!.validate()) {
// //                       // Xử lý khi bấm tạo yêu cầu
// //                       // Lấy dữ liệu từ các trường nhập liệu
// //                       final requestData = {
// //                         'title': _titleController.text,
// //                         'type': _typeController.text,
// //                         'priority': _priorityController.text,
// //                         'content': _contentController.text,
// //                         'image': _imageFile, // Thêm hình ảnh
// //                       };

// //                       // Quay lại màn hình RequestScreen và trả về dữ liệu
// //                       Navigator.pop(context, requestData);
// //                     }
// //                   },
// //                   child: Text('TẠO YÊU CẦU'),
// //                   style: ElevatedButton.styleFrom(
// //                     padding: EdgeInsets.all(16.0),
// //                     textStyle: TextStyle(fontSize: 16),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

// class NewRequestScreen extends StatefulWidget {
//   @override
//   _NewRequestScreenState createState() => _NewRequestScreenState();
// }

// class _NewRequestScreenState extends State<NewRequestScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _typeController = TextEditingController();
//   final TextEditingController _priorityController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = image; // Cập nhật biến _imageFile
//     });
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       // Xử lý khi bấm tạo yêu cầu
//       // Lấy dữ liệu từ các trường nhập liệu
//       final requestId = Uuid().v4();
//       final requestData = {
//         'requestId': requestId,
//         'title': _titleController.text,
//         'feedbackType': _typeController.text,
//         'priority': _priorityController.text,
//         'content': _contentController.text,
//         'image': _imageFile
//       };
//       print(jsonEncode(
//           requestData)); // Kiểm tra xem dữ liệu có đúng định dạng không

//       // Chuẩn bị URL API
//       // final String apiUrl = 'http://localhost:3000/feedbacks';

//       try {
//         // Tạo yêu cầu POST với body là JSON
//         final response = await http.post(
//           Uri.parse('http://localhost:3000/api/feedbacks'),
//           headers: {"Content-Type": "application/json"},
//           body: jsonEncode(requestData),
//         );

//         if (response.statusCode == 201) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Tạo yêu cầu thành công!')),
//           );
//           Navigator.pop(context);
//         } else {
//           print('Response status: ${response.statusCode}');
//           print(
//               'Response body: ${response.body}'); // Kiểm tra nội dung phản hồi từ server
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Có lỗi xảy ra: ${response.reasonPhrase}')),
//           );
//         }
//       } catch (e) {
//         // Bắt lỗi ngoại lệ khi gọi API
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Không thể kết nối tới server: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tạo yêu cầu BQL'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Tiêu đề *',
//                   border: UnderlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập tiêu đề';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _typeController,
//                 decoration: InputDecoration(
//                   labelText: 'Loại phản ánh *',
//                   border: UnderlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng chọn loại phản ánh';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _priorityController,
//                 decoration: InputDecoration(
//                   labelText: 'Mức độ ưu tiên *',
//                   border: UnderlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng chọn mức độ ưu tiên';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _contentController,
//                 decoration: InputDecoration(
//                   labelText: 'Nội dung *',
//                   border: UnderlineInputBorder(),
//                 ),
//                 maxLines: 5,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập nội dung';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               GestureDetector(
//                 onTap: _pickImage, // Khi nhấn vào, gọi hàm chọn ảnh
//                 child: DottedBorder(
//                   color: Colors.grey,
//                   strokeWidth: 1,
//                   dashPattern: [4, 4],
//                   child: Container(
//                     width: 100, // Để sử dụng toàn bộ chiều rộng
//                     height: 100,
//                     child: _imageFile == null
//                         ? Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.image, size: 40, color: Colors.grey),
//                               SizedBox(height: 8.0),
//                               Text('Thêm ảnh',
//                                   style: TextStyle(color: Colors.grey)),
//                             ],
//                           )
//                         : Image.file(
//                             File(_imageFile!.path), // Hiển thị ảnh đã chọn
//                             fit: BoxFit.cover,
//                           ),
//                   ),
//                 ),
//               ),
//               Spacer(),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _submitForm, // Gọi hàm để gửi thông tin lên API
//                   child: Text('TẠO YÊU CẦU'),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(16.0),
//                     textStyle: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert'; // Để mã hóa Base64
import 'dart:io'; // Để làm việc với File
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NewRequestScreen extends StatefulWidget {
  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Hàm để chọn ảnh
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  // Hàm để mã hóa ảnh thành Base64
  Future<String?> _encodeImageToBase64() async {
    if (_imageFile != null) {
      List<int> imageBytes = await File(_imageFile!.path).readAsBytes();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    }
    return null; // Nếu không có ảnh
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Lấy dữ liệu từ form
      final requestId = Uuid().v4();
      final String? base64Image = await _encodeImageToBase64(); // Mã hóa ảnh

      // Dữ liệu gửi lên server
      final requestData = {
        'requestId': requestId,
        'title': _titleController.text,
        'feedbackType': _typeController.text,
        'priority': _priorityController.text,
        'content': _contentController.text,
        'image': base64Image, // Ảnh dưới dạng Base64 hoặc null nếu không có ảnh
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/feedback/feedbacks'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestData), // Mã hóa dữ liệu thành JSON
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tạo yêu cầu thành công!')),
          );
          Navigator.pop(context);
        } else {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Có lỗi xảy ra: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể kết nối tới server: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo yêu cầu BQL'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề *',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'Loại phản ánh *',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn loại phản ánh';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: 'Mức độ ưu tiên *',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn mức độ ưu tiên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Nội dung *',
                  border: UnderlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: [4, 4],
                  child: Container(
                    width: 100,
                    height: 100,
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 40, color: Colors.grey),
                              SizedBox(height: 8.0),
                              Text('Thêm ảnh',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          )
                        : Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('TẠO YÊU CẦU'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16.0),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
