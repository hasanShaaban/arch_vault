import '../entities/admin_dashboard_entity.dart';

abstract class AdminRepo {
  Future<AdminDashboardEntity> getDashboard();

  Future<void> resolveReport(String id);

  Future<void> dismissReport(String id);

  Future<void> setUserRole(String id, String role);

  Future<void> updateModelLabel(String modelId, String label);
}
