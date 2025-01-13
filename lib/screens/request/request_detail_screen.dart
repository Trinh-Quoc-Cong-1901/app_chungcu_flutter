import 'package:ecogreen_city/screens/request/components/request_card.dart';
import 'package:flutter/material.dart';

class RequestDetailScreen extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const RequestDetailScreen({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết yêu cầu'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RequestCard(requestData: requestData),
        ),
      ),
    );
  }
}
