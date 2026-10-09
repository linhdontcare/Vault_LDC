// ==============================================================================
// PRESENTATION LAYER: Add / Edit Document Screen (Deep Tech Emerald)
// Màn hình biểu mẫu thêm mới hoặc chỉnh sửa thông tin tài liệu học tập.
// Tuân thủ Flutter Box Model: SafeArea, SingleChildScrollView, Padding, Column.
// Đồng bộ phong cách nhận diện Deep Tech Emerald:
// - Scaffold: Deep Slate Navy (#0F172A)
// - Container/Inputs: Dark Slate (#1E293B)
// - Primary Accent: Emerald Green (#10B981)
// ==============================================================================

import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/converters/type_converters.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/document_model.dart';
import '../providers/document_provider.dart';

/// Sao chép tệp được chọn vào vùng lưu trữ riêng của ứng dụng.
///
/// Tệp trong thư mục tải xuống hoặc ứng dụng khác có thể bị di chuyển/xóa.
/// Lưu một bản sao trong ApplicationDocumentsDirectory giúp đường dẫn đã lưu
/// trong Drift luôn trỏ tới tệp do EduVault quản lý.
Future<String> copyFileToApplicationDocumentsDirectory(
  String sourcePath,
) async {
  final appDirectory = await getApplicationDocumentsDirectory();
  final documentsDirectory = Directory(
    p.join(appDirectory.path, 'EduVault', 'Documents'),
  );
  await documentsDirectory.create(recursive: true);

  final fileName = p.basename(sourcePath);
  final targetPath = p.join(documentsDirectory.path, fileName);

  // Nếu tệp đã nằm trong thư mục riêng thì không tự sao chép đè lên chính nó.
  if (p.normalize(sourcePath) == p.normalize(targetPath)) {
    return targetPath;
  }

  var uniqueTargetPath = targetPath;
  if (await File(uniqueTargetPath).exists()) {
    final extension = p.extension(fileName);
    final baseName = p.basenameWithoutExtension(fileName);
    uniqueTargetPath = p.join(
      documentsDirectory.path,
      '${baseName}_${DateTime.now().millisecondsSinceEpoch}$extension',
    );
  }

  await File(sourcePath).copy(uniqueTargetPath);
  return uniqueTargetPath;
}

class AddEditDocumentScreen extends StatefulWidget {
  final DocumentModel? document;

  const AddEditDocumentScreen({super.key, this.document});

  @override
  State<AddEditDocumentScreen> createState() => _AddEditDocumentScreenState();
}

