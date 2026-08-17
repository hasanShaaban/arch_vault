import '../../../home/data/models/model_3d_model.dart';
import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.id,
    required super.model,
    required super.reporter,
    required super.reason,
    required super.status,
    super.adminNote,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'] is int
            ? json['id'] as int
            : int.parse(json['id'].toString()),
        model: Model3dModel.fromJson(json['model'] as Map<String, dynamic>),
        reporter: UploadedByModel.fromJson(
          json['reporter'] as Map<String, dynamic>,
        ),
        reason: json['reason'] as String? ?? '',
        status: json['status'] as String? ?? 'pending',
        adminNote: json['admin_note'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'model': (model as Model3dModel).toJson(),
        'reporter': (reporter as UploadedByModel).toJson(),
        'reason': reason,
        'status': status,
        'admin_note': adminNote,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  ReportModel copyWith({
    int? id,
    Model3dModel? model,
    UploadedByModel? reporter,
    String? reason,
    String? status,
    String? adminNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      model: model ?? (this.model as Model3dModel),
      reporter: reporter ?? (this.reporter as UploadedByModel),
      reason: reason ?? this.reason,
      status: status ?? this.status,
      adminNote: adminNote ?? this.adminNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ReportEntity toEntity() => ReportEntity(
        id: id,
        model: model,
        reporter: reporter,
        reason: reason,
        status: status,
        adminNote: adminNote,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
