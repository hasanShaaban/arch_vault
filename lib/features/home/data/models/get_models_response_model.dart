import '../../domain/entities/get_models_response_entity.dart';
import 'model_3d_model.dart';

class GetModelsResponseModel extends GetModelsResponseEntity {
  const GetModelsResponseModel({
    required super.count,
    required super.results,
    super.next,
    super.previous,
  });

  factory GetModelsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetModelsResponseModel(
        count: json['count'] as int,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List<dynamic>)
            .map((e) => Model3dModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'count': count,
        'next': next,
        'previous': previous,
        'results': (results as List<Model3dModel>)
            .map((e) => e.toJson())
            .toList(),
      };
}
