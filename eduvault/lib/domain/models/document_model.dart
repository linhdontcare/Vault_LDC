// ==============================================================================
// DOMAIN LAYER: Document Model (Thực thể miền Tài liệu học tập)
// Đại diện cho lõi nghiệp vụ của ứng dụng: độc lập với Drift SQLite, 
// đóng gói đầy đủ các thuộc tính và hành vi nghiệp vụ của một tài liệu học tập.
// ==============================================================================

import '../../data/database/converters/type_converters.dart';

class DocumentModel {
  final String id;
  final String title;
  final String subject;
  final String categoryId;
  final String? categoryName; // Tên danh mục dùng để hiển thị trực tiếp trên UI
  final String? categoryColorHex; // Màu đại diện danh mục
  final String? filePathOrUrl;
  final String? notes;
  final List<String> tags;
  final DocumentPriority priority;
  final DateTime createdDate;
  final DateTime updatedDate;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.categoryId,
    this.categoryName,
    this.categoryColorHex,
    this.filePathOrUrl,
    this.notes,
    this.tags = const [],
    this.priority = DocumentPriority.low,
    required this.createdDate,
    required this.updatedDate,
  });

  /// Kiểm tra tài liệu có đính kèm file hoặc đường dẫn liên kết hay không
  bool get hasAttachment => filePathOrUrl != null && filePathOrUrl!.trim().isNotEmpty;

  /// Kiểm tra đường dẫn có phải liên kết web (http/https) hay file cục bộ
  bool get isWebLink =>
      hasAttachment &&
      (filePathOrUrl!.toLowerCase().startsWith('http://') ||
          filePathOrUrl!.toLowerCase().startsWith('https://'));

  /// Tạo bản sao có cập nhật các trường nhất định (Immutable Data Pattern)
  DocumentModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? categoryId,
    String? categoryName,
    String? categoryColorHex,
    String? filePathOrUrl,
    String? notes,
    List<String>? tags,
    DocumentPriority? priority,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryColorHex: categoryColorHex ?? this.categoryColorHex,
      filePathOrUrl: filePathOrUrl ?? this.filePathOrUrl,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DocumentModel(id: $id, title: $title, subject: $subject, categoryId: $categoryId)';
  }
}
