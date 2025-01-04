import 'dart:convert';
import 'package:ecogreen_city/screens/request/new_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'components/request_card.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<dynamic> requests = [];
  List<dynamic> filteredRequests = [];
  String selectedStatus = 'Pending';
  String selectedPriority = 'Tất cả';

  final List<String> statusOptions = ['Pending', 'In Progress', 'Resolved'];
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
          requests = data;
          _filterRequests();
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
      filteredRequests = requests.where((item) {
        final matchesStatus =
            selectedStatus == 'Tất cả' || item['status'] == selectedStatus;
        final matchesPriority = selectedPriority == 'Tất cả' ||
            item['priority'].toLowerCase() == selectedPriority.toLowerCase();

        return matchesStatus && matchesPriority;
      }).toList();
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: selectedStatus,
              items: statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Lọc theo trạng thái',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                    _filterRequests();
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  setState(() {
                    selectedPriority = value;
                    _filterRequests();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: filteredRequests.isEmpty
                ? const Center(
                    child: Text('Không có yêu cầu nào.'),
                  )
                : ListView.builder(
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      return RequestCard(requestData: filteredRequests[index]);
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
                builder: (context) => const NewFeedbackScreen(),
              ),
            );

            if (result != null) {
              setState(() {
                requests.add(result);
                _filterRequests();
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
