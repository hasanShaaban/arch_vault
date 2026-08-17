import '../../domain/entities/get_reports_response_entity.dart';
import 'report_model.dart';

class GetReportsResponseModel extends GetReportsResponseEntity {
  const GetReportsResponseModel({
    required super.count,
    required super.results,
    super.next,
    super.previous,
  });

  factory GetReportsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetReportsResponseModel(
        count: json['count'] as int? ?? 0,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List<dynamic>?)
                ?.map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'count': count,
        'next': next,
        'previous': previous,
        'results':
            (results as List<ReportModel>).map((e) => e.toJson()).toList(),
      };
}
