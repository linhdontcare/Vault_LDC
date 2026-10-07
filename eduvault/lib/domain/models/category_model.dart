// ==============================================================================
// DOMAIN LAYER: Category Model (Thực thể miền Danh mục)
// Pure Dart Object không phụ thuộc vào bất kỳ framework hoặc cơ sở dữ liệu nào.
// Tuân thủ nguyên lý Dependency Inversion Principle và Cashew Clean Architecture.
// ==============================================================================

class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final String? colorHex;
  final DateTime createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.colorHex,
    required this.createdAt,
  });

  /// Tạo bản sao có cập nhật các trường nhất định
  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? colorHex,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}
