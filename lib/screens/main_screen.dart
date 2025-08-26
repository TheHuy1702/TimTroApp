import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'my_acc_screen.dart';
import 'save_screen.dart';

// Giả lập một model cho bài đăng phòng trọ
class RoomPost {
  final String id;
  final List<String> imageUrls;
  final String title;
  final String price;
  final String area;
  final String address;
  final int compatibility; // Điểm tương thích "Gu"
  bool isSaved;

  RoomPost({
    required this.id,
    required this.imageUrls,
    required this.title,
    required this.price,
    required this.area,
    required this.address,
    required this.compatibility,
    this.isSaved = false,
  });
}

// Dữ liệu giả lập để hiển thị
final List<RoomPost> mockRoomPosts = [
  RoomPost(
    id: '1',
    imageUrls: [
      'https://placehold.co/600x400/a7d7c5/ffffff?text=Ph%C3%B2ng+1',
      'https://placehold.co/600x400/f5c0c0/ffffff?text=Ph%C3%B2ng+2',
      'https://placehold.co/600x400/7a9d96/ffffff?text=Ph%C3%B2ng+3',
    ],
    title: 'Phòng trọ studio full nội thất gần ĐH HUTECH',
    price: '4.5 triệu/tháng',
    area: '25m²',
    address: 'Q. Bình Thạnh, TP.HCM',
    compatibility: 95,
    isSaved: false,
  ),
  RoomPost(
    id: '2',
    imageUrls: [
      'https://placehold.co/600x400/e0a9a9/ffffff?text=Ph%C3%B2ng+Xinh',
    ],
    title: 'Gác lửng cửa sổ trời, giờ giấc tự do, cho nuôi pet',
    price: '3.8 triệu/tháng',
    area: '22m²',
    address: 'Q. Phú Nhuận, TP.HCM',
    compatibility: 88,
    isSaved: true,
  ),
  RoomPost(
    id: '3',
    imageUrls: [
      'https://placehold.co/600x400/c1d4d9/ffffff?text=Tr%E1%BB%8D+Y%C3%AAn+T%C4%A9nh',
      'https://placehold.co/600x400/a2b8c2/ffffff?text=G%C3%B3c+H%E1%BB%8Dc+T%E1%BA%ADp',
    ],
    title: 'Phòng yên tĩnh, an ninh, gần khu văn phòng',
    price: '4.0 triệu/tháng',
    area: '20m²',
    address: 'Quận 3, TP.HCM',
    compatibility: 82,
    isSaved: false,
  ),
];


// Màn hình chính chứa Bottom Navigation Bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với các tab
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SavedScreen(), // Màn hình tin đã lưu
    ProfileScreen(), // Màn hình tài khoản
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Đã lưu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[600],
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Widget cho màn hình Trang chủ (Tab 1)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Hàm để hiển thị bộ lọc
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép bottom sheet cao hơn nửa màn hình
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Trả về widget bộ lọc
        return const FilterBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Tìm kiếm phòng trọ',
          style: GoogleFonts.beVietnamPro(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_outlined, color: Colors.grey[700]),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        children: [
          _buildSearchBarAndFilter(context),
          _buildPostList(),
        ],
      ),
    );
  }

  // Widget cho thanh tìm kiếm và bộ lọc (ĐÃ CẬP NHẬT)
  Widget _buildSearchBarAndFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo quận, đường...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nút bộ lọc
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(12.0),
            ),
            icon: Icon(Icons.filter_list, color: Colors.teal[600]),
            onPressed: () {
              // Gọi hàm hiển thị bộ lọc khi nhấn nút
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: mockRoomPosts.length,
      itemBuilder: (context, index) {
        return RoomPostCard(post: mockRoomPosts[index]);
      },
    );
  }
}

// Widget cho một thẻ bài đăng phòng trọ
class RoomPostCard extends StatefulWidget {
  final RoomPost post;

  const RoomPostCard({super.key, required this.post});

  @override
  State<RoomPostCard> createState() => _RoomPostCardState();
}

class _RoomPostCardState extends State<RoomPostCard> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = widget.post.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(),
          _buildPostInfo(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              itemCount: widget.post.imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.post.imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: InkWell(
            onTap: () {
              setState(() {
                isSaved = !isSaved;
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Hợp gu ${widget.post.compatibility}%',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.post.price,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(Icons.straighten_outlined, widget.post.area),
              const SizedBox(width: 16),
              _infoChip(Icons.location_on_outlined, widget.post.address),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 18),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}


// CLASS GIAO DIỆN BỘ LỌC
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _currentPriceRange = const RangeValues(1, 10); // 1 triệu đến 10 triệu
  String _selectedLocation = "Tất cả khu vực";
  final Set<String> _selectedUtilities = {};
  String _sortBy = 'Hợp gu nhất';

  final List<String> _utilities = ['Máy lạnh', 'Chỗ để xe', 'Wifi', 'Giờ tự do', 'Cho nuôi pet'];
  final List<String> _sortOptions = ['Hợp gu nhất', 'Giá tăng dần', 'Giá giảm dần', 'Mới nhất'];

  @override
  Widget build(BuildContext context) {
    // Làm cho bottom sheet chiếm 85% chiều cao màn hình
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  'Bộ lọc & Sắp xếp',
                  style: GoogleFonts.beVietnamPro(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _buildSectionTitle('Khoảng giá (triệu VNĐ)'),
                    _buildPriceSlider(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Khu vực'),
                    _buildLocationSelector(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Tiện ích'),
                    _buildUtilityChips(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Sắp xếp theo'),
                    _buildSortOptions(),
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800]),
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      children: [
        RangeSlider(
          values: _currentPriceRange,
          min: 0,
          max: 20, // Giá tối đa 20 triệu
          divisions: 20,
          activeColor: Colors.teal,
          labels: RangeLabels(
            '${_currentPriceRange.start.toStringAsFixed(1)} tr',
            '${_currentPriceRange.end.toStringAsFixed(1)} tr',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentPriceRange = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_currentPriceRange.start.toStringAsFixed(1)} triệu'),
              Text('${_currentPriceRange.end.toStringAsFixed(1)} triệu'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLocationSelector() {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      leading: Icon(Icons.location_on_outlined, color: Colors.grey[600]),
      title: Text(
        _selectedLocation,
        style: GoogleFonts.beVietnamPro(),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Điều hướng đến màn hình chọn vị trí mới
        // Màn hình này sẽ có danh sách Tỉnh/Thành phố, sau đó là Quận/Huyện...
        // Sau khi người dùng chọn xong, kết quả sẽ được cập nhật lại vào biến _selectedLocation
        print('Mở màn hình chọn vị trí');
      },
    );
  }

  Widget _buildUtilityChips() {
    return Wrap(
      spacing: 8.0,
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
        );
      }).toList(),
    );
  }

  Widget _buildSortOptions() {
    return Column(
      children: _sortOptions.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _sortBy,
          onChanged: (String? value) {
            setState(() {
              _sortBy = value!;
            });
          },
          activeColor: Colors.teal,
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentPriceRange = const RangeValues(1, 10);
                  _selectedLocation = "Tất cả khu vực";
                  _selectedUtilities.clear();
                  _sortBy = 'Hợp gu nhất';
                });
              },
              child: const Text('Đặt lại'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.grey[800],
                side: BorderSide(color: Colors.grey[400]!),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Áp dụng bộ lọc và quay lại trang chủ
                Navigator.pop(context);
              },
              child: const Text('Áp dụng'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

