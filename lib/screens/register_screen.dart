import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/auth_repository.dart';

// Để chạy riêng màn hình này, bạn có thể dùng hàm main sau:
void main() {
  runApp(MaterialApp(
    title: 'Trọ Gu',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      textTheme: GoogleFonts.beVietnamProTextTheme(),
    ),
    home: const RegisterScreen(),
  ));
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller cho các trường nhập liệu
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Biến trạng thái
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildHeader(),
                const SizedBox(height: 48.0),
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
                const SizedBox(height: 16.0),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Số điện thoại',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (value.length !=10 && (value.startsWith("09")|value.startsWith("08")|value.startsWith("07")|value.startsWith("05")|value.startsWith("03"))) {
                      return 'Vui lòng nhập số điện thoại hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    // Kiểm tra định dạng email đơn giản
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Vui lòng nhập email hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  isVisible: _isPasswordVisible,
                  onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu',
                  isVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (value != _passwordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                _buildTermsAndConditions(),
                const SizedBox(height: 24.0),
                _buildRegisterButton(),
                const SizedBox(height: 32.0),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Tạo tài khoản mới',
          style: GoogleFonts.beVietnamPro(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bắt đầu hành trình tìm trọ hợp gu!',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enableIMEPersonalizedLearning: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
    );
  }


  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      enableIMEPersonalizedLearning: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (bool? value) {
              setState(() {
                _agreedToTerms = value!;
              });
            },
            activeColor: Colors.teal,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.beVietnamPro(color: Colors.grey[600]),
              children: [
                const TextSpan(text: 'Tôi đồng ý với các '),
                TextSpan(
                  text: 'Điều khoản Dịch vụ',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: Mở trang Điều khoản Dịch vụ
                      print('Mở Điều khoản Dịch vụ');
                    },
                ),
                const TextSpan(text: ' và '),
                TextSpan(
                  text: 'Chính sách Bảo mật',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: Mở trang Chính sách Bảo mật
                      print('Mở Chính sách Bảo mật');
                    },
                ),
                const TextSpan(text: ' của Trọ Gu.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (!_agreedToTerms) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng đồng ý với các điều khoản')),
            );
            return;
          }

          try {
            final authRepo = AuthRepository();
            final user = await authRepo.registerWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            if (user != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đăng ký thành công, vui lòng kiểm tra email để xác thực.')),
              );
              // Sau 3 giây thì chuyển sang màn hình đăng nhập
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pop(); // quay về màn hình login
                // hoặc nếu bạn có LoginScreen thì:
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                // );
              });
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
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
      child: const Text('ĐĂNG KÝ'),

    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: TextStyle(color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: () {
            // Quay lại màn hình đăng nhập
            Navigator.of(context).pop();
          },
          child: Text(
            'Đăng nhập ngay',
            style: TextStyle(
              color: Colors.teal[600],
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
