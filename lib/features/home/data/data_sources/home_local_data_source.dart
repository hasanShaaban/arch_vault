import '../../../../core/constants/mock_preview_images.dart';
import '../models/model_asset_model.dart';

abstract class HomeLocalDataSource {
  Future<List<ModelAssetModel>> getFeaturedModels();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<ModelAssetModel>> getFeaturedModels() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return [
      ModelAssetModel(
        id: '1',
        title: 'Modern Villa Atrium',
        label: 'Residential',
        rating: 4.8,
        downloadCount: 310,
        imageUrl: MockPreviewImages.forId('1'),
      ),
      ModelAssetModel(
        id: '2',
        title: 'Glass Office Tower',
        label: 'Commercial',
        rating: 4.5,
        downloadCount: 188,
        imageUrl: MockPreviewImages.forId('2'),
      ),
      ModelAssetModel(
        id: '3',
        title: 'Cultural Pavilion',
        label: 'Public',
        rating: 4.9,
        downloadCount: 412,
        imageUrl: MockPreviewImages.forId('3'),
      ),
      ModelAssetModel(
        id: '4',
        title: 'Courtyard Residence',
        label: 'Residential',
        rating: 4.2,
        downloadCount: 97,
        imageUrl: MockPreviewImages.forId('4'),
      ),
      ModelAssetModel(
        id: '5',
        title: 'Urban Mixed-Use Block',
        label: 'Commercial',
        rating: 4.6,
        downloadCount: 221,
        imageUrl: MockPreviewImages.forId('5'),
      ),
      ModelAssetModel(
        id: '6',
        title: 'Library Annex',
        label: 'Public',
        rating: 4.7,
        downloadCount: 156,
        imageUrl: MockPreviewImages.forId('6'),
      ),
    ];
  }
}
