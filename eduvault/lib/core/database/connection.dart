// ==============================================================================
// CORE LAYER: Database Connection Helper
// Mô phỏng chính xác cấu trúc LazyDatabase & NativeDatabase trong Cashew app.
// Mở kết nối SQLite bất đồng bộ và hỗ trợ xử lý trên background isolate (createInBackground)
// giúp tác vụ I/O nặng không làm giật lag giao diện (drop frame 60/120fps).
// ==============================================================================

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../constants/app_constants.dart';

LazyDatabase openConnection({String? dbName}) {
  return LazyDatabase(() async {
    // Lấy thư mục lưu trữ tài liệu của ứng dụng trên thiết bị (iOS/Android/Desktop)
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, '${dbName ?? AppConstants.databaseName}.sqlite'));

    // Khởi tạo executor chạy trên isolate nền (Background Isolate)
    return NativeDatabase.createInBackground(
      file,
      logStatements: false,
    );
  });
}
