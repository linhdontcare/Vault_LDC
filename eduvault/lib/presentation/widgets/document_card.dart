// ==============================================================================
// PRESENTATION LAYER: Document Card Widget (Deep Tech Emerald)
// Tuân thủ nghiêm ngặt Flutter Box Model: Card, Padding, Margin, Row, Column.
// Áp dụng nhận diện phong cách Deep Tech Emerald:
// - Card Background: Dark Slate (#1E293B) với BorderRadius.circular(16)
// - Primary Accent: Emerald Green (#10B981) cho các Icons, Liên kết & Badges
// - Text Colors: Pure White (#FFFFFF) cho tiêu đề & Muted Slate (#94A3B8) cho mô tả/ngày tháng
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/document_model.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // Chuyển đổi mã màu hex sang Color object an toàn
  Color _parseColor(String? hexString, Color fallback) {
    if (hexString == null || hexString.isEmpty) return fallback;
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _parseColor(document.categoryColorHex, AppTheme.primaryColor);
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(document.createdDate);

    // Box Model: Card với nền Dark Slate #1E293B và bo góc BorderRadius.circular(16)
    return Card(
      elevation: 0,
      color: AppTheme.cardBackground,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          // Box Model: Padding bên trong tạo không gian thở (breathing room)
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hàng trên: Category Badge & Popup Actions Menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge hiển thị danh mục với viền và điểm nhấn màu sắc
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: categoryColor.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 14,
                          color: categoryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          document.categoryName ?? 'Chưa phân loại',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Nút menu tùy chọn (Edit / Delete)
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: AppTheme.textSecondary,
                    ),
                    color: AppTheme.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppTheme.borderSubtle),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18, color: AppTheme.primaryColor),
                            SizedBox(width: 8),
                            Text('Chỉnh sửa', style: TextStyle(color: AppTheme.textPrimary)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Xóa tài liệu', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Tiêu đề tài liệu: Pure White #FFFFFF
              Text(
                document.title,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppTheme.textPrimary, // Pure White #FFFFFF
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Môn học liên quan: Muted Slate #94A3B8
              Row(
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 15,
                    color: AppTheme.primaryColor, // Emerald Green #10B981
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Môn học: ${document.subject}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary, // Muted Slate #94A3B8
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Ghi chú tóm tắt (Notes) nếu có: Muted Slate #94A3B8
              if (document.notes != null && document.notes!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  document.notes!.trim(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 0.8, color: AppTheme.borderSubtle),
              const SizedBox(height: 10),

              // Hàng chân card: Chỉ báo liên kết & Ngày tháng tạo
              Row(
                children: [
                  // Chỉ báo File hoặc Liên kết web với màu Emerald Green #10B981
                  if (document.hasAttachment) ...[
                    Icon(
                      document.isWebLink ? Icons.link_rounded : Icons.attach_file_rounded,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        document.filePathOrUrl ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                  ],

                  // Ngày tháng tạo: Muted Slate #94A3B8
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
