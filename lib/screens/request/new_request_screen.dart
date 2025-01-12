import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecogreen_city/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class NewFeedbackScreen extends StatefulWidget {
  const NewFeedbackScreen({super.key});

  @override
  _NewFeedbackScreenState createState() => _NewFeedbackScreenState();
}

class _NewFeedbackScreenState extends State<NewFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedPriority;
  String? _userId;
  final List<String> _priorities = ['Thấp', 'Trung bình', 'Cao'];
  List<XFile> _imageFiles = [];

  String? _token;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = await _authService.getUserId();
    final token = await _authService.getAccessToken();

    setState(() {
      _userId = userId;
      _token = token;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFiles.add(image);
      });
    }
  }

  Future<List<String>> _encodeImagesToBase64() async {
    List<String> base64Images = [];
    for (XFile file in _imageFiles) {
      List<int> imageBytes = await File(file.path).readAsBytes();
      base64Images.add(base64Encode(imageBytes));
    }
    return base64Images;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final List<String> base64Images = await _encodeImagesToBase64();

      final feedbackData = {
        'title': _titleController.text,
        'feedbackType': 'Dịch vụ khách hàng',
        'priority': _selectedPriority,
        'content': _contentController.text,
        'images': base64Images,
        'createdBy': _userId,
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.4:3000/api/feedbacks'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(feedbackData),
        );

        if (response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Phản hồi đã được tạo thành công!')),
            );
            Navigator.pop(context);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Đã xảy ra lỗi khi tạo phản hồi: ${response.reasonPhrase}',
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không thể kết nối tới server: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo phản hồi mới'),
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
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ..._imageFiles.map((image) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(
                          File(image.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageFiles.remove(image);
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    );
                  }).toList(),
                  GestureDetector(
                    onTap: _pickImage,
                    child: DottedBorder(
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashPattern: const [4, 4],
                      child: const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Icon(Icons.add_a_photo, size: 40),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  child: const Text('GỬI PHẢN HỒI'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
