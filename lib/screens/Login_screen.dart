import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import các thư viện Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import các màn hình khác và repository
// TODO: Đảm bảo các đường dẫn import này đúng với cấu trúc thư mục của bạn
import 'main_screen.dart';
import 'register_screen.dart';
import '../repositories/auth_repository.dart';

// TODO: Thêm file firebase_options.dart được tạo tự động bởi FlutterFire CLI
// import 'firebase_options.dart';

// Hàm main để khởi tạo Firebase và chạy app
void main() async {
  // Đảm bảo Flutter đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Bỏ comment dòng dưới sau khi đã cấu hình Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const TroGuApp());
}

class TroGuApp extends StatelessWidget {
  const TroGuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tìm trọ Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.beVietnamProTextTheme(
          Theme.of(context).textTheme,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Tạo một instance của AuthRepository để xử lý logic
  final AuthRepository _authRepository = AuthRepository();

  // Các biến trạng thái của giao diện
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hàm xử lý đăng nhập - Gọi đến Repository
  Future<void> _handleLogin() async {
    // 1. Kiểm tra validation của Form
    if (!_formKey.currentState!.validate()) return;

    // 2. Cập nhật giao diện để hiển thị trạng thái loading
    setState(() {
      _isLoading = true;
    });

    try {
      // 3. Gọi hàm đăng nhập từ repository
      final user = await _authRepository.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 4. Xử lý kết quả trả về
      if (user != null && mounted) {
        // Nếu thành công, điều hướng đến màn hình chính
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Bắt lỗi từ Firebase và hiển thị thông báo
      String message = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Email hoặc mật khẩu không chính xác.';
      }
      _showErrorSnackBar(message);
    } catch (e) {
      // Bắt các lỗi tùy chỉnh khác (ví dụ: email chưa xác thực từ repository)
      _showErrorSnackBar(e.toString().replaceFirst('Exception: ', ''));
    }

    // 5. Dừng trạng thái loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm helper để hiển thị SnackBar lỗi
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
                _buildEmailField(),
                const SizedBox(height: 16.0),
                _buildPasswordField(),
                const SizedBox(height: 16.0),
                _buildForgotPasswordButton(),
                const SizedBox(height: 24.0),
                _buildLoginButton(),
                const SizedBox(height: 32.0),
                _buildSocialLoginDivider(),
                const SizedBox(height: 24.0),
                _buildSocialLoginButtons(),
                const SizedBox(height: 48.0),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Các hàm build widget giao diện (giữ nguyên không đổi)
  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.home_work_outlined,
          size: 80,
          color: Colors.teal[400],
        ),
        const SizedBox(height: 16),
        Text(
          'Chào mừng đến với Tìm trọ Online',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tìm phòng trọ phù hợp, không cần lo về chất lượng',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email hoặc số điện thoại',
        prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập email hoặc số điện thoại';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        if (value.length < 6) {
          return 'Mật khẩu phải có ít nhất 6 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Điều hướng đến màn hình Quên mật khẩu
          print('Nút Quên mật khẩu được nhấn');
        },
        child: Text(
          'Quên mật khẩu?',
          style: TextStyle(color: Colors.teal[600], fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin, // Gọi hàm xử lý logic
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[400],
        disabledBackgroundColor: Colors.teal[200],
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
        shadowColor: Colors.teal[200],
      ),
      child: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      )
          : const Text(
        'ĐĂNG NHẬP',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSocialLoginDivider() {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Hoặc đăng nhập với',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _socialButton(
          'assets/google_logo.png',
          onTap: () {
            // TODO: Logic đăng nhập Google
            print('Đăng nhập Google');
          },
        ),
        const SizedBox(width: 24),
        _socialButton(
          'assets/facebook_logo.png',
          onTap: () {
            // TODO: Logic đăng nhập Facebook
            print('Đăng nhập Facebook');
          },
        ),
      ],
    );
  }

  Widget _socialButton(String assetPath, {required VoidCallback onTap}) {
    Widget iconWidget;
    if (assetPath.contains('google')) {
      iconWidget = Image.asset('assets/google.png', height: 24, width: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.red, size: 30));
    } else {
      iconWidget = Image.asset('assets/facebook.png', height: 24, width: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.facebook, color: Colors.blue, size: 30));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: iconWidget,
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Chưa có tài khoản? ',
          style: TextStyle(color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),);
          },
          child: Text(
            'Đăng ký ngay',
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
