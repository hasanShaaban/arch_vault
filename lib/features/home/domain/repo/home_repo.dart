import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/model_asset_entity.dart';

abstract class HomeRepo {
  Future<List<ModelAssetEntity>> getFeaturedModels();
  Future<Either<Failure, GetModelsResponseEntity>> getAllModels({
    required int page,
  });
}
