import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const DigitalBusinessCardApp());
}

/// [DigitalBusinessCardApp] - Widget gốc cấu hình Theme và Khởi tạo ứng dụng
class DigitalBusinessCardApp extends StatelessWidget {
  const DigitalBusinessCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Business Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      home: const BusinessCardPage(),
    );
  }
}

/// [BusinessCardPage] - Màn hình Hồ sơ cá nhân (Pure StatelessWidget)
class BusinessCardPage extends StatelessWidget {
  const BusinessCardPage({super.key});

  /// Hàm thực tế mở trang web, ứng dụng mạng xã hội, cuộc gọi hoặc email thông qua Intent
  Future<void> _openIntent(
    BuildContext context,
    String platform,
    String urlString,
  ) async {
    final Uri uri = Uri.parse(urlString);

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể mở liên kết: $urlString'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể mở $platform: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // 1. SCAFFOLD & BACKGROUND
    // Sử dụng màu nền Deep Slate / Navy Teal (0xFF0A192F) tạo cảm giác sang trọng
    // =========================================================================
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      // =======================================================================
      // 2. SAFEAREA: Tránh tai thỏ, notch và thanh điều hướng hệ thống
      // =======================================================================
      body: SafeArea(
        // =====================================================================
        // TỐI ƯU HÓA CHO NHIỀU KÍCH THƯỚC MÀN HÌNH (SingleChildScrollView + ConstrainedBox)
        // =====================================================================
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650.0),
              // ===============================================================
              // BỐ CỤC CHÍNH (COLUMN - Tương đương LinearLayout vertical)
              // ===============================================================
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ===========================================================
                  // 1. ẢNH ĐẠI DIỆN (CircleAvatar - Tương đương ImageView)
                  // ===========================================================
                  const CircleAvatar(
                    radius: 62.0,
                    backgroundColor: Color(0xFF64FFDA), // Viền Neon Mint
                    child: CircleAvatar(
                      radius: 58.0,
                      backgroundColor: Color(0xFF172A45),
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // ===========================================================
                  // 2. HỌ VÀ TÊN (Text - Tương đương TextView)
                  // ===========================================================
                  const Text(
                    'linhdontcare',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 6.0),

                  // Chức danh nghề nghiệp
                  const Text(
                    'SENIOR FLUTTER DEVELOPER',
                    style: TextStyle(
                      color: Color(0xFF64FFDA),
                      fontSize: 14.0,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12.0),

                  // Đường kẻ ngăn cách
                  const SizedBox(
                    width: 150.0,
                    child: Divider(
                      color: Color(0x5964FFDA),
                      thickness: 1.0,
                      height: 20.0,
                    ),
                  ),

                  const SizedBox(height: 10.0),

                  // ===========================================================
                  // 3. THÔNG TIN LIÊN HỆ CƠ BẢN (Phone, Email, Location)
                  // Đặt ngay dưới Tên & Chức danh theo chuẩn Card thông tin
                  // ===========================================================
                  ContactCard(
                    icon: Icons.phone,
                    text: '+84 987 444 321',
                    onTap: () => _openIntent(
                      context,
                      'Cuộc gọi (tel:)',
                      'tel:+84987444321',
                    ),
                  ),

                  ContactCard(
                    icon: Icons.email_outlined,
                    text: 'linhdontcare.dev@gmail.com',
                    onTap: () => _openIntent(
                      context,
                      'Gửi Email (mailto:)',
                      'mailto:linhdontcare.dev@gmail.com',
                    ),
                  ),

                  const ContactCard(
                    icon: Icons.location_on_outlined,
                    text: 'Hà Nội, Việt Nam',
                  ),

                  // ===========================================================
                  // 4. TIỂU SỬ / GIỚI THIỆU BẢN THÂN (ABOUT ME)
                  // ===========================================================
                  const SectionHeader(
                    title: 'TIỂU SỬ BẢN THÂN',
                    icon: Icons.person_outline,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF112240),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: const Color(0x3364FFDA),
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'Lập trình viên Mobile đam mê biến ý tưởng thành những dòng code sạch và ứng dụng mượt mà. Tôn chỉ: Clean Code, tối ưu 60fps và luôn đặt trải nghiệm người dùng lên hàng đầu. 🚀',
                        style: TextStyle(
                          color: Color(0xFF8892B0),
                          fontSize: 14.5,
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  // ===========================================================
                  // 5. BUTTON CHO CÁC LIÊN KẾT MẠNG XÃ HỘI (Có xử lý Click / Intent)
                  // ===========================================================
                  const SectionHeader(
                    title: 'LIÊN KẾT MẠNG XÃ HỘI',
                    icon: Icons.link_rounded,
                  ),

                  // Nút 1: GitHub
                  SocialLinkButton(
                    title: 'GitHub Profile',
                    subtitle: 'github.com/linhdontcare',
                    icon: Icons.code_rounded,
                    onPressed: () => _openIntent(
                      context,
                      'GitHub',
                      'https://github.com/linhdontcare',
                    ),
                  ),

                  // Nút 2: LinkedIn
                  SocialLinkButton(
                    title: 'LinkedIn Network',
                    subtitle: 'linkedin.com/in/linhdontcare',
                    icon: Icons.business_center_outlined,
                    onPressed: () => _openIntent(
                      context,
                      'LinkedIn',
                      'https://www.linkedin.com/in/linhdontcare/',
                    ),
                  ),

                  // Nút 3: Facebook
                  SocialLinkButton(
                    title: 'Facebook Cá nhân',
                    subtitle: 'facebook.com/linhdontcare',
                    icon: Icons.share_rounded,
                    onPressed: () => _openIntent(
                      context,
                      'Facebook',
                      'https://facebook.com/linhdontcare',
                    ),
                  ),

                  // Nút 4: Instagram
                  SocialLinkButton(
                    title: 'Instagram',
                    subtitle: 'instagram.com/linhdontcare',
                    icon: Icons.camera_alt_rounded,
                    onPressed: () => _openIntent(
                      context,
                      'Instagram',
                      'https://www.instagram.com/linhdontcare',
                    ),
                  ),

                  // ===========================================================
                  // SECTION 6: WORK EXPERIENCE (KINH NGHIỆM LÀM VIỆC)
                  // ===========================================================
                  const SectionHeader(
                    title: 'WORK EXPERIENCE',
                    icon: Icons.work_outline,
                  ),

                  const ExperienceCard(
                    role: 'Senior Flutter Engineer',
                    company: 'TechCorp Solutions',
                    duration: '2023 - Hiện tại',
                    descriptions: [
                      'Dẫn dắt đội ngũ 6 kỹ sư xây dựng siêu ứng dụng Fintech phục vụ hơn 500.000 người dùng hàng tháng.',
                      'Tối ưu hóa thời gian khởi động ứng dụng giảm 35% và duy trì tỷ lệ crash dưới 0.1%.',
                      'Thiết lập quy trình tự động hóa CI/CD với GitHub Actions và Fastlane.',
                    ],
                  ),

                  const ExperienceCard(
                    role: 'Mobile Developer (Flutter / Dart)',
                    company: 'Innovate Mobile Studio',
                    duration: '2021 - 2023',
                    descriptions: [
                      'Phát triển và triển khai 5 ứng dụng E-commerce & Booking đa nền tảng lên App Store và Google Play.',
                      'Tích hợp cổng thanh toán trực tuyến (VNPay, MoMo, Stripe) và thông báo đẩy Firebase FCM.',
                      'Phối hợp với team UI/UX xây dựng animation mượt mà chuẩn 60fps.',
                    ],
                  ),

                  const ExperienceCard(
                    role: 'Junior Mobile Developer',
                    company: 'NextGen Software Ltd.',
                    duration: '2020 - 2021',
                    descriptions: [
                      'Tham gia phát triển các module chính trong ứng dụng mạng xã hội nội bộ cho doanh nghiệp.',
                      'Viết Unit Test và Widget Test nâng độ phủ code (test coverage) từ 40% lên 75%.',
                      'Refactor codebase, xử lý lỗi và bảo trì phiên bản ứng dụng trên iOS & Android.',
                    ],
                  ),

                  // ===========================================================
                  // SECTION 7: SKILLS & TECH STACK (CHIPS / BADGES)
                  // ===========================================================
                  const SectionHeader(
                    title: 'SKILLS & TECH STACK',
                    icon: Icons.code,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        SkillBadge(label: 'Flutter'),
                        SkillBadge(label: 'Dart'),
                        SkillBadge(label: 'Clean Architecture'),
                        SkillBadge(label: 'BLoC / Cubit'),
                        SkillBadge(label: 'Riverpod'),
                        SkillBadge(label: 'Firebase'),
                        SkillBadge(label: 'RESTful API'),
                        SkillBadge(label: 'GraphQL'),
                        SkillBadge(label: 'Git / GitHub'),
                        SkillBadge(label: 'CI/CD Pipeline'),
                        SkillBadge(label: 'Unit & Widget Test'),
                        SkillBadge(label: 'UI/UX & Animations'),
                        SkillBadge(label: 'Performance Tuning'),
                        SkillBadge(label: 'State Management'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// [SocialLinkButton] - Button liên kết mạng xã hội có xử lý Click (Intent)
/// ============================================================================
class SocialLinkButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialLinkButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF112240),
            foregroundColor: const Color(0xFF64FFDA),
            elevation: 3.0,
            shadowColor: Colors.black45,
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(color: Color(0x3364FFDA), width: 1.0),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0x1F64FFDA),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon, color: const Color(0xFF64FFDA), size: 22.0),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8892B0),
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.0,
                color: Color(0x9964FFDA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// [SectionHeader] - Tiêu đề từng phân đoạn với Icon Neon và đường kẻ phân tách
/// ============================================================================
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 28.0,
        bottom: 12.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF64FFDA), size: 20.0),
          const SizedBox(width: 10.0),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64FFDA),
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Container(height: 1.0, color: const Color(0x3364FFDA)),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// [ContactCard] - Card thông tin có hỗ trợ sự kiện Tap (Click)
/// ============================================================================
class ContactCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const ContactCard({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF112240),
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Color(0x3364FFDA), width: 1.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF64FFDA), size: 22.0),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFCCD6F6),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13.0,
                  color: Color(0x6664FFDA),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// [ExperienceCard] - Thẻ hiển thị công việc (Role, Công ty, Thời gian, Mô tả)
/// ============================================================================
class ExperienceCard extends StatelessWidget {
  final String role;
  final String company;
  final String duration;
  final List<String> descriptions;

  const ExperienceCard({
    super.key,
    required this.role,
    required this.company,
    required this.duration,
    required this.descriptions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF112240),
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Color(0x3364FFDA), width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        company,
                        style: const TextStyle(
                          color: Color(0xFF64FFDA),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x1F64FFDA),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: const Color(0x6664FFDA)),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Color(0xFF64FFDA),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ...descriptions.map(
              (desc) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5.0, right: 8.0),
                      child: Icon(
                        Icons.arrow_right,
                        size: 18.0,
                        color: Color(0xFF64FFDA),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        desc,
                        style: const TextStyle(
                          color: Color(0xFF8892B0),
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// [SkillBadge] - Chip hiển thị kỹ năng
/// ============================================================================
class SkillBadge extends StatelessWidget {
  final String label;

  const SkillBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0x5564FFDA), width: 1.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF64FFDA),
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
