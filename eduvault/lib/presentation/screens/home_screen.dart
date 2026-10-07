// ==============================================================================
// PRESENTATION LAYER: Home Screen (EduVault - LDC Edition)
// Thiết kế theo phong cách nhận diện Deep Tech Emerald:
// - Scaffold Background: Deep Slate Navy (#0F172A)
// - Card Background: Dark Slate (#1E293B) với BorderRadius.circular(16)
// - Primary Accent: Emerald Green (#10B981) cho FAB, Active Tabs, Icons
// - Text Colors: Pure White (#FFFFFF) & Muted Slate (#94A3B8)
// - Hiệu ứng Gradient: LinearGradient cho AppBar & Header Cards tạo chiều sâu công nghệ
// ==============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/document_model.dart';
import '../providers/document_provider.dart';
import '../widgets/document_card.dart';
import '../widgets/search_bar_widget.dart';
import 'add_edit_document_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentProvider>();
    final categories = provider.categories;
    final filteredDocs = provider.filteredDocuments;
    final selectedCategoryId = provider.selectedCategoryId;
    final isLoading = provider.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.headerGradient,
            border: Border(
              bottom: BorderSide(color: AppTheme.borderSubtle, width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  // Logo biểu tượng với dải màu Emerald phát sáng
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      gradient: AppTheme.emeraldPillGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.folder_special_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tên ứng dụng nổi bật: EduVault - LDC Edition
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'EduVault',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Tag định danh LDC Edition
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppTheme.emeraldPillGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'LDC EDITION',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Study Document Manager • Deep Tech Emerald',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nút thông tin About / LDC Edition
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.primaryColor,
                    ),
                    tooltip: 'Thông tin EduVault - LDC Edition',
                    onPressed: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Box Model: SafeArea bảo vệ toàn vẹn hiển thị
      body: SafeArea(
        child: Column(
          children: [
            // Header Card hiển thị tóm tắt thống kê với LinearGradient tạo chiều sâu
            Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E293B), // Dark Slate
                    Color(0xFF131D2E),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderSubtle, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Tổng số tài liệu
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${provider.documents.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Text(
                              'Tổng tài liệu',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(height: 30, width: 1, color: AppTheme.borderSubtle),

                  // Số kết quả lọc hiện tại
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.filter_alt_outlined,
                              color: Color(0xFF38BDF8),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${filteredDocs.length}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const Text(
                                'Hiển thị',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Khối tìm kiếm thời gian thực
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: CustomSearchBar(
                initialValue: provider.searchQuery,
                onChanged: (query) {
                  provider.setSearchQuery(query);
                },
                onClear: () {
                  provider.setSearchQuery('');
                },
              ),
            ),

            // Thanh lọc danh mục nằm ngang (Active Tabs sử dụng Emerald Green #10B981)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Tab "Tất cả"
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildCategoryTab(
                      label: 'Tất cả',
                      isSelected:
                          selectedCategoryId == null ||
                          selectedCategoryId == 'all',
                      onTap: () => provider.setCategoryFilter('all'),
                    ),
                  ),

                  // Các Category Tabs động lấy từ Database
                  ...categories.map((CategoryModel cat) {
                    final isSelected = selectedCategoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildCategoryTab(
                        label: cat.name,
                        isSelected: isSelected,
                        onTap: () => provider.setCategoryFilter(cat.id),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Danh sách tài liệu (ListView.builder)
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : filteredDocs.isEmpty
                  ? _buildEmptyState(context, provider)
                  : RefreshIndicator(
                      color: AppTheme.primaryColor,
                      backgroundColor: AppTheme.cardBackground,
                      onRefresh: () async {
                        await provider.refresh();
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 85),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          return DocumentCard(
                            document: doc,
                            onTap: () {
                              _openDocument(context, doc);
                            },
                            onEdit: () {
                              _navigateToEdit(context, doc);
                            },
                            onDelete: () {
                              _confirmDelete(context, doc);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      // Floating Action Button phong cách Emerald Green #10B981
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const AddEditDocumentScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add_rounded, size: 22),
          label: const Text(
            'Thêm tài liệu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }

  // Widget vẽ Tab lọc danh mục với Emerald Green Accent
  Widget _buildCategoryTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderSubtle,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // Chuyển sang màn hình chỉnh sửa
  void _navigateToEdit(BuildContext context, DocumentModel doc) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => AddEditDocumentScreen(document: doc)),
    );
  }

  /// Mở tệp nội bộ bằng ứng dụng tương thích hoặc mở liên kết bằng trình duyệt.
  Future<void> _openDocument(BuildContext context, DocumentModel doc) async {
    if (!doc.hasAttachment) {
      _navigateToEdit(context, doc);
      return;
    }

    final savedPath = doc.filePathOrUrl!.trim();
    if (doc.isWebLink) {
      final launched = await launchUrl(
        Uri.parse(savedPath),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể mở liên kết tài liệu.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final file = File(savedPath);
    if (!await file.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy tệp trong bộ nhớ ứng dụng.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final result = await OpenFilex.open(savedPath);
    if (result.type != ResultType.done && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể mở tệp: ${result.message}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // Xác nhận xóa tài liệu với Dialog an toàn
  Future<void> _confirmDelete(BuildContext context, DocumentModel doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppTheme.borderSubtle),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Xác nhận xóa tài liệu',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa tài liệu "${doc.title}"?\nThao tác này không thể hoàn tác.',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Hủy',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa vĩnh viễn'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<DocumentProvider>().deleteDocument(doc.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa "${doc.title}"'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Hộp thoại giới thiệu thông tin EduVault - LDC Edition
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.borderSubtle),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.emeraldPillGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.verified_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'EduVault',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppTheme.emeraldPillGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'LDC EDITION • V1.0.0',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ứng dụng Quản lý Tài liệu Học tập chuẩn kiến trúc Cashew App với giao diện Deep Tech Emerald cao cấp.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 14),
            const Divider(color: AppTheme.borderSubtle),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.storage_rounded,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Drift ORM (SQLite Background Isolate)',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Icon(
                  Icons.palette_rounded,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Deep Tech Emerald Theme Palette',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị khi không có tài liệu nào phù hợp với bộ lọc
  Widget _buildEmptyState(BuildContext context, DocumentProvider provider) {
    final hasFilter =
        provider.searchQuery.isNotEmpty ||
        (provider.selectedCategoryId != null &&
            provider.selectedCategoryId != 'all');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: Icon(
                hasFilter
                    ? Icons.search_off_rounded
                    : Icons.folder_open_rounded,
                size: 46,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasFilter
                  ? 'Không tìm thấy tài liệu phù hợp'
                  : 'Chưa có tài liệu nào',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilter
                  ? 'Hãy thử thay đổi từ khóa tìm kiếm hoặc chọn danh mục khác.'
                  : 'Bắt đầu quản lý tài liệu học tập của bạn bằng cách thêm tài liệu đầu tiên.',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (hasFilter)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  provider.setSearchQuery('');
                  provider.setCategoryFilter('all');
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Đặt lại bộ lọc'),
              )
            else
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const AddEditDocumentScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Tạo tài liệu mới'),
              ),
          ],
        ),
      ),
    );
  }
}
