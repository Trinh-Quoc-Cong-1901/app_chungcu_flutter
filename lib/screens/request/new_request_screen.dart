import 'dart:convert'; // Để mã hóa Base64
import 'dart:io'; // Để làm việc với File
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Các tùy chọn cho loại phản ánh và mức độ ưu tiên
  String? _selectedType;
  String? _selectedPriority;
  final List<String> _types = ['Điện', 'Nước', 'Dịch vụ', 'Khác'];
  final List<String> _priorities = ['Thấp', 'Trung bình', 'Cao'];

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
      final requestId = const Uuid().v4();
      final String? base64Image = await _encodeImageToBase64(); // Mã hóa ảnh

      // Dữ liệu gửi lên server
      final requestData = {
        'requestId': requestId,
        'title': _titleController.text,
        'feedbackType': _selectedType,
        'priority': _selectedPriority,
        'content': _contentController.text,
        'image': base64Image, // Ảnh dưới dạng Base64 hoặc null nếu không có ảnh
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/feedbacks'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestData), // Mã hóa dữ liệu thành JSON
        );

        if (response.statusCode == 201) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo yêu cầu thành công!')),
          );
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          // ignore: avoid_print
          print('Response status: ${response.statusCode}');
          // ignore: avoid_print
          print('Response body: ${response.body}');
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Có lỗi xảy ra: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
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
        title: const Text('Tạo yêu cầu BQL'),
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
                decoration: const InputDecoration(
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
              const SizedBox(height: 16.0),

              // DropdownButton cho loại phản ánh
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Loại phản ánh *',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn loại phản ánh';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // DropdownButton cho mức độ ưu tiên
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: _priorities.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Mức độ ưu tiên *',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn mức độ ưu tiên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
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
              const SizedBox(height: 16.0),

              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: const [4, 4],
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: _imageFile == null
                        ? const Column(
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
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('TẠO YÊU CẦU'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
