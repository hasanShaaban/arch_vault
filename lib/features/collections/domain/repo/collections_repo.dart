import '../entities/collection_detail_entity.dart';
import '../entities/collection_entity.dart';

abstract class CollectionsRepo {
  Future<List<CollectionEntity>> getCollections();

  Future<CollectionDetailEntity> getCollectionDetail(String id);

  Future<CollectionEntity> createCollection({
    required String name,
    required String description,
  });

  Future<CollectionEntity> updateCollection({
    required String id,
    required String name,
    required String description,
  });

  Future<void> deleteCollection(String id);
}
