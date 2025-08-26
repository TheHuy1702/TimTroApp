import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Login_screen.dart';

// Giả sử đây là màn hình đăng nhập của bạn
// import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tìm Trọ Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.beVietnamProTextTheme(),
      ),
      // Điểm bắt đầu của ứng dụng sẽ là SplashScreen
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Bắt đầu hàm điều hướng sau khi màn hình được build
    _navigateToHome();
  }

  // Hàm xử lý việc chờ và điều hướng
  _navigateToHome() async {
    // Chờ 3 giây
    await Future.delayed(const Duration(seconds: 3), () {});

    // Sau khi chờ, chuyển đến màn hình Đăng nhập.
    // pushReplacementNamed sẽ thay thế màn hình hiện tại,
    // người dùng không thể nhấn back để quay lại SplashScreen.
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Thay bằng màn hình đăng nhập thật
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sử dụng màu nền chính của theme
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo của ứng dụng
            Icon(
              Icons.home_work_outlined,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            // Tên ứng dụng
            Text(
              'Tìm Trọ Online',
              style: GoogleFonts.beVietnamPro(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            // Slogan/Tagline
            Text(
              'Tìm phòng trọ hợp gu, ở là mê!',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 80),
            // Vòng quay loading để cho người dùng biết app đang xử lý
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
