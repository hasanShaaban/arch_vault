import '../../../home/domain/entities/model_asset_entity.dart';
import 'collection_entity.dart';

class CollectionDetailEntity {
  const CollectionDetailEntity({
    required this.collection,
    required this.models,
  });

  final CollectionEntity collection;
  final List<ModelAssetEntity> models;
}
