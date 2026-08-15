class AdminStatsEntity {
  const AdminStatsEntity({
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
}
