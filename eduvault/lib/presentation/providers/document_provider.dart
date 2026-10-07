// ==============================================================================
// PRESENTATION / STATE LAYER: Document Provider
// Quản lý trạng thái ứng dụng theo kiến trúc Provider & ChangeNotifier của Cashew:
// - Lắng nghe luồng dữ liệu thời gian thực (Reactive Streams) từ Repository
// - Quản lý trạng thái tìm kiếm (Search Query) và bộ lọc danh mục (Category Filter)
// - Thực hiện các thao tác CRUD bất đồng bộ với cơ chế xử lý lỗi chặt chẽ
// - Thông báo cập nhật giao diện tự động (notifyListeners) khi dữ liệu thay đổi
// ==============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/document_model.dart';
import '../../domain/repositories/document_repository.dart';

class DocumentProvider extends ChangeNotifier {
  final DocumentRepository _repository;

  // Trạng thái nội bộ
  List<DocumentModel> _documents = [];
  List<CategoryModel> _categories = [];
  String _searchQuery = '';
  String? _selectedCategoryId = 'all';
  bool _isLoading = false;
  String? _errorMessage;

  // Stream Subscriptions quản lý giải phóng tài nguyên
  StreamSubscription<List<DocumentModel>>? _documentSubscription;
  StreamSubscription<List<CategoryModel>>? _categorySubscription;

  DocumentProvider({required DocumentRepository repository})
      : _repository = repository {
    _initStreams();
  }

  // --- Getters công khai cho giao diện ---

  List<DocumentModel> get documents => _documents;
  List<CategoryModel> get categories => _categories;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Danh sách tài liệu được lọc theo thời gian thực (Title/Subject & Category)
  List<DocumentModel> get filteredDocuments {
    return _documents.where((doc) {
      // 1. Lọc theo danh mục
      final matchesCategory = _selectedCategoryId == null ||
          _selectedCategoryId == 'all' ||
          doc.categoryId == _selectedCategoryId;

      if (!matchesCategory) return false;

      // 2. Lọc theo từ khóa tìm kiếm (khớp Tiêu đề hoặc Môn học)
      if (_searchQuery.trim().isEmpty) return true;
      final queryLower = _searchQuery.trim().toLowerCase();
      final titleMatch = doc.title.toLowerCase().contains(queryLower);
      final subjectMatch = doc.subject.toLowerCase().contains(queryLower);

      return titleMatch || subjectMatch;
    }).toList();
  }

  // --- Khởi tạo và Lắng nghe Reactive Streams ---

  void _initStreams() {
    _isLoading = true;
    notifyListeners();

    // Lắng nghe luồng danh mục
    _categorySubscription = _repository.watchAllCategories().listen(
      (cats) {
        _categories = cats;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _errorMessage = 'Lỗi nạp danh mục: $err';
        _isLoading = false;
        notifyListeners();
      },
    );

    // Lắng nghe luồng tài liệu
    _documentSubscription = _repository.watchAllDocuments().listen(
      (docs) {
        _documents = docs;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _errorMessage = 'Lỗi nạp tài liệu: $err';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // --- Thao tác cập nhật bộ lọc và tìm kiếm (Filters & Search) ---

  /// Cập nhật từ khóa tìm kiếm thời gian thực
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Cập nhật bộ lọc danh mục đã chọn
  void setCategoryFilter(String? categoryId) {
    if (_selectedCategoryId != categoryId) {
      _selectedCategoryId = categoryId;
      notifyListeners();
    }
  }

  /// Đặt lại toàn bộ bộ lọc về trạng thái ban đầu
  void resetFilters() {
    _searchQuery = '';
    _selectedCategoryId = 'all';
    notifyListeners();
  }

  // --- Thao tác CRUD (Create - Read - Update - Delete) ---

  /// Thêm mới một tài liệu học tập
  Future<void> addDocument(DocumentModel document) async {
    try {
      await _repository.insertDocument(document);
    } catch (e) {
      _errorMessage = 'Lỗi khi thêm tài liệu: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Cập nhật thông tin tài liệu hiện có
  Future<void> updateDocument(DocumentModel document) async {
    try {
      await _repository.updateDocument(document);
    } catch (e) {
      _errorMessage = 'Lỗi khi cập nhật tài liệu: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Xóa tài liệu theo ID
  Future<void> deleteDocument(String id) async {
    try {
      await _repository.deleteDocument(id);
    } catch (e) {
      _errorMessage = 'Lỗi khi xóa tài liệu: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Làm mới thủ công toàn bộ dữ liệu
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    try {
      _documents = await _repository.getAllDocuments();
      _categories = await _repository.getAllCategories();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Lỗi làm mới dữ liệu: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _documentSubscription?.cancel();
    _categorySubscription?.cancel();
    super.dispose();
  }
}
