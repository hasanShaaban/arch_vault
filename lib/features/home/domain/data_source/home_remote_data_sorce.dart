import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';

abstract class HomeRemoteDataSource {
  Future<GetModelsResponseEntity> getAllModels({required int page});
}
