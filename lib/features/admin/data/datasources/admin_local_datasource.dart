import '../../../home/data/models/model_3d_model.dart';
import '../../domain/entities/admin_dashboard_entity.dart';
import '../models/admin_stats_model.dart';
import '../models/admin_user_model.dart';
import '../models/label_review_model.dart';
import '../models/report_model.dart';

abstract class AdminLocalDataSource {
  Future<AdminDashboardEntity> getDashboard();

  Future<void> resolveReport(String id);

  Future<void> dismissReport(String id);

  Future<void> setUserRole(String id, String role);

  Future<void> updateModelLabel(String modelId, String label);
}

class AdminLocalDataSourceImpl implements AdminLocalDataSource {
  AdminLocalDataSourceImpl() {
    _seed();
  }

  late List<ReportModel> _reports;
  late List<AdminUserModel> _users;
  late List<LabelReviewModel> _labelReviews;

  static const _modelsCount = 8;
  static const _downloadsCount = 1594;

  void _seed() {
    _reports = [
      ReportModel(
        id: 1,
        model: Model3dModel(
          id: '1',
          title: 'Modern Villa Atrium',
          uploadedAt: DateTime.now(),
          isActive: true,
          viewsCount: 10,
          downloadsCount: 5,
          usageCount: 2,
          ratingScore: 4,
        ),
        reporter: UploadedByModel(
          id: 1,
          email: 'nova@archvault.com',
          username: 'nova_design',
          role: 'user',
          dateJoined: DateTime.now(),
        ),
        reason: 'Inappropriate content',
        status: 'open',
        adminNote: '',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ReportModel(
        id: 2,
        model: Model3dModel(
          id: '3',
          title: 'Cultural Pavilion',
          uploadedAt: DateTime.now(),
          isActive: true,
          viewsCount: 15,
          downloadsCount: 8,
          usageCount: 4,
          ratingScore: 5,
        ),
        reporter: UploadedByModel(
          id: 2,
          email: 'build@archvault.com',
          username: 'build_lab',
          role: 'user',
          dateJoined: DateTime.now(),
        ),
        reason: 'Wrong category / misleading labels',
        status: 'open',
        adminNote: '',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    _users = [
      const AdminUserModel(
        id: '1',
        username: 'studio_arch',
        email: 'demo@archvault.com',
        role: 'admin',
        modelsCount: 12,
      ),
      const AdminUserModel(
        id: '2',
        username: 'nova_design',
        email: 'nova@archvault.com',
        role: 'user',
        modelsCount: 7,
      ),
      const AdminUserModel(
        id: '3',
        username: 'build_lab',
        email: 'build@archvault.com',
        role: 'user',
        modelsCount: 4,
      ),
      const AdminUserModel(
        id: '4',
        username: 'arch_kit',
        email: 'kit@archvault.com',
        role: 'user',
        modelsCount: 9,
      ),
    ];

    _labelReviews = [
      const LabelReviewModel(
        modelId: '2',
        title: 'Glass Office Tower',
        currentLabel: 'Unassigned',
        suggestedLabel: 'Commercial',
        image: 'assets/images/previews/tower.png',
      ),
      const LabelReviewModel(
        modelId: '4',
        title: 'Courtyard Residence',
        currentLabel: 'Public',
        suggestedLabel: 'Residential',
        image: 'assets/images/previews/courtyard.png',
      ),
      const LabelReviewModel(
        modelId: '6',
        title: 'Library Annex',
        currentLabel: 'Unassigned',
        suggestedLabel: 'Public',
        image: 'assets/images/previews/library.png',
      ),
    ];
  }

  AdminStatsModel _buildStats() {
    final openReports = _reports.where((r) => r.status == 'open').length;
    final pendingLabels =
        _labelReviews.where((l) => l.currentLabel == 'Unassigned').length;
    return AdminStatsModel(
      usersCount: _users.length,
      modelsCount: _modelsCount,
      downloadsCount: _downloadsCount,
      pendingReports: openReports,
      pendingLabels: pendingLabels,
    );
  }

  @override
  Future<AdminDashboardEntity> getDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return AdminDashboardEntity(
      stats: _buildStats().toEntity(),
      reports: _reports.map((r) => r.toEntity()).toList(growable: false),
      users: _users.map((u) => u.toEntity()).toList(growable: false),
      labelReviews:
          _labelReviews.map((l) => l.toEntity()).toList(growable: false),
    );
  }

  @override
  Future<void> resolveReport(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _reports.indexWhere((r) => r.id.toString() == id);
    if (index < 0) {
      throw Exception('Report not found');
    }
    _reports[index] = _reports[index].copyWith(status: 'resolved');
  }

  @override
  Future<void> dismissReport(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _reports.indexWhere((r) => r.id.toString() == id);
    if (index < 0) {
      throw Exception('Report not found');
    }
    _reports[index] = _reports[index].copyWith(status: 'dismissed');
  }

  @override
  Future<void> setUserRole(String id, String role) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (role != 'user' && role != 'admin') {
      throw Exception('Invalid role');
    }
    final index = _users.indexWhere((u) => u.id == id);
    if (index < 0) {
      throw Exception('User not found');
    }
    _users[index] = _users[index].copyWith(role: role);
  }

  @override
  Future<void> updateModelLabel(String modelId, String label) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final trimmed = label.trim();
    if (trimmed.isEmpty) {
      throw Exception('Label cannot be empty');
    }
    final index = _labelReviews.indexWhere((l) => l.modelId == modelId);
    if (index < 0) {
      throw Exception('Model not found');
    }
    _labelReviews[index] =
        _labelReviews[index].copyWith(currentLabel: trimmed);
  }
}
