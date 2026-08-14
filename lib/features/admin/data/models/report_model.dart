import '../../domain/entities/report_entity.dart';

class ReportModel {
  const ReportModel({
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
  final String status;
  final DateTime createdAt;

  ReportModel copyWith({String? status}) {
    return ReportModel(
      id: id,
      modelId: modelId,
      modelTitle: modelTitle,
      reason: reason,
      reporterUsername: reporterUsername,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  ReportEntity toEntity() => ReportEntity(
        id: id,
        modelId: modelId,
        modelTitle: modelTitle,
        reason: reason,
        reporterUsername: reporterUsername,
        status: status,
        createdAt: createdAt,
      );
}
