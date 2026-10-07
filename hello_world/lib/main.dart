import 'package:flutter/material.dart';

void main() {
  // Điểm bắt đầu của ứng dụng: đưa MyApp lên màn hình.
  runApp(const MyApp());
}

// Widget gốc không có trạng thái thay đổi nên dùng StatelessWidget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ẩn banner "DEBUG" ở góc màn hình.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // Bật hệ thống giao diện Material 3.
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const HelloWorldPage(),
    );
  }
}

class HelloWorldPage extends StatelessWidget {
  const HelloWorldPage({super.key});

  void _showWelcomeMessage(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    // Xóa các SnackBar đang chờ để không bị dồn thông báo khi bấm nhiều lần.
    messenger.clearSnackBars();
    // Chỉ hiển thị thông báo khi người dùng bấm nút, không gọi trong build().
    messenger.showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Welcome! Your Flutter journey starts here.'),
        // Tự động ẩn thông báo sau đúng 2 giây.
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Tạo nền chuyển màu từ tím Deep Purple sang xanh Indigo.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF673AB7), Color(0xFF3F51B5), Color(0xFF1A237E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                // Card nổi nhẹ trên nền nhờ bo góc và bóng đổ.
                elevation: 18,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white.withValues(alpha: 0.14),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Vòng tròn nền mờ bao quanh biểu tượng vẫy tay.
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                        ),
                        child: const Icon(
                          Icons.waving_hand_rounded,
                          size: 48,
                          color: Color(0xFFFFD54F),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Tiêu đề chính của màn hình.
                      const Text(
                        'Hello, World!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Dòng mô tả ngắn bên dưới tiêu đề.
                      Text(
                        'Welcome to my Flutter app',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Nút gọi SnackBar khi người dùng thực hiện hành động.
                      ElevatedButton.icon(
                        onPressed: () => _showWelcomeMessage(context),
                        icon: const Icon(Icons.bolt_rounded),
                        label: const Text('Get Started'),
                        style: ElevatedButton.styleFrom(
                          elevation: 8,
                          shadowColor: Colors.black45,
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF4527A0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
