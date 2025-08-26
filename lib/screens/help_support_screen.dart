import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Để sử dụng chức năng gọi điện/gửi mail, bạn cần thêm package url_launcher
// vào file pubspec.yaml:
// dependencies:
//   url_launcher: ^6.2.6
// import 'package:url_launcher/url_launcher.dart';

// Để chạy riêng màn hình này, bạn có thể dùng hàm main sau:
void main() {
  runApp(MaterialApp(
    title: 'Trọ Gu',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      textTheme: GoogleFonts.beVietnamProTextTheme(),
    ),
    home: const HelpAndSupportScreen(),
  ));
}

// Model để chứa cặp câu hỏi và câu trả lời
class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  // Dữ liệu gốc được khai báo là static const để tối ưu hiệu năng
  static const List<FaqItem> _tenantFaqs = [
    FaqItem(
      question: 'Làm thế nào để tìm phòng trọ phù hợp với "Gu"?',
      answer:
      'Bạn chỉ cần vào trang "Tài khoản" -> "Chỉnh sửa thông tin" và cập nhật phần "Giới thiệu bản thân (Gu của bạn)". Hệ thống sẽ tự động tính điểm tương thích và gợi ý các phòng phù hợp nhất với bạn.',
    ),
    FaqItem(
      question: 'Làm sao để liên hệ với chủ nhà?',
      answer:
      'Trong trang chi tiết của mỗi bài đăng, sẽ có nút "Gọi điện" hoặc "Nhắn tin" để bạn có thể liên hệ trực tiếp với chủ nhà một cách dễ dàng.',
    ),
    FaqItem(
      question: 'Làm sao để báo cáo một tin đăng không đúng sự thật?',
      answer:
      'Ở cuối mỗi trang chi tiết bài đăng, có một nút "Báo cáo tin đăng này". Vui lòng chọn lý do báo cáo và gửi cho chúng tôi. Đội ngũ Trọ Gu sẽ xem xét và xử lý trong thời gian sớm nhất.',
    ),
  ];

  static const List<FaqItem> _landlordFaqs = [
    FaqItem(
      question: 'Làm thế nào để đăng một tin cho thuê mới?',
      answer:
      'Để đăng tin, bạn vào mục "Tài khoản" và chọn "Trở thành chủ nhà / Đăng tin". Sau đó, bạn chỉ cần điền đầy đủ thông tin theo biểu mẫu hướng dẫn.',
    ),
    FaqItem(
      question: 'Phí đăng tin và đẩy tin là bao nhiêu?',
      answer:
      'Việc đăng tin cơ bản là hoàn toàn miễn phí. Đối với các dịch vụ trả phí như "Đẩy tin" hoặc "Gói chuyên nghiệp", vui lòng tham khảo bảng giá chi tiết trong mục "Quản lý tin đăng" của bạn.',
    ),
    FaqItem(
      question: 'Làm sao để gỡ hoặc đánh dấu một tin là "Đã cho thuê"?',
      answer:
      'Trong mục "Quản lý tin đăng", bạn có thể dễ dàng thay đổi trạng thái của mỗi bài đăng từ "Còn phòng" sang "Đã cho thuê" hoặc gỡ tin hoàn toàn khỏi hệ thống.',
    ),
  ];

  // Các danh sách đã được lọc để hiển thị
  late List<FaqItem> _filteredTenantFaqs;
  late List<FaqItem> _filteredLandlordFaqs;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ban đầu, hiển thị tất cả câu hỏi
    _filteredTenantFaqs = _tenantFaqs;
    _filteredLandlordFaqs = _landlordFaqs;

    // Lắng nghe sự thay đổi trong thanh tìm kiếm
    _searchController.addListener(_filterFaqs);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFaqs);
    _searchController.dispose();
    super.dispose();
  }

  // Hàm lọc danh sách câu hỏi dựa trên từ khóa tìm kiếm
  void _filterFaqs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTenantFaqs = _tenantFaqs.where((faq) {
        return faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query);
      }).toList();

      _filteredLandlordFaqs = _landlordFaqs.where((faq) {
        return faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Hàm helper để hiển thị SnackBar thông báo lỗi
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Trợ giúp & Hỗ trợ',
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildFaqSection('Dành cho người tìm trọ', _filteredTenantFaqs),
          const SizedBox(height: 24),
          _buildFaqSection('Dành cho chủ nhà', _filteredLandlordFaqs),
          const SizedBox(height: 32),
          _buildContactSection(context),
        ],
      ),
    );
  }

  // Widget cho thanh tìm kiếm
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm câu hỏi của bạn...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Widget cho một phần câu hỏi thường gặp
  Widget _buildFaqSection(String title, List<FaqItem> faqs) {
    // Chỉ hiển thị section nếu có kết quả tìm kiếm
    if (faqs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(faqs[index].question, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                    child: Text(
                      faqs[index].answer,
                      style: GoogleFonts.beVietnamPro(color: Colors.grey[700], height: 1.5),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
          ),
        ),
      ],
    );
  }

  // Widget cho phần liên hệ
  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Không tìm thấy câu trả lời?',
          style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Vui lòng liên hệ với chúng tôi để được hỗ trợ trực tiếp.',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _contactButton(
                icon: Icons.email_outlined,
                label: 'Gửi Email',
                onTap: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'hotro.trogu@email.com', // Thay bằng email hỗ trợ của bạn
                    query: 'subject=${Uri.encodeComponent('Hỗ trợ người dùng ứng dụng Trọ Gu')}',
                  );
                  try {
                    // if (await canLaunchUrl(emailLaunchUri)) {
                    //   await launchUrl(emailLaunchUri);
                    // } else {
                      _showErrorSnackBar('Không thể mở ứng dụng email.');
                    // }
                  } catch (e) {
                    _showErrorSnackBar('Đã xảy ra lỗi: $e');
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _contactButton(
                icon: Icons.phone_in_talk_outlined,
                label: 'Gọi Hotline',
                onTap: () async {
                  final Uri phoneLaunchUri = Uri(
                    scheme: 'tel',
                    path: '19001234', // Thay bằng số hotline của bạn
                  );
                  try {
                    // if (await canLaunchUrl(phoneLaunchUri)) {
                    //   await launchUrl(phoneLaunchUri);
                    // } else {
                      _showErrorSnackBar('Không thể thực hiện cuộc gọi.');
                    // }
                  } catch (e) {
                    _showErrorSnackBar('Đã xảy ra lỗi: $e');
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  // Widget con cho một nút liên hệ
  Widget _contactButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[400],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
      ),
    );
  }
}
