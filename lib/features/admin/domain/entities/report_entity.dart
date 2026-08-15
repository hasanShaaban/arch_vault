class ReportEntity {
  const ReportEntity({
    required this.id,
    required this.modelId,
    required this.modelTitle,
    required this.reason,
    required this.reporterUsername,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String modelId;
  final String modelTitle;
  final String reason;
  final String reporterUsername;

  /// `open`, `resolved`, or `dismissed`.
  final String status;
  final DateTime createdAt;
}