class _AddEditDocumentScreenState extends State<AddEditDocumentScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _subjectController;
  late final TextEditingController _filePathOrUrlController;
  late final TextEditingController _notesController;

  String? _selectedCategoryId;
  DocumentPriority _selectedPriority = DocumentPriority.low;
  bool _isSaving = false;
  bool _isPickingFile = false;
  String? _selectedFileName;
  String? _selectedFileExtension;
  int? _selectedFileSize;

  bool get _isEditMode => widget.document != null;

  @override
  void initState() {
    super.initState();
    final doc = widget.document;
    _titleController = TextEditingController(text: doc?.title ?? '');
    _subjectController = TextEditingController(text: doc?.subject ?? '');
    _filePathOrUrlController = TextEditingController(
      text: doc?.filePathOrUrl ?? '',
    );
    _notesController = TextEditingController(text: doc?.notes ?? '');
    _selectedCategoryId = doc?.categoryId;
    _selectedPriority = doc?.priority ?? DocumentPriority.low;
    _loadExistingFileMetadata();
  }

  /// Đọc lại metadata của tệp nội bộ khi mở màn hình chỉnh sửa.
  Future<void> _loadExistingFileMetadata() async {
    final savedPath = _filePathOrUrlController.text.trim();
    if (savedPath.isEmpty ||
        savedPath.startsWith('http://') ||
        savedPath.startsWith('https://')) {
      return;
    }

    final file = File(savedPath);
    if (!await file.exists()) return;

    final fileName = p.basename(savedPath);
    final stat = await file.stat();
    if (!mounted) return;

    setState(() {
      _selectedFileName = fileName;
      _selectedFileExtension = _extensionOf(fileName);
      _selectedFileSize = stat.size;
    });
  }

  String _extensionOf(String fileName) {
    final extension = p.extension(fileName).replaceFirst('.', '').trim();
    return extension.isEmpty ? 'FILE' : extension.toUpperCase();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String _documentTypeLabel(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return 'Hình ảnh';
      case 'pdf':
        return 'PDF';
      case 'doc':
      case 'docx':
        return 'Word';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint';
      case 'xls':
      case 'xlsx':
        return 'Excel';
      case 'txt':
        return 'Văn bản';
      default:
        return extension.toUpperCase();
    }
  }

  /// Kiểm tra tệp đính kèm hoặc liên kết trước khi cho phép lưu tài liệu.
  ///
  /// Người dùng phải cung cấp một trong hai loại:
  /// - URL HTTP/HTTPS hợp lệ; hoặc
  /// - Đường dẫn tới tệp local đang tồn tại.
  String? _validateAttachment(String? value) {
    final attachment = value?.trim() ?? '';
    if (attachment.isEmpty) {
      return 'Vui lòng chọn tệp hoặc nhập liên kết tài liệu';
    }

    final isWindowsLocalPath = RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(attachment);
    final uri = Uri.tryParse(attachment);
    final isHttpLink =
        uri != null &&
        (uri.scheme.toLowerCase() == 'http' ||
            uri.scheme.toLowerCase() == 'https');
    if (isHttpLink) {
      if (uri.host.isEmpty) {
        return 'Liên kết tài liệu không hợp lệ';
      }
      return null;
    }

    if (!isWindowsLocalPath && uri != null && uri.scheme.isNotEmpty) {
      return 'Chỉ hỗ trợ liên kết HTTP/HTTPS hoặc tệp local';
    }

    if (!File(attachment).existsSync()) {
      return 'Tệp local không tồn tại hoặc không thể truy cập';
    }

    return null;
  }

  /// Chọn tệp từ bộ nhớ thiết bị, sau đó lưu bản sao vào vùng dữ liệu riêng.
  Future<void> _pickDocumentFile() async {
    if (_isPickingFile) return;

    setState(() => _isPickingFile = true);
    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
          'txt',
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
        ],
      );

      if (pickedFiles.isEmpty) return;

      final pickedFile = pickedFiles.single;
      final sourcePath = pickedFile.path;
      if (sourcePath == null || sourcePath.trim().isEmpty) {
        throw StateError('Không lấy được đường dẫn của tệp đã chọn.');
      }

      final copiedPath = await copyFileToApplicationDocumentsDirectory(
        sourcePath,
      );
      final fileName = p.basename(sourcePath);
      final fileSize = pickedFile.lengthSync() ?? await pickedFile.length();

      if (!mounted) return;
      setState(() {
        _filePathOrUrlController.text = copiedPath;
        _selectedFileName = fileName;
        _selectedFileExtension = _extensionOf(fileName);
        _selectedFileSize = fileSize;
      });

      // Chỉ tự điền khi người dùng chưa nhập tiêu đề để không ghi đè dữ liệu.
      if (_titleController.text.trim().isEmpty) {
        _titleController.text = p
            .basenameWithoutExtension(fileName)
            .replaceAll(RegExp(r'[_-]+'), ' ')
            .trim();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể chọn tệp: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  void _clearSelectedFile() {
    setState(() {
      _filePathOrUrlController.clear();
      _selectedFileName = null;
      _selectedFileExtension = null;
      _selectedFileSize = null;
    });
  }

  Widget _buildFilePickerCard() {
    final hasSelectedFile = _selectedFileName != null;

    return CustomPaint(
      painter: _DashedBorderPainter(
        color: AppTheme.primaryColor.withOpacity(0.8),
      ),
      child: Material(
        color: AppTheme.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: _isPickingFile ? null : _pickDocumentFile,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isPickingFile
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryColor,
                          ),
                        )
                      : const Icon(
                          Icons.upload_file_rounded,
                          color: AppTheme.primaryColor,
                          size: 26,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: hasSelectedFile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedFileName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _buildFileInfoChip(
                                  _selectedFileExtension ?? 'FILE',
                                  Icons.description_outlined,
                                ),
                                if (_selectedFileSize != null)
                                  _buildFileInfoChip(
                                    _formatFileSize(_selectedFileSize!),
                                    Icons.data_usage_rounded,
                                  ),
                                _buildFileInfoChip(
                                  _documentTypeLabel(
                                    _selectedFileExtension ?? 'FILE',
                                  ),
                                  Icons.category_outlined,
                                ),
                              ],
                            ),
                          ],
                        )
                      : const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chọn tệp từ máy',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'PDF, Word, PowerPoint, hình ảnh...',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ),
                if (hasSelectedFile)
                  IconButton(
                    tooltip: 'Bỏ tệp đã chọn',
                    onPressed: _clearSelectedFile,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppTheme.textSecondary,
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.primaryColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _filePathOrUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final attachmentError = _validateAttachment(_filePathOrUrlController.text);
    if (attachmentError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(attachmentError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn danh mục cho tài liệu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<DocumentProvider>();

    try {
      final now = DateTime.now();
      if (_isEditMode) {
        // Cập nhật tài liệu hiện tại
        final updatedDoc = widget.document!.copyWith(
          title: _titleController.text.trim(),
          subject: _subjectController.text.trim(),
          categoryId: _selectedCategoryId!,
          filePathOrUrl: _filePathOrUrlController.text.trim().isEmpty
              ? null
              : _filePathOrUrlController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          priority: _selectedPriority,
          updatedDate: now,
        );
        await provider.updateDocument(updatedDoc);
      } else {
        // Thêm mới tài liệu
        final newDoc = DocumentModel(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          subject: _subjectController.text.trim(),
          categoryId: _selectedCategoryId!,
          filePathOrUrl: _filePathOrUrlController.text.trim().isEmpty
              ? null
              : _filePathOrUrlController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          priority: _selectedPriority,
          createdDate: now,
          updatedDate: now,
        );
        await provider.addDocument(newDoc);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Đã cập nhật tài liệu thành công'
                  : 'Đã thêm tài liệu mới',
            ),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppTheme.borderSubtle),
        ),
        title: const Text(
          'Xác nhận xóa tài liệu',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa "${widget.document?.title}"?',
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

    if (confirm == true && mounted) {
      await context.read<DocumentProvider>().deleteDocument(
        widget.document!.id,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa tài liệu'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<DocumentProvider>().categories;

    // Tự động gán danh mục đầu tiên nếu chưa chọn
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      _selectedCategoryId = categories.first.id;
    }

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.headerGradient,
            border: Border(bottom: BorderSide(color: AppTheme.borderSubtle)),
          ),
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                _isEditMode ? 'Chỉnh sửa tài liệu' : 'Thêm tài liệu mới',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              actions: [
                if (_isEditMode)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                    tooltip: 'Xóa tài liệu',
                    onPressed: _isSaving ? null : _handleDelete,
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isSaving ? null : _handleSave,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(_isSaving ? 'Đang lưu...' : 'Lưu'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Box Model: SafeArea bảo vệ vùng hiển thị
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Khối thông tin cốt lõi
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Thông tin học tập',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tiêu đề tài liệu
                TextFormField(
                  controller: _titleController,
                  maxLength: AppConstants.titleMaxLength,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề tài liệu *',
                    hintText: 'Ví dụ: Đề cương Giải tích 1 kì 2026',
                    prefixIcon: Icon(
                      Icons.title_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tiêu đề tài liệu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Môn học liên quan (Subject)
                TextFormField(
                  controller: _subjectController,
                  maxLength: AppConstants.subjectMaxLength,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Môn học *',
                    hintText: 'Ví dụ: Toán cao cấp, Kiến trúc máy tính,...',
                    prefixIcon: Icon(
                      Icons.school_outlined,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên môn học';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Chọn Danh mục tài liệu (Category Dropdown)
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  dropdownColor: AppTheme.cardBackground,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Danh mục tài liệu *',
                    prefixIcon: Icon(
                      Icons.category_outlined,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  items: categories.map((CategoryModel cat) {
                    return DropdownMenuItem<String>(
                      value: cat.id,
                      child: Text(
                        cat.name,
                        style: const TextStyle(color: AppTheme.textPrimary),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategoryId = val;
                    });
                  },
                  validator: (val) =>
                      val == null ? 'Vui lòng chọn danh mục' : null,
                ),
                const SizedBox(height: 24),

                // Khối thông tin liên kết & ghi chú
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Đính kèm & Chi tiết',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Vùng chọn tệp trực tiếp từ thiết bị.
                _buildFilePickerCard(),
                const SizedBox(height: 14),

                // Đường dẫn tệp nội bộ hoặc liên kết Web (giữ lại để tương thích dữ liệu cũ)
                TextFormField(
                  controller: _filePathOrUrlController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.url,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  validator: _validateAttachment,
                  decoration: const InputDecoration(
                    labelText: 'Đường dẫn tệp / Liên kết web *',
                    hintText: 'Chọn tệp ở trên hoặc nhập https://...',
                    prefixIcon: Icon(
                      Icons.link_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Ghi chú bổ sung (Notes)
                TextFormField(
                  controller: _notesController,
                  maxLength: AppConstants.notesMaxLength,
                  maxLines: 4,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú tóm tắt (tùy chọn)',
                    hintText: 'Nhập ghi chú tóm tắt nội dung tài liệu hoặc lưu ý quan trọng...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: Icon(
                        Icons.notes_rounded,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),

                // Nút Lưu tài liệu lớn phong cách Emerald
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isSaving ? null : _handleSave,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(
                      _isSaving
                          ? 'Đang lưu dữ liệu...'
                          : (_isEditMode
                                ? 'Cập nhật tài liệu'
                                : 'Lưu tài liệu mới'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Vẽ viền nét đứt mà không cần thêm package giao diện bên ngoài.
class _DashedBorderPainter extends CustomPainter {
  final Color color;

  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(14)),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + 7, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
