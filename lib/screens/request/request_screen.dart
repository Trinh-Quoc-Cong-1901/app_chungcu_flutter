// // ignore_for_file: avoid_print

// import 'package:ecogreen_city/screens/request/components/request_card.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'new_request_screen.dart'; // Đảm bảo import đúng file

// class RequestScreen extends StatefulWidget {
//   const RequestScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _RequestScreenState createState() => _RequestScreenState();
// }

// class _RequestScreenState extends State<RequestScreen> {
//   List<dynamic> requests = []; // Danh sách lưu trữ các yêu cầu
//   List<dynamic> lowPriorityRequests = [];
//   List<dynamic> mediumPriorityRequests = [];
//   List<dynamic> highPriorityRequests = [];
//   @override
//   void initState() {
//     super.initState();
//     _fetchRequests(); // Gọi hàm tải dữ liệu khi màn hình khởi động
//   }

//   // Future<void> _fetchRequests() async {
//   //   try {
//   //     final response =
//   //         await http.get(Uri.parse('http://localhost:3000/api/feedbacks'));

//   //     if (response.statusCode == 200) {
//   //       final List<dynamic> data = jsonDecode(response.body);
//   //       setState(() {
//   //         requests = data; // Gán trực tiếp dữ liệu
//   //       });
//   //     } else {
//   //       // Xử lý lỗi nếu không tải được dữ liệu
//   //       print("Failed to load feedbacks");
//   //       if (mounted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           const SnackBar(content: Text('Không thể tải danh sách yêu cầu')),
//   //         );
//   //       }
//   //     }
//   //   } catch (error) {
//   //     print("Error fetching requests: $error");
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Lỗi kết nối: $error')),
//   //       );
//   //     }
//   //   }
//   // }
//   Future<void> _fetchRequests() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://localhost:3000/api/feedbacks'));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         setState(() {
//           requests = data; // Gán trực tiếp dữ liệu vào requests

//           // Chia danh sách theo priority
//           lowPriorityRequests =
//               requests.where((item) => item['priority'] == 'Thấp').toList();
//           mediumPriorityRequests = requests
//               .where((item) => item['priority'] == 'Trung bình')
//               .toList();
//           highPriorityRequests =
//               requests.where((item) => item['priority'] == 'Cao').toList();
//         });
//       } else {
//         print("Failed to load feedbacks");
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Không thể tải danh sách yêu cầu')),
//           );
//         }
//       }
//     } catch (error) {
//       print("Error fetching requests: $error");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi kết nối: $error')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Danh sách yêu cầu '),
//       ),
//       body: requests.isEmpty
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.insert_drive_file,
//                     size: 80,
//                     color: Colors.grey,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Chưa có yêu cầu',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               itemCount: requests.length,
//               itemBuilder: (context, index) {
//                 return RequestCard(requestData: requests[index]);
//               },
//             ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton.icon(
//           onPressed: () async {
//             // Điều hướng sang trang NewRequestScreen và nhận dữ liệu trả về
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const NewRequestScreen(),
//               ),
//             );

