import '../entities/browse_asset_entity.dart';

abstract class BrowseRepo {
  Future<List<BrowseAssetEntity>> getAssets();
}
