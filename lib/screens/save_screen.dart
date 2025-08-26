import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Màn hình placeholder cho các tab khác
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tin đã lưu')),
      body: const Center(child: Text('Danh sách các phòng bạn đã lưu sẽ hiện ở đây.')),
    );
  }
}