import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cộng đồng'),
      ),
      body: const Center(
        child: Text('Chưa có bài viết nào'),
      ),
    );
  }
}
