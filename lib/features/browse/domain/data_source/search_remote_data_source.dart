import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';

abstract class SearchRemoteDataSource {
  Future<GetModelsResponseEntity> search({
    String? q,
    String? superCategory,
    String? subFamily,
    String? styleClass,
    required int page,
  });
}