//             // Nếu có dữ liệu trả về, thêm vào danh sách yêu cầu
//             if (result != null) {
//               setState(() {
//                 requests.add(result);
//               });
//             }
//           },
//           icon: const Icon(Icons.add),
//           label: const Text('TẠO YÊU CẦU'),
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:ecogreen_city/screens/request/new_request_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class RequestScreen extends StatefulWidget {
//   const RequestScreen({super.key});

//   @override
//   _RequestScreenState createState() => _RequestScreenState();
// }

// class _RequestScreenState extends State<RequestScreen> {
//   List<dynamic> requests = []; // Danh sách lưu trữ tất cả yêu cầu
//   List<dynamic> filteredRequests = []; // Danh sách hiển thị dựa trên lọc
//   String selectedPriority = 'Tất cả'; // Giá trị lọc hiện tại
//   final List<String> priorityOptions = ['Tất cả', 'Thấp', 'Trung bình', 'Cao'];

//   @override
//   void initState() {
//     super.initState();
//     _fetchRequests();
//   }

//   Future<void> _fetchRequests() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://localhost:3000/api/feedbacks'));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         setState(() {
//           requests = data; // Gán tất cả dữ liệu
//           _filterRequests(); // Lọc dữ liệu ban đầu
//         });
//       } else {
//         print("Failed to load feedbacks");
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Không thể tải danh sách yêu cầu')),
//           );
//         }
//       }
//     } catch (error) {
//       print("Error fetching requests: $error");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi kết nối: $error')),
//         );
//       }
//     }
//   }

//   void _filterRequests() {
//     setState(() {
//       if (selectedPriority == 'Tất cả') {
//         filteredRequests = requests; // Hiển thị tất cả
//       } else {
//         filteredRequests = requests
//             .where((item) => item['priority'] == selectedPriority)
//             .toList(); // Lọc theo mức độ ưu tiên
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Danh sách yêu cầu'),
//       ),
//       body: Column(
//         children: [
//           // DropdownButton để chọn mức độ ưu tiên
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedPriority,
//               items: priorityOptions.map((priority) {
//                 return DropdownMenuItem(
//                   value: priority,
//                   child: Text(priority),
//                 );
//               }).toList(),
//               decoration: const InputDecoration(
//                 labelText: 'Lọc theo mức độ ưu tiên',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 if (value != null) {
//                   selectedPriority = value;
//                   _filterRequests(); // Cập nhật danh sách hiển thị
//                 }
//               },
//             ),
//           ),
//           // Danh sách yêu cầu
//           Expanded(
//             child: filteredRequests.isEmpty
//                 ? const Center(
//                     child: Text('Không có yêu cầu nào.'),
//                   )
//                 : ListView.builder(
//                     itemCount: filteredRequests.length,
//                     itemBuilder: (context, index) {
//                       final request = filteredRequests[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: ListTile(
//                           title: Text(request['title']),
//                           subtitle: Text(
//                               'Loại: ${request['feedbackType']} | Ưu tiên: ${request['priority']}'),
//                           trailing: const Icon(Icons.arrow_forward),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton.icon(
//           onPressed: () async {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const NewRequestScreen(),
//               ),
//             );

//             if (result != null) {
//               setState(() {
//                 requests.add(result);
//                 _filterRequests(); // Lọc lại sau khi thêm mới
//               });
//             }
//           },
//           icon: const Icon(Icons.add),
//           label: const Text('TẠO YÊU CẦU'),
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:ecogreen_city/screens/request/new_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'components/request_card.dart'; // Đảm bảo import đúng file

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<dynamic> requests = []; // Danh sách lưu trữ tất cả yêu cầu
  List<dynamic> filteredRequests = []; // Danh sách hiển thị sau khi lọc
  String selectedPriority = 'Tất cả'; // Giá trị lọc hiện tại
  final List<String> priorityOptions = ['Tất cả', 'Thấp', 'Trung bình', 'Cao'];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/feedbacks'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          requests = data; // Gán tất cả dữ liệu
          _filterRequests(); // Lọc dữ liệu ban đầu
        });
      } else {
        print("Failed to load feedbacks");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể tải danh sách yêu cầu')),
          );
        }
      }
    } catch (error) {
      print("Error fetching requests: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: $error')),
        );
      }
    }
  }

  void _filterRequests() {
    setState(() {
      if (selectedPriority == 'Tất cả') {
        filteredRequests = requests; // Hiển thị tất cả
      } else {
        filteredRequests = requests
            .where((item) => item['priority'] == selectedPriority)
            .toList(); // Lọc theo mức độ ưu tiên
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu cầu'),
      ),
      body: Column(
        children: [
          // DropdownButton để chọn mức độ ưu tiên
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: selectedPriority,
              items: priorityOptions.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Lọc theo mức độ ưu tiên',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value != null) {
                  selectedPriority = value;
                  _filterRequests(); // Cập nhật danh sách hiển thị
                }
              },
            ),
          ),
          // Danh sách yêu cầu
          Expanded(
            child: filteredRequests.isEmpty
                ? const Center(
                    child: Text('Không có yêu cầu nào.'),
                  )
                : ListView.builder(
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      return RequestCard(
                          requestData: filteredRequests[
                              index]); // Sử dụng lại RequestCard
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewRequestScreen(),
              ),
            );

            if (result != null) {
              setState(() {
                requests.add(result);
                _filterRequests(); // Lọc lại sau khi thêm mới
              });
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('TẠO YÊU CẦU'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
