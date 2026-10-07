import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Điểm khởi chạy ứng dụng (Entry point)
void main() {
  runApp(const DigitalBusinessCardApp());
}

/// [DigitalBusinessCardApp] - Widget gốc cấu hình theme và Material 3.
class DigitalBusinessCardApp extends StatelessWidget {
  const DigitalBusinessCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Business Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Indigo / Navy chuyên nghiệp
          brightness: Brightness.light,
        ),
      ),
      home: const ProfileScreen(),
    );
  }
}

/// [ProfileScreen] - Màn hình hồ sơ cá nhân chính
/// Hỗ trợ cả 2 lựa chọn Background Gradient:
/// - Lựa chọn 1: Light Modern / Soft Tech (Xanh pastel -> Trắng kem)
/// - Lựa chọn 2: Deep Tech / Dark Slate (Xanh than -> Xám đen sang trọng)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Trạng thái giao diện:
  // false: Lựa chọn 1 (Light Modern / Soft Tech)
  // true:  Lựa chọn 2 (Deep Tech / Dark Slate)
  bool _isDarkTheme = false;

  // ===========================================================================
  // XỬ LÝ INTENT QUA URL_LAUNCHER (TƯƠNG ĐƯƠNG ANDROID INTENT)
  // ===========================================================================
  static Future<void> _handleLaunch(
    BuildContext context,
    String urlString, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    final Uri? uri = Uri.tryParse(urlString);

    if (uri == null) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Đường dẫn không hợp lệ: $urlString');
      }
      return;
    }

    try {
      final bool canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: mode);
      } else {
        if (context.mounted) {
          _showErrorSnackBar(
            context,
            'Không tìm thấy ứng dụng phù hợp để mở liên kết này.',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Có lỗi xảy ra: ${e.toString()}');
      }
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Đường dẫn ảnh đại diện cá nhân (để chuỗi rỗng '' nếu muốn dùng icon mặc định)
    const String avatarUrl =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80';
    final bool hasAvatarImage = avatarUrl.trim().isNotEmpty;

    // =========================================================================
    // HỆ THỐNG MÀU SẮC ĐỒNG BỘ THEO NỀN (COLOR PALETTE CONFIGURATION)
    // =========================================================================
    // 1. Dải màu nền Gradient toàn màn hình
    final List<Color> bgGradientColors = _isDarkTheme
        ? const [
            Color(0xFF0B1120), // Xanh đen vũ trụ (Midnight Tech)
            Color(0xFF0F172A), // Slate-900 xanh than sâu
            Color(0xFF1E293B), // Slate-800 xám đen sang trọng
          ]
        : const [
            Color(0xFFEBF4FF), // Xanh pastel rất nhạt (#EBF4FF)
            Color(0xFFF1F5F9), // Slate-100 chuyển mềm dịu
            Color(0xFFF8FAFC), // Trắng kem hiện đại (#F8FAFC)
          ];

    // 2. Màu chữ Họ & Tên
    final Color nameTextColor = _isDarkTheme
        ? const Color(0xFFF8FAFC) // Trắng Slate-50 rực sáng trên nền tối
        : const Color(0xFF0F172A); // Slate-900 đen than sắc nét trên nền sáng

    // 3. Màu chữ Chức danh / Chuyên ngành
    final Color titleTextColor = _isDarkTheme
        ? const Color(0xFF38BDF8) // Sky Blue (#38BDF8) sáng nét, công nghệ cao
        : const Color(0xFF1E3A8A); // Deep Navy (#1E3A8A) sắc sảo, đĩnh đạc

    // 4. Màu chữ Tiểu sử (Bio)
    final Color bioTextColor = _isDarkTheme
        ? const Color(0xFFCBD5E1) // Slate-300 xám bạc sáng, tương phản vượt trội
        : const Color(0xFF334155); // Slate-700 than đậm, rất dễ đọc

    // 5. Viền & Bóng đổ của Avatar
    final List<Color> avatarBorderGradient = _isDarkTheme
        ? const [
            Color(0xFF38BDF8), // Sky Blue viền sáng
            Color(0xFF818CF8), // Indigo Violet ánh tím điện tử
          ]
        : const [
            Color(0xFF1E3A8A), // Deep Navy
            Color(0xFF3B82F6), // Electric Cobalt
          ];

    final List<BoxShadow> avatarBoxShadow = _isDarkTheme
        ? [
            BoxShadow(
              color: const Color(0xFF38BDF8).withOpacity(0.35),
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF818CF8).withOpacity(0.20),
              blurRadius: 36,
              offset: const Offset(0, 12),
            ),
          ]
        : [
            BoxShadow(
              color: const Color(0xFF1E3A8A).withOpacity(0.20),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ];

    // 6. Màu sắc Thẻ liên hệ Contact Card (Glassmorphism & Contrast)
    final Color cardBgColor = _isDarkTheme
        ? const Color(0xFF1E293B).withOpacity(0.85) // Nền kính tối mờ cao cấp
        : Colors.white.withOpacity(0.92); // Nền kính trắng mờ tinh khôi

    final Color cardBorderColor = _isDarkTheme
        ? const Color(0xFF334155) // Viền xám xanh sáng
        : const Color(0xFFE2E8F0); // Viền xám sáng nhẹ

    final Color cardTitleColor = _isDarkTheme
        ? const Color(0xFFF1F5F9) // Trắng xám sáng
        : const Color(0xFF1E293B); // Xám đen

    final Color cardSubtitleColor = _isDarkTheme
        ? const Color(0xFF94A3B8) // Slate-400
        : const Color(0xFF64748B); // Slate-500

    final Color dividerColor = _isDarkTheme
        ? const Color(0xFF334155)
        : const Color(0xFFCBD5E1);

    // =========================================================================
    // 1. KIẾN TRÚC BỐ CỤC:
    // - Scaffold với Container bao trọn toàn màn hình (width/height: double.infinity).
    // - BoxDecoration(gradient: LinearGradient(...)) tạo chiều sâu không gian.
    // - SafeArea & SingleChildScrollView chống tràn viền tuyệt đối (Zero Overflow).
    // =========================================================================
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Nút chuyển đổi nhanh Dark / Light Mode ở góc trên bên phải
              Positioned(
                top: 8,
                right: 16,
                child: IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      _isDarkTheme = !_isDarkTheme;
                    });
                  },
                  icon: Icon(
                    _isDarkTheme
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    size: 20,
                  ),
                  tooltip: _isDarkTheme
                      ? 'Chuyển sang nền Sáng (Soft Tech)'
                      : 'Chuyển sang nền Tối (Deep Tech)',
                  style: IconButton.styleFrom(
                    backgroundColor: _isDarkTheme
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    foregroundColor: _isDarkTheme
                        ? const Color(0xFFF8FAFC)
                        : const Color(0xFF0F172A),
                  ),
                ),
              ),

              // Vùng nội dung cuộn chính
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Khoảng đệm phía trên để cân bằng với nút Theme Switcher
                        const SizedBox(height: 20),

                        // =====================================================
                        // 2. KHU VỰC ẢNH ĐẠI DIỆN (AVATAR VỚI BẢNG MÀU MỚI)
                        // =====================================================
                        Container(
                          padding: const EdgeInsets.all(4.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: avatarBorderGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: avatarBoxShadow,
                          ),
                          child: CircleAvatar(
                            radius: 64, // Đường kính 128dp
                            backgroundColor: _isDarkTheme
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            backgroundImage: hasAvatarImage
                                ? const NetworkImage(avatarUrl)
                                : null,
                            onBackgroundImageError: hasAvatarImage
                                ? (exception, stackTrace) {
                                    debugPrint('Lỗi tải ảnh: $exception');
                                  }
                                : null,
                            child: hasAvatarImage
                                ? null
                                : Icon(
                                    Icons.person,
                                    size: 64,
                                    color: _isDarkTheme
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // =====================================================
                        // 3. THÔNG TIN CÁ NHÂN (TƯƠNG PHẢN CHUẨN THEO NỀN)
                        // =====================================================
                        // Họ và tên
                        Text(
                          'linhdontcare',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: nameTextColor,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 6),

                        // Chức danh / Chuyên ngành
                        Text(
                          'SENIOR FLUTTER / ANDROID DEVELOPER',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: titleTextColor,
                            letterSpacing: 1.8,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 14),

                        // Tiểu sử (Bio)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Đam mê xây dựng ứng dụng di động hiệu năng cao với kiến trúc Clean Architecture, '
                            'giao diện mượt mà 60/120fps và trải nghiệm người dùng tinh tế.',
                            style: TextStyle(
                              fontSize: 14,
                              color: bioTextColor,
                              height: 1.55,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Divider phân cách
                        SizedBox(
                          width: 160,
                          child: Divider(
                            thickness: 1.5,
                            color: dividerColor,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =====================================================
                        // 4. DANH SÁCH THẺ LIÊN HỆ (INTERACTION CARDS)
                        // =====================================================
                        // Card 1: GitHub Profile
                        _ContactCard(
                          icon: Icons.code_rounded,
                          iconColor: _isDarkTheme
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF24292F),
                          title: 'GitHub Profile',
                          subtitle: 'github.com/linhdontcare',
                          cardBgColor: cardBgColor,
                          cardBorderColor: cardBorderColor,
                          titleColor: cardTitleColor,
                          subtitleColor: cardSubtitleColor,
                          onTap: () => _handleLaunch(
                            context,
                            'https://github.com',
                            mode: LaunchMode.externalApplication,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Card 2: LinkedIn
                        _ContactCard(
                          icon: Icons.work_outline_rounded,
                          iconColor: const Color(0xFF0A66C2),
                          title: 'LinkedIn',
                          subtitle: 'linkedin.com/in/linhdontcare',
                          cardBgColor: cardBgColor,
                          cardBorderColor: cardBorderColor,
                          titleColor: cardTitleColor,
                          subtitleColor: cardSubtitleColor,
                          onTap: () => _handleLaunch(
                            context,
                            'https://linkedin.com',
                            mode: LaunchMode.externalApplication,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Card 3: Email
                        _ContactCard(
                          icon: Icons.alternate_email_rounded,
                          iconColor: const Color(0xFFEA4335),
                          title: 'Gửi Email',
                          subtitle: 'linhdontcare435@gmail.com',
                          cardBgColor: cardBgColor,
                          cardBorderColor: cardBorderColor,
                          titleColor: cardTitleColor,
                          subtitleColor: cardSubtitleColor,
                          onTap: () => _handleLaunch(
                            context,
                            'mailto:linhdontcare435@gmail.com?subject=Trao%20đổi%20cơ%20hội%20hợp%20tác&body=Chào%20An,',
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Card 4: Số điện thoại
                        _ContactCard(
                          icon: Icons.phone_in_talk_rounded,
                          iconColor: const Color(0xFF10B981),
                          title: 'Gọi điện thoại',
                          subtitle: '+84 999666999',
                          cardBgColor: cardBgColor,
                          cardBorderColor: cardBorderColor,
                          titleColor: cardTitleColor,
                          subtitleColor: cardSubtitleColor,
                          onTap: () =>
                              _handleLaunch(context, 'tel:+84999666999'),
                        ),

                        const SizedBox(height: 28),

                        // =====================================================
                        // 5. CÁC NÚT HÀNH ĐỘNG NHANH (QUICK ACTIONS)
                        // =====================================================
                        Row(
                          children: [
                            // Nút 1: Xem CV
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _handleLaunch(
                                  context,
                                  'https://flutter.dev',
                                  mode: LaunchMode.externalApplication,
                                ),
                                icon: const Icon(
                                  Icons.file_download_outlined,
                                  size: 20,
                                ),
                                label: const Text('Xem CV'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: _isDarkTheme
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF1E3A8A),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Nút 2: Nhắn tin SMS
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _handleLaunch(context, 'sms:+84999666999'),
                                icon: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 20,
                                ),
                                label: const Text('Nhắn tin'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _isDarkTheme
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFF1E3A8A),
                                  side: BorderSide(
                                    color: _isDarkTheme
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF1E3A8A),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [_ContactCard] - Thành phần thẻ tương tác tùy biến theo Theme
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color cardBgColor;
  final Color cardBorderColor;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.cardBgColor,
    required this.cardBorderColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cardBorderColor, width: 1.2),
      ),
      color: cardBgColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.12),
        highlightColor: iconColor.withOpacity(0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              // Hộp icon bo tròn
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),

              // Cột chứa Tiêu đề và Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Mũi tên điều hướng
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: subtitleColor.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
