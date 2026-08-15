import '../../domain/entities/admin_dashboard_entity.dart';

abstract class AdminRemoteDataSource {
  Future<AdminDashboardEntity> getDashboard();

  Future<void> resolveReport(String id);

  Future<void> dismissReport(String id);

  Future<void> setUserRole(String id, String role);

  Future<void> updateModelLabel(String modelId, String label);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Admin remote API is not connected yet.');

  @override
  Future<AdminDashboardEntity> getDashboard() async => _notReady();

  @override
  Future<void> resolveReport(String id) async => _notReady();

  @override
  Future<void> dismissReport(String id) async => _notReady();

  @override
  Future<void> setUserRole(String id, String role) async => _notReady();

  @override
  Future<void> updateModelLabel(String modelId, String label) async =>
      _notReady();
}
