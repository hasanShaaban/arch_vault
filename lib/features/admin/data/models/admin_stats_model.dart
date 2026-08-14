import '../../domain/entities/admin_stats_entity.dart';

class AdminStatsModel {
  const AdminStatsModel({
    required this.usersCount,
    required this.modelsCount,
    required this.downloadsCount,
    required this.pendingReports,
    required this.pendingLabels,
  });

  final int usersCount;
  final int modelsCount;
  final int downloadsCount;
  final int pendingReports;
  final int pendingLabels;

  AdminStatsEntity toEntity() => AdminStatsEntity(
        usersCount: usersCount,
        modelsCount: modelsCount,
        downloadsCount: downloadsCount,
        pendingReports: pendingReports,
        pendingLabels: pendingLabels,
      );
}
