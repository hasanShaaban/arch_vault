import '../entities/model_asset_entity.dart';

abstract class HomeRepo {
  Future<List<ModelAssetEntity>> getFeaturedModels();
}
