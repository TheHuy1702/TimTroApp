import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Login_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
// Màn hình placeholder cho "Tài khoản"
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Tài khoản của tôi', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.grey[800])),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileMenu(context),
          const SizedBox(height: 24),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  // Widget cho phần header của trang tài khoản
  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://placehold.co/100x100/a7d7c5/ffffff?text=User'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nguyễn Văn A', // Thay bằng tên người dùng thật
              style: GoogleFonts.beVietnamPro(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'nva.user@email.com', // Thay bằng email người dùng thật
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget cho các menu chức năng
  Widget _buildProfileMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            context,
            icon: Icons.edit_outlined,
            title: 'Chỉnh sửa thông tin',
            onTap: () {
              // Thêm dòng này để điều hướng
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()), // Giả sử bạn đã import file màn hình mới
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuTile(
            context,
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()), // Giả sử bạn đã import file màn hình mới
              );},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuTile(
            context,
            icon: Icons.add_business_outlined,
            title: 'Trở thành chủ nhà / Đăng tin',
            onTap: () {
              // Điều hướng đến màn hình tạo bài đăng
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostScreen()),
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildMenuTile(
            context,
            icon: Icons.help_outline,
            title: 'Trợ giúp & Hỗ trợ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpAndSupportScreen()), // Giả sử bạn đã import file màn hình mới
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget con cho một hàng trong menu
  Widget _buildMenuTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: GoogleFonts.beVietnamPro()),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Widget cho nút đăng xuất
  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout, color: Colors.red),
      label: Text(
        'Đăng xuất',
        style: GoogleFonts.beVietnamPro(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        // Hiển thị dialog xác nhận trước khi đăng xuất
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Xác nhận đăng xuất'),
              content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Hủy'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Đăng xuất'),
                  onPressed: () {
                    // TODO: Thêm logic đăng xuất ở đây
                    Navigator.of(context).pop(); // Đóng dialog
                    // Điều hướng về màn hình đăng nhập
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TroGuApp()),);
                  },
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}

// Màn hình placeholder để tạo bài đăng mới (CLASS MỚI)
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  // Các biến để lưu trạng thái của form
  bool _allowPets = false;
  bool _unlimitedHours = true;
  final Set<String> _selectedUtilities = {};

  // Danh sách các tiện ích
  final List<String> _utilities = ['Wifi', 'Máy lạnh', 'Tủ lạnh', 'Chỗ để xe', 'Máy giặt', 'Bếp', 'Gác lửng'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Tạo tin đăng mới', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.grey[800])),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Điều hướng đến màn hình quản lý tin đã đăng
            },
            child: Text('Quản lý tin', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.teal)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Các phần của form
              _buildSectionTitle('Hình ảnh phòng trọ'),
              _buildImageUploader(),
              const SizedBox(height: 24),

              _buildSectionTitle('Thông tin cơ bản'),
              _buildTextField(label: 'Tiêu đề tin đăng', hint: 'Ví dụ: Phòng trọ gần trường ĐH...'),
              _buildTextField(label: 'Địa chỉ chi tiết', hint: 'Số nhà, tên đường, phường/xã, quận/huyện...'),
              _buildTextField(label: 'Mô tả chi tiết', hint: 'Mô tả thêm về phòng, khu vực xung quanh...', maxLines: 4),
              const SizedBox(height: 24),

              _buildSectionTitle('Chi phí & Diện tích'),
              Row(
                children: [
                  Expanded(child: _buildTextField(label: 'Giá phòng', hint: 'VNĐ/tháng', keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(label: 'Diện tích', hint: 'm²', keyboardType: TextInputType.number)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField(label: 'Tiền cọc', hint: 'VNĐ', keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(label: 'Phí dịch vụ khác', hint: 'VNĐ/tháng (nếu có)', keyboardType: TextInputType.number)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField(label: 'Giá điện', hint: 'VNĐ/kWh', keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(label: 'Giá nước', hint: 'VNĐ/m³', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Tiện ích có sẵn'),
              _buildUtilityChips(),
              const SizedBox(height: 24),

              _buildSectionTitle('Quy định & Nội quy'),
              _buildSwitchTile(title: 'Cho phép nuôi thú cưng', value: _allowPets, onChanged: (val) => setState(() => _allowPets = val)),
              _buildSwitchTile(title: 'Giờ giấc tự do (không giới hạn)', value: _unlimitedHours, onChanged: (val) => setState(() => _unlimitedHours = val)),
              const SizedBox(height: 32),

              _buildPostButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho tiêu đề mỗi phần
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
      ),
    );
  }

  // Widget cho các trường nhập liệu
  Widget _buildTextField({required String label, required String hint, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng không để trống mục này';
          }
          return null;
        },
      ),
    );
  }

  // Widget cho khu vực tải ảnh
  Widget _buildImageUploader() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: Colors.grey[600], size: 40),
            const SizedBox(height: 8),
            Text('Nhấn để tải lên ít nhất 1 ảnh', style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
      // TODO: Thêm logic để chọn ảnh từ thư viện (sử dụng package image_picker)
    );
  }

  // Widget cho các chip tiện ích
  Widget _buildUtilityChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _utilities.map((utility) {
        final isSelected = _selectedUtilities.contains(utility);
        return FilterChip(
          label: Text(utility),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedUtilities.add(utility);
              } else {
                _selectedUtilities.remove(utility);
              }
            });
          },
          selectedColor: Colors.teal[100],
          checkmarkColor: Colors.teal[800],
          shape: StadiumBorder(side: BorderSide(color: Colors.grey[300]!)),
        );
      }).toList(),
    );
  }

  // Widget cho các nút gạt
  Widget _buildSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SwitchListTile(
        title: Text(title, style: GoogleFonts.beVietnamPro()),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.teal,
      ),
    );
  }

  // Widget cho nút đăng tin
  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('ĐĂNG TIN NGAY'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // TODO: Logic xử lý đăng tin
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đang xử lý đăng tin...')),
            );
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
      ),
    );
  }
}