import '../../../../core/errors/failures.dart';
import '../../../../generated/assets.dart';
import '../models/model_detail_model.dart';

abstract class ModelDetailLocalDataSource {
  Future<ModelDetailModel> getById(String id);
  Future<List<SimilarModelModel>> getSimilar(List<String> ids);
  Future<void> downloadModel(String id);
  Future<double> rateModel({required String id, required int stars});
}

class ModelDetailLocalDataSourceImpl implements ModelDetailLocalDataSource {
  static const _catalog = <ModelDetailModel>[
    ModelDetailModel(
      id: '1',
      title: 'Modern Villa Atrium',
      label: 'Residential',
      fileFormat: 'GLTF',
      rating: 4.8,
      downloadCount: 310,
      description:
          'A contemporary villa with an open atrium core, designed for daylight-driven living spaces and clean massing.',
      polygonCount: 124000,
      author: 'studio_arch',
      similarIds: ['4', '5'],
      image: Assets.imagesPreviewsVilla,
    ),
    ModelDetailModel(
      id: '2',
      title: 'Glass Office Tower',
      label: 'Commercial',
      fileFormat: 'FBX',
      rating: 4.5,
      downloadCount: 188,
      description:
          'High-rise office tower with a glazed curtain wall system and modular floor plates for flexible workplace planning.',
      polygonCount: 210000,
      author: 'studio_arch',
      similarIds: ['5', '7'],
      image: Assets.imagesPreviewsTower,
    ),
    ModelDetailModel(
      id: '3',
      title: 'Cultural Pavilion',
      label: 'Public',
      fileFormat: 'OBJ',
      rating: 4.9,
      downloadCount: 412,
      description:
          'A public cultural pavilion with sculptural roofs and generous outdoor thresholds for community gatherings.',
      polygonCount: 98000,
      author: 'atelier_north',
      similarIds: ['6', '8'],
      image: Assets.imagesPreviewsPavilion,
    ),
    ModelDetailModel(
      id: '4',
      title: 'Courtyard Residence',
      label: 'Residential',
      fileFormat: 'GLTF',
      rating: 4.2,
      downloadCount: 97,
      description:
          'A compact courtyard house organized around a quiet central garden for privacy and climate comfort.',
      polygonCount: 76000,
      author: 'atelier_north',
      similarIds: ['1', '6'],
      image: Assets.imagesPreviewsCourtyard,
    ),
    ModelDetailModel(
      id: '5',
      title: 'Urban Mixed-Use Block',
      label: 'Commercial',
      fileFormat: 'FBX',
      rating: 4.6,
      downloadCount: 221,
      description:
          'Mixed-use urban block combining retail podium levels with residential and office volumes above.',
      polygonCount: 188000,
      author: 'studio_arch',
      similarIds: ['2', '7'],
      image: Assets.imagesPreviewsMixedUse,
    ),
    ModelDetailModel(
      id: '6',
      title: 'Library Annex',
      label: 'Public',
      fileFormat: 'OBJ',
      rating: 4.7,
      downloadCount: 156,
      description:
          'An annex library wing with reading halls, soft daylighting, and calm material palettes.',
      polygonCount: 112000,
      author: 'atelier_north',
      similarIds: ['3', '8'],
      image: Assets.imagesPreviewsLibrary,
    ),
    ModelDetailModel(
      id: '7',
      title: 'Skyline Lobby',
      label: 'Commercial',
      fileFormat: 'GLTF',
      rating: 4.3,
      downloadCount: 134,
      description:
          'A double-height lobby interior with refined circulation cores and reception zoning.',
      polygonCount: 64000,
      author: 'studio_arch',
      similarIds: ['2', '5'],
      image: Assets.imagesPreviewsLobby,
    ),
    ModelDetailModel(
      id: '8',
      title: 'Desert Courthouse',
      label: 'Public',
      fileFormat: 'FBX',
      rating: 4.1,
      downloadCount: 76,
      description:
          'A civic courthouse massing adapted to arid climates with shaded courts and thick thermal walls.',
      polygonCount: 145000,
      author: 'atelier_north',
      similarIds: ['3', '6'],
      image: Assets.imagesPreviewsCourthouse,
    ),
  ];

  @override
  Future<ModelDetailModel> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    for (final model in _catalog) {
      if (model.id == id) return model;
    }
    throw const Failure('Model not found');
  }

  @override
  Future<List<SimilarModelModel>> getSimilar(List<String> ids) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _catalog
        .where((m) => ids.contains(m.id))
        .map(
          (m) => SimilarModelModel(
            id: m.id,
            title: m.title,
            label: m.label,
            rating: m.rating,
            image: m.image,
          ),
        )
        .toList();
  }

  @override
  Future<void> downloadModel(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    await getById(id);
  }

  @override
  Future<double> rateModel({required String id, required int stars}) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (stars < 1 || stars > 5) {
      throw const Failure('Rating must be between 1 and 5');
    }
    final model = await getById(id);
    return ((model.rating * 4) + stars) / 5;
  }
}
