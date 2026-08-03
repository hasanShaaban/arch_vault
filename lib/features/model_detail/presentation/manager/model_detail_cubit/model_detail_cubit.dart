import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/model_detail_entity.dart';
import '../../../domain/repo/model_detail_repo.dart';
import 'model_detail_state.dart';

class ModelDetailCubit extends Cubit<ModelDetailState> {
  ModelDetailCubit(this._repo) : super(const ModelDetailInitial());

  final ModelDetailRepo _repo;

  ModelDetailLoaded get _loaded => state as ModelDetailLoaded;

  Future<void> load(String id) async {
    emit(const ModelDetailLoading());
    try {
      final model = await _repo.getById(id);
      final similar = await _repo.getSimilar(model.similarIds);
      emit(ModelDetailLoaded(model: model, similar: similar));
    } catch (e) {
      emit(ModelDetailFailureState(e.toString()));
    }
  }

  Future<void> download() async {
    if (state is! ModelDetailLoaded) return;
    emit(_loaded.copyWith(isDownloading: true, clearStatus: true));
    try {
      await _repo.downloadModel(_loaded.model.id);
      final updated = ModelDetailEntity(
        id: _loaded.model.id,
        title: _loaded.model.title,
        label: _loaded.model.label,
        fileFormat: _loaded.model.fileFormat,
        rating: _loaded.model.rating,
        downloadCount: _loaded.model.downloadCount + 1,
        description: _loaded.model.description,
        polygonCount: _loaded.model.polygonCount,
        author: _loaded.model.author,
        similarIds: _loaded.model.similarIds,
        image: _loaded.model.image,
      );
      emit(
        _loaded.copyWith(
          model: updated,
          isDownloading: false,
          statusMessage: 'Download started (mock).',
        ),
      );
    } catch (e) {
      emit(
        _loaded.copyWith(
          isDownloading: false,
          statusMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> rate(int stars) async {
    if (state is! ModelDetailLoaded) return;
    emit(_loaded.copyWith(isRating: true, clearStatus: true));
    try {
      final newRating = await _repo.rateModel(
        id: _loaded.model.id,
        stars: stars,
      );
      final updated = ModelDetailEntity(
        id: _loaded.model.id,
        title: _loaded.model.title,
        label: _loaded.model.label,
        fileFormat: _loaded.model.fileFormat,
        rating: double.parse(newRating.toStringAsFixed(1)),
        downloadCount: _loaded.model.downloadCount,
        description: _loaded.model.description,
        polygonCount: _loaded.model.polygonCount,
        author: _loaded.model.author,
        similarIds: _loaded.model.similarIds,
        image: _loaded.model.image,
      );
      emit(
        _loaded.copyWith(
          model: updated,
          isRating: false,
          userRating: stars,
          statusMessage: 'Thanks for rating $stars★ (mock).',
        ),
      );
    } catch (e) {
      emit(
        _loaded.copyWith(
          isRating: false,
          statusMessage: e.toString(),
        ),
      );
    }
  }
}
