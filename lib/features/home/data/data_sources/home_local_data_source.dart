import '../../../../generated/assets.dart';
import '../models/model_asset_model.dart';

abstract class HomeLocalDataSource {
  Future<List<ModelAssetModel>> getFeaturedModels();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<ModelAssetModel>> getFeaturedModels() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const [
      ModelAssetModel(
        id: '1',
        title: 'Modern Villa Atrium',
        label: 'Residential',
        rating: 4.8,
        downloadCount: 310,
        image: Assets.imagesPreviewsVilla,
      ),
      ModelAssetModel(
        id: '2',
        title: 'Glass Office Tower',
        label: 'Commercial',
        rating: 4.5,
        downloadCount: 188,
        image: Assets.imagesPreviewsTower,
      ),
      ModelAssetModel(
        id: '3',
        title: 'Cultural Pavilion',
        label: 'Public',
        rating: 4.9,
        downloadCount: 412,
        image: Assets.imagesPreviewsPavilion,
      ),
      ModelAssetModel(
        id: '4',
        title: 'Courtyard Residence',
        label: 'Residential',
        rating: 4.2,
        downloadCount: 97,
        image: Assets.imagesPreviewsCourtyard,
      ),
      ModelAssetModel(
        id: '5',
        title: 'Urban Mixed-Use Block',
        label: 'Commercial',
        rating: 4.6,
        downloadCount: 221,
        image: Assets.imagesPreviewsMixedUse,
      ),
      ModelAssetModel(
        id: '6',
        title: 'Library Annex',
        label: 'Public',
        rating: 4.7,
        downloadCount: 156,
        image: Assets.imagesPreviewsLibrary,
      ),
    ];
  }
}
