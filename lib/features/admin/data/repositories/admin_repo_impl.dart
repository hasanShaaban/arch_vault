import '../../domain/entities/admin_dashboard_entity.dart';
import '../../domain/repositories/admin_repo.dart';
import '../datasources/admin_local_datasource.dart';

class AdminRepoImpl implements AdminRepo {
  AdminRepoImpl(this._localDataSource);

  final AdminLocalDataSource _localDataSource;

  @override
  Future<AdminDashboardEntity> getDashboard() {
    return _localDataSource.getDashboard();
  }

  @override
  Future<void> resolveReport(String id) {
    return _localDataSource.resolveReport(id);
  }

  @override
  Future<void> dismissReport(String id) {
    return _localDataSource.dismissReport(id);
  }

  @override
  Future<void> setUserRole(String id, String role) {
    return _localDataSource.setUserRole(id, role);
  }

  @override
  Future<void> updateModelLabel(String modelId, String label) {
    return _localDataSource.updateModelLabel(modelId, label);
  }
}
