// import 'package:ecogreen_city/screens/request/new_request_screen.dart';
// import 'package:flutter/material.dart';

// class RequestScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh sách yêu cầu B...'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               // Hành động khi nhấn vào biểu tượng thêm yêu cầu
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.insert_drive_file,
//                   size: 80,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Chưa có yêu cầu',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 // Điều hướng sang trang mới khi nhấn vào nút "TẠO YÊU CẦU"
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NewRequestScreen(),
//                   ),
//                 );
//               },
//               icon: Icon(Icons.add),
//               label: Text('TẠO YÊU CẦU'),
//               style: ElevatedButton.styleFrom(
//                 // primary: Colors.teal, // Màu nền của nút
//                 minimumSize: Size(double.infinity, 50), // Kích thước của nút
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0), // Bo góc cho nút
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:ecogreen_city/screens/request/components/request_card.dart';
// import 'package:flutter/material.dart';
// import 'new_request_screen.dart'; // Đảm bảo import đúng file

// class RequestScreen extends StatefulWidget {
//   @override
//   _RequestScreenState createState() => _RequestScreenState();
// }

// class _RequestScreenState extends State<RequestScreen> {
//   List<Map<String, dynamic>> requests = []; // Danh sách lưu trữ các yêu cầu

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh sách yêu cầu B...'),
//       ),
//       body: requests.isEmpty // Kiểm tra nếu danh sách yêu cầu rỗng
//           ? Center(
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

//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // Điều hướng sang trang NewRequestScreen và nhận dữ liệu trả về
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NewRequestScreen(),
//             ),
//           );

//           // Nếu có dữ liệu trả về, thêm vào danh sách yêu cầu
//           if (result != null) {
//             setState(() {
//               requests.add(result);
//             });
//           }
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:ecogreen_city/screens/request/components/request_card.dart';
import 'package:flutter/material.dart';
import 'new_request_screen.dart'; // Đảm bảo import đúng file

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<Map<String, dynamic>> requests = []; // Danh sách lưu trữ các yêu cầu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách yêu cầu B...'),
      ),
      body: requests.isEmpty // Kiểm tra nếu danh sách yêu cầu rỗng
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có yêu cầu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCard(requestData: requests[index]);
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0), // Khoảng cách xung quanh
        child: ElevatedButton.icon(
          onPressed: () async {
            // Điều hướng sang trang NewRequestScreen và nhận dữ liệu trả về
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewRequestScreen(),
              ),
            );

            // Nếu có dữ liệu trả về, thêm vào danh sách yêu cầu
            if (result != null) {
              setState(() {
                requests.add(result);
              });
            }
          },
          icon: Icon(Icons.add),
          label: Text('TẠO YÊU CẦU'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50), // Kích thước của nút
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Bo góc cho nút
            ),
          ),
        ),
      ),
    );
  }
}
