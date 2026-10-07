// ==============================================================================
// APPLICATION ENTRY POINT: main.dart
// Cấu hình khởi tạo toàn cục theo chuẩn Cashew Architecture:
// - Đảm bảo WidgetsFlutterBinding được khởi chạy
// - Thiết lập Dependency Injection (DI) bằng MultiProvider phân tầng:
//   * Drift SQLite Database (Singleton)
//   * Domain Repository Implementation
//   * Presentation State Notifiers (DocumentProvider)
// - Cấu hình hệ thống Material 3 AppTheme với chế độ sáng/tối tự động
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/database/drift_database.dart';
import 'data/repositories/document_repository_impl.dart';
import 'domain/repositories/document_repository.dart';
import 'presentation/providers/document_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  // 1. Đảm bảo Engine Flutter được liên kết trước khi thực hiện thao tác I/O
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Cơ sở dữ liệu SQLite cục bộ (Drift ORM)
  final database = AppDatabase();

  // 3. Khởi tạo Repository hiện thực (Data Layer)
  final DocumentRepository documentRepository = DocumentRepositoryImpl(database);

  runApp(
    MultiProvider(
      providers: [
        // Cung cấp Database Instance trong toàn cây Widget
        Provider<AppDatabase>.value(value: database),

        // Cung cấp Repository Interface cho phép dễ dàng Mocking khi kiểm thử
        Provider<DocumentRepository>.value(value: documentRepository),

        // Cung cấp Business State Notifier cho Tầng Giao diện UI
        ChangeNotifierProvider<DocumentProvider>(
          create: (_) => DocumentProvider(repository: documentRepository),
        ),
      ],
      child: const EduVaultApp(),
    ),
  );
}

class EduVaultApp extends StatelessWidget {
  const EduVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduVault - LDC Edition',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.deepTechEmeraldTheme,
      darkTheme: AppTheme.deepTechEmeraldTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
