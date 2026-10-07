import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dev Profile Card',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14B8A6),
          brightness: Brightness.dark,
        ),
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A192F), // Deep navy dark
              Color(0xFF0F303F), // Subtle teal dark
              Color(0xFF091420), // Bottom dark
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- 1. AVATAR VỚI HIỆU ỨNG VIỀN & BADGE TRẠNG THÁI ---
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2DD4BF), Color(0xFF0284C7)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2DD4BF)
                                  .withValues(alpha: 0.35),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 54.0,
                          backgroundColor: Color(0xFF0F172A),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
                            ),
                          ),
                        ),
                      ),
                      // Badge online
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0A192F),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  // --- 2. TÊN & TRẠNG THÁI HOẠT ĐỘNG ---
                  const Text(
                    'Linhdontcare',
                    style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6.0),

                  // Chip chức danh
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DD4BF).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color(0xFF2DD4BF).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.code_rounded,
                          size: 16.0,
                          color: Color(0xFF2DD4BF),
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          'FLUTTER DEVELOPER',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF2DD4BF),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18.0),

                  // --- 3. BẢNG THỐNG KÊ (STATS ROW) ---
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(number: '15+', label: 'Dự án'),
                        _StatDivider(),
                        _StatItem(number: '2+', label: 'Năm KN'),
                        _StatDivider(),
                        _StatItem(number: '100%', label: 'Hài lòng'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // --- 4. THẺ THÔNG TIN LIÊN HỆ & MÔ TẢ ---
                  _InfoContactCard(
                    icon: Icons.phone_rounded,
                    iconColor: const Color(0xFF38BDF8),
                    title: 'Số điện thoại',
                    value: '+84 1',
                    actionIcon: Icons.call_outlined,
                  ),
                  const SizedBox(height: 10.0),

                  _InfoContactCard(
                    icon: Icons.email_rounded,
                    iconColor: const Color(0xFFF43F5E),
                    title: 'Email liên hệ',
                    value: 'linhdontcare@example.com',
                    actionIcon: Icons.send_rounded,
                  ),
                  const SizedBox(height: 10.0),

                  _InfoContactCard(
                    icon: Icons.location_on_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Địa điểm',
                    value: 'Hà Nội, Việt Nam',
                    actionIcon: Icons.map_outlined,
                  ),
                  const SizedBox(height: 10.0),

                  // Thẻ giới thiệu bản thân (Bio)
                  Card(
                    elevation: 0,
                    color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.format_quote_rounded,
                                color: Color(0xFF2DD4BF),
                                size: 20.0,
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                'Giới thiệu bản thân',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Đvvvvvvvvvvvam mê xây dựng ứng dụng di động đa nền tảng chất lượng cao, tối ưu hóa trải nghiệm người dùng (UI/UX) và kiến trúc code sạch sẽ, dễ mở rộng.',
                            style: TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 13.5,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14.0),

                          // Tech Stack Tags
                          Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: const [
                              _TechChip(name: 'Flutter'),
                              _TechChip(name: 'Dart'),
                              _TechChip(name: 'Firebase'),
                              _TechChip(name: 'REST API'),
                              _TechChip(name: 'Git'),
                              _TechChip(name: 'UI/UX'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // --- 5. HÀNG NÚT HÀNH ĐỘNG (ACTION BUTTONS) ---
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            side: const BorderSide(color: Color(0xFF2DD4BF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          icon: const Icon(
                            Icons.file_download_outlined,
                            color: Color(0xFF2DD4BF),
                            size: 18.0,
                          ),
                          label: const Text(
                            'Tải CV',
                            style: TextStyle(
                              color: Color(0xFF2DD4BF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            backgroundColor: const Color(0xFF2DD4BF),
                            foregroundColor: const Color(0xFF0F172A),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          icon: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18.0,
                          ),
                          label: const Text(
                            'Liên hệ ngay',
                            style: TextStyle(fontWeight: FontWeight.w800),
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
      ),
    );
  }
}

// Widget con: Mục thống kê
class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Color(0xFF2DD4BF),
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Đường gạch ngăn cách giữa các item thống kê
class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.0,
      height: 24.0,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }
}

// Widget con: Thẻ thông tin liên hệ tùy biến
class _InfoContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final IconData actionIcon;

  const _InfoContactCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFF1E293B).withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            // Khung Icon với background mờ tinh tế
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, color: iconColor, size: 22.0),
            ),
            const SizedBox(width: 14.0),

            // Tiêu đề & Nội dung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Nút hành động phụ (trailing)
            Icon(actionIcon, color: Colors.white30, size: 18.0),
          ],
        ),
      ),
    );
  }
}

// Widget con: Chip kỹ năng công nghệ (Tech Chip)
class _TechChip extends StatelessWidget {
  final String name;

  const _TechChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF334155),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Color(0xFFE2E8F0),
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
