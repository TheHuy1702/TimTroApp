import 'package:firebase_auth/firebase_auth.dart';

// Lớp này chịu trách nhiệm cho tất cả các tương tác với Firebase Authentication.
class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  // Constructor, có thể nhận một instance của FirebaseAuth để dễ dàng kiểm thử (testing).
  // Nếu không cung cấp, nó sẽ tự tạo một instance mới.
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Hàm xử lý đăng nhập với Email và Mật khẩu
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Gọi hàm đăng nhập của Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      // KIỂM TRA QUAN TRỌNG: Email đã được xác thực chưa?
      if (user != null && !user.emailVerified) {
        // Nếu chưa, đăng xuất người dùng ra và ném ra một lỗi tùy chỉnh.
        // Giao diện sẽ bắt lỗi này và hiển thị thông báo.
        await _firebaseAuth.signOut();
        throw Exception('Vui lòng xác thực email của bạn trước khi đăng nhập.');
      }

      // Nếu mọi thứ ổn, trả về đối tượng User
      return user;

    } on FirebaseAuthException {
      // Nếu có lỗi từ Firebase (sai mật khẩu, không tìm thấy user...),
      // chỉ cần ném lại lỗi đó để giao diện xử lý.
      rethrow;
    } catch (e) {
      // Bắt các lỗi không mong muốn khác
      throw Exception('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
    }
  }
  // đăng ký
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Sau khi đăng ký có thể gửi mail xác thực
      await userCredential.user?.sendEmailVerification();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }



// TODO: Thêm các hàm khác ở đây, ví dụ:
// Future<void> signOut() async { ... }
// Future<User?> registerWithEmailAndPassword(...) { ... }
}
