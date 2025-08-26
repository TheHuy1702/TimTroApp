import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Để chạy riêng màn hình này, bạn có thể dùng hàm main sau:
void main() {
  runApp(MaterialApp(
    title: 'Trọ Gu',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      textTheme: GoogleFonts.beVietnamProTextTheme(),
    ),
    home: const EditProfileScreen(),
  ));
}


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Sử dụng TextEditingController để quản lý và lấy dữ liệu từ TextFormField
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với dữ liệu người dùng hiện tại (giả lập)
    _nameController = TextEditingController(text: 'Nguyễn Văn A');
    _phoneController = TextEditingController(text: '0987654321');
    _emailController = TextEditingController(text: 'nva.user@email.com');
    _bioController = TextEditingController(text: 'Sinh viên năm 3, thích yên tĩnh và sạch sẽ. Tìm trọ gần khu vực quận 10.');
  }

  @override
  void dispose() {
    // Hủy các controller khi widget bị loại bỏ để tránh rò rỉ bộ nhớ
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Chỉnh sửa thông tin',
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              _buildAvatarSection(),
              const SizedBox(height: 32),
              _buildInfoForm(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho phần ảnh đại diện
  Widget _buildAvatarSection() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage('https://placehold.co/150x150/a7d7c5/ffffff?text=User'),
        ),
        // Nút nhỏ để chỉnh sửa ảnh
        GestureDetector(
          onTap: () {
            // TODO: Thêm logic chọn ảnh từ thư viện/camera
          },
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal,
            child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  // Widget cho form nhập thông tin
  Widget _buildInfoForm() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Họ và tên',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ tên';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Email thường không cho phép chỉnh sửa
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            enabled: false, // Vô hiệu hóa trường này
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _bioController,
            label: 'Giới thiệu bản thân (Gu của bạn)',
            icon: Icons.description_outlined,
            maxLines: 3,
            hint: 'Mô tả ngắn về lối sống, sở thích để chủ nhà hiểu hơn về bạn...',
          ),
        ],
      ),
    );
  }

  // Widget con cho một trường nhập liệu
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      validator: validator,
    );
  }

  // Widget cho nút Lưu thay đổi
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Kiểm tra xem form có hợp lệ không
          if (_formKey.currentState!.validate()) {
            // Nếu hợp lệ, thực hiện logic lưu thông tin
            // TODO: Gọi API để cập nhật thông tin người dùng
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã lưu thay đổi!')),
            );
            // Có thể quay lại trang trước sau khi lưu
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text('LƯU THAY ĐỔI'),
      ),
    );
  }
}
