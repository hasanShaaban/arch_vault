import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/model_3d_entity.dart';

class ReportEntity extends Equatable {
  const ReportEntity({
    required this.id,
    required this.model,
    required this.reporter,
    required this.reason,
    required this.status,
    this.adminNote,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final Model3dEntity model;
  final UploadedByEntity reporter;
  final String reason;
  final String status;
  final String? adminNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Convenience getters for UI display
  String get modelId => model.id;
  String get modelTitle => model.title ?? 'Untitled';
  String get reporterUsername => reporter.username;

  @override
  List<Object?> get props => [
        id,
        model,
        reporter,
        reason,
        status,
        adminNote,
        createdAt,
        updatedAt,
      ];
}
