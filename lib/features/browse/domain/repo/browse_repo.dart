import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/home/domain/entities/get_models_response_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/browse_asset_entity.dart';

abstract class BrowseRepo {
  Future<List<BrowseAssetEntity>> getAssets();
  Future<Either<Failure, GetModelsResponseEntity>> search({
    String? q,
    String? superCategory,
    String? subFamily,
    String? styleClass,
    required int page,
  });
}
